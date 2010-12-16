<?php
/**
 * File containing the ezpContentPublishingQueueProcess class.
 *
 * @copyright Copyright (C) 1999-2010 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPL v2
 * @version //autogentag//
 * @package kernel
 * @subpackage content
 */

/**
 * This class provides a PersistentObject interface to a publishing queue process.
 * @package kernel
 * @subpackage content
 */
class ezpContentPublishingProcess extends eZPersistentObject
{
    const STATUS_WORKING = 1;
    const STATUS_FINISHED = 2;
    const STATUS_PENDING = 3;


    /**
     * eZPersistentObject definition
     * @return array
     */
    public static function definition()
    {
        static $definition = array(
             'fields' => array( 'ezcontentobject_version_id' => array( 'name' => 'ContentObjectVersionID',
                                                                       'datatype' => 'integer',
                                                                       'default' => 0,
                                                                       'required' => true,
                                                                       'foreign_class' => 'eZContentObjectVersion',
                                                                       'foreign_attribute' => 'id',
                                                                       'multiplicity' => '1..*' ),
                                'pid' => array( 'name' => 'PID',
                                                'datatype' => 'integer',
                                                'default' => 0,
                                                'required' => false ),
                                'status' => array( 'name' => 'Status',
                                                   'datatype' => 'integer',
                                                   'default' => 0,
                                                   'required' => true ),
                                'started' => array( 'name' => 'Started',
                                                    'datatype' => 'integer',
                                                    'default' => 0,
                                                    'required' => true ),
                                'created' => array( 'name' => 'Created',
                                                    'datatype' => 'integer',
                                                    'default' => 0,
                                                    'required' => true ),
                                'finished' => array( 'name' => 'Finished',
                                                     'datatype' => 'integer',
                                                     'default' => 0,
                                                     'required' => true ) ),
                      'keys' => array( 'ezcontentobject_version_id' ),
                      'function_attributes' => array( 'version' => 'version' ),
                      'class_name' => 'ezpContentPublishingProcess',
                      'increment_key' => null,
                      'sort' => array( 'created' => 'asc' ),
                      'name' => 'ezpublishingqueueprocesses' );
        return $definition;
    }

    /**
     * Returns the version object the process is linked to
     * @return eZContentObjectVersion
     */
    public function version()
    {
        if ( $this->versionObject === null )
            $this->versionObject = eZContentObjectVersion::fetch( $this->attribute( 'ezcontentobject_version_id' ) );

        return $this->versionObject;
    }

    /**
     * Fetches a process by its content object version
     * @param int $contentObjectVersionId
     * @return ezpContentPublishingProcess
     */
    public static function fetchByContentVersionId( $contentObjectVersionId )
    {
        return parent::fetchObject(
            self::definition(),
            false,
            array( 'ezcontentobject_version_id' => $contentObjectVersionId )
        );
    }

    /**
     * Fetches a process by its content object ID + version
     * @param int $contentObjectId
     * @param int $version
     * @return ezpContentPublishingProcess
     */
    public static function fetchByContentObjectVersion( $contentObjectId, $version )
    {
        $contentObjectVersion = eZContentObjectVersion::fetchVersion( $version, $contentObjectId );
        if ( $contentObjectVersion instanceof eZContentObjectVersion )
        {
            $return = self::fetchByContentVersionId( $contentObjectVersion->attribute( 'id' ) );
            return $return;
        }
        else
        {
            return false;
        }
    }

    /**
     * Returns the number of currently working publishing processes
     * @return int
     */
    public static function currentWorkingProcessCount()
    {
        return self::count( self::definition(), array( 'status' => self::STATUS_WORKING ) );
    }

    /**
     * Checks if an object is already being processed
     * @param eZContentObjectVersion $versionObject
     * @return bool
     */
    public static function isProcessing( eZContentObjectVersion $versionObject )
    {
        $count = parent::count(
            self::definition(),
            array(
                'ezcontentobject_version_id' => $versionObject->attribute( 'id' ),
                // 'status' => self::STATUS_WORKING // not used yet
            )
        );
        return ( $count != 0 );
    }

    /**
     * Starts the publishing process for the linked version
     * @return bool
     */
    public function publish()
    {
        $contentObjectId = $this->version()->attribute( 'contentobject_id' );
        $contentObjectVersion = $this->version()->attribute( 'version' );

        // $processObject = ezpContentPublishingProcess::fetchByContentObjectVersion( $contentObjectId, $contentObjectVersion );
        $this->setAttribute( 'status', self::STATUS_WORKING );
        $this->store( array( 'status' ) );

        $pid = pcntl_fork();

        // force the DB connection closed
        $db = eZDB::instance();
        $db->IsConnected = false;
        $db = null;
        eZDB::setInstance( null );

        // error, cancel
        if ( $pid == -1 )
        {
            $this->setAttribute( 'status', self::STATUS_PENDING );
            $this->store( array( 'status' ) );
            return false;
        }
        else if ( $pid )
        {
            return $pid;
        }
        // child process
        else
        {
            $myPid = getmypid();
            pcntl_signal(SIGCHLD, SIG_IGN);

            fclose( STDERR );

            $this->setAttribute( 'pid', $myPid );
            $this->store( array( 'pid' ) );

            eZOperationHandler::execute( 'content', 'publish', array( 'object_id' => $contentObjectId, 'version' => $contentObjectVersion  ) );

            // mark the process as completed
            $this->setAttribute( 'status', self::STATUS_FINISHED );
            $this->store( array( 'status' ) );

            // Make sure this is correct
            eZScript::instance()->shutdown();
            exit;
        }

        return true;
    }

    /**
     * Adds a version to the publishing queue
     * @param eZContentObjectVersion $version
     * @return ezpContentPublishingProcess
     */
    public static function queue( eZContentObjectVersion $version )
    {
        $row = array(
            'ezcontentobject_version_id' => $version->attribute( 'id' ),
            'created' => time(),
            'status' => self::STATUS_PENDING,
         );
        $processObject = new self( $row );
        $processObject->store();

        return $processObject;
    }

    /**
     * Fetches processes, filtered by status
     * @param int $status One of ezpContentPublishingProcess::STATUS_*
     * @return array( ezpContentPublishingProcess )
     */
    public static function fetchProcesses( $status )
    {
        if ( !in_array( $status, array( self::STATUS_FINISHED, self::STATUS_PENDING, self::STATUS_WORKING ) ) )
            throw new ezcBaseValueException( '$status', $status, array( self::STATUS_FINISHED, self::STATUS_PENDING, self::STATUS_WORKING ), 'parameter' );

        return parent::fetchObjectList( self::definition(), false,
            array( 'status' => $status ),
            array( 'created' => 'asc' ) );
    }

    /**
     * Checks if the system process is running
     *
     * @return bool
     * @throws Exception if the process isn't in WORKING status
     */
    public function isAlive()
    {
        if ( $this->attribute( 'status' ) != self::STATUS_WORKING )
            throw new Exception( 'The process\'s status isn\'t \'working\'' );

        // sending 0 only checks if the process is alive (and if the current process is allowed to send signals to it)
        $return = ( posix_kill( $this->attribute( 'pid' ), 0 ) === true );
        return $return;
    }

    /**
     * Resets the current process to the PENDING state
     *
     * @todo Monitor the reset operation, using some kind of counter. The process must NOT get high priority, as it
     *       might block a slot if it fails constantly
     *       Maybe use a STATUS_RESET status, that gives lower priority to the item
     */
    public function reset()
    {
        echo "* reset: ContentObjectVersionID #" . $this->attribute( 'ezcontentobject_version_id' ) . "\n";
        $this->setAttribute( 'status', self::STATUS_PENDING );
        $this->setAttribute( 'pid', 0 );
        $this->store( array( 'status', 'pid' ) );
    }

    private $versionObject = null;
}
?>