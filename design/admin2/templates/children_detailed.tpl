<script type="text/javascript">
var dataSourceURL = "{concat('ezjscore/call/ezjscnode::subtree::', $node.node_id)|ezurl('no')}";
var rowsPerPage = {$number_of_items};
var sortOrder = {$node.sort_order};
var currentURL = "{$node.url|wash( javascript )}";
var previewURL = {"/content/versionview/%objectID%/%version%"|ezurl};
var editURL = {"/content/edit/%objectID%"|ezurl};

{switch match=$node.sort_field}
{case match='2'}var sortKey="published_date";{/case}
{case match='3'}var sortKey="modified_date";{/case}
{case match='4'}var sortKey="section";{/case}
{case match='7'}var sortKey="class_name";{/case}
{case match='8'}var sortKey="priority";{/case}
{case match='9'}var sortKey="name";{/case}
{case} var sortKey="published_date";{/case}
{/switch}
    
var hiddenColumns = "{ezpreference( 'admin_hidden_columns' )}".split(',');
var labelsObj = {ldelim}


    DATA_TABLE: {ldelim}

                        msg_loading: "{'Loading ...'|i18n( 'design/admin/node/view/full' )|wash('javascript')}"

                    {rdelim},

    DATA_TABLE_COLS: {ldelim}

                        name: "{'Name'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        visibility: "{'Visibility'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        type: "{'Type'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        modifier: "{'Modifier'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        modified: "{'Modified'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        published: "{'Published'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        section: "{'Section'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        priority: "{'Priority'|i18n( 'design/admin/node/view/full' )|wash('javascript')}"

                    {rdelim},

    TABLE_OPTIONS: {ldelim}
                        header: "{'Table options'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        header_noipp: "{'Number of items per page:'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        header_vtc: "{'Visible table columns:'|i18n( 'design/admin/node/view/full' )|wash('javascript')}"

                   {rdelim},

    ACTION_BUTTONS: {ldelim}

                        select: "{'Select'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        select_sav: "{'Select all visible'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        select_sn: "{'Select none'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        create_new: "{'Create new'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        more_actions: "{'More actions'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        more_actions_rs: "{'Remove selected'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        more_actions_ms: "{'Move selected'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        more_actions_no: "{'Use the checkboxes to select one or more items.'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        table_options: "{'Table options'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        first_page: "&laquo;&nbsp;{'first'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        previous_page: "&lsaquo;&nbsp;{'prev'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        next_page: "{'next'|i18n( 'design/admin/node/view/full' )|wash('javascript')}&nbsp;&rsaquo;",
                        last_page: "{'last'|i18n( 'design/admin/node/view/full' )|wash('javascript')}&nbsp;&raquo;"

                    {rdelim},

    CONTEXT_MENU: {ldelim}

                        preview: "{'Preview'|i18n( 'design/admin/node/view/full' )|wash('javascript')}",
                        edit: "{'Edit'|i18n( 'design/admin/node/view/full' )|wash('javascript')}"

                    {rdelim},


{rdelim};

{if and( $node.is_container,  $node.can_create)}
    {if $node.path_array|contains( ezini( 'NodeSettings', 'MediaRootNode', 'content.ini' ) )}
        {def $group_id = array( ezini( 'ClassGroupIDs', 'Users', 'content.ini' ),
                                ezini( 'ClassGroupIDs', 'Setup', 'content.ini' ) )}
    {elseif $node.path_array|contains( ezini( 'NodeSettings', 'UserRootNode', 'content.ini' ) )}
        {def $group_id = array( ezini( 'ClassGroupIDs', 'Setup', 'content.ini' ),
                                ezini( 'ClassGroupIDs', 'Content', 'content.ini' ),
                                ezini( 'ClassGroupIDs', 'Media', 'content.ini' ) )}
    {else}
        {def $group_id = false()}
    {/if}

    {def $can_create_classes = fetch( 'content', 'can_instantiate_class_list', hash( 'parent_node', $node,
                                                                                     'filter_type', 'exclude',
                                                                                     'group_id', $group_id,
                                                                                     'group_by_class_group', true() ) )}

    var createNewBthGroups = [
    
    {foreach $can_create_classes as $group}
        "{$group.group_name}"
        {delimiter}
        ,
        {/delimiter}
    {/foreach}
    
    ];
    
    var createNewBtnActions = [
    
    {foreach $can_create_classes as $group}
        [
            {foreach $group.items as $can_create_class}
                {if $can_create_class.can_instantiate_languages}
                {ldelim} text: "{$can_create_class.name|wash()}", value: {$can_create_class.id} {rdelim}
    
                {delimiter},{/delimiter}
                {/if}
            {/foreach}
        ]
        {delimiter}
        ,
        {/delimiter}
    {/foreach}
    
    ];
    
{else}
    var createNewBthGroups = [];
    var createNewBtnActions = [];
{/if}


{literal}
(function() {
    YUILoader.onSuccess = function() {

        var formatName = function(cell, record, column, data) {
            cell.innerHTML =  record.getData('class_icon') + '&nbsp' + '<a href="' + record.getData('url') + '" title="' + data + '">' + data + '</a>';
        }

        var customCheckbox = function(cell, record, column, data) {
            cell.innerHTML = '<input type="checkbox" name="DeleteIDArray[]" value="' + record.getData('node_id') + '" />';
        }

        var updatePriority = function(callback, v) {
            var record = this.getRecord(), dataTable = this.getDataTable(), sortedBy = dataTable.get('sortedBy'), paginator = dataTable.get('paginator');
            
            var onSuccess = function(data) {
                if (sortedBy.key == 'priority') {
                    dataTable.onPaginatorChangeRequest(paginator.getState({'page':paginator.getCurrentPage()}));
                }
            }
            
            jQuery.post(jQuery.ez.url + 'call/ezjscnode::updatepriority', { ContentNodeID: record.getData('parent_node_id'), 
                                                                            PriorityID: [record.getData('node_id')], 
                                                                            Priority:  [v] }, onSuccess );
            callback(true, v);
        }

        var columnDefs = [
            {key:"", Label:"", formatter:customCheckbox},
            {key:"name", label:labelsObj.DATA_TABLE_COLS.name, sortable:true, resizeable:true, formatter:formatName},
            {key:"hidden_status_string", label: labelsObj.DATA_TABLE_COLS.visibility, sortable:false, resizeable:true},
            {key:"class_name", label:labelsObj.DATA_TABLE_COLS.type, sortable:true, resizeable:true},
            {key:"creator", label:labelsObj.DATA_TABLE_COLS.modifier, sortable:false, resizeable:true},
            {key:"modified_date", label:labelsObj.DATA_TABLE_COLS.modified, sortable:true, resizeable:true},
            {key:"published_date", label:labelsObj.DATA_TABLE_COLS.published, sortable:true, resizeable:true, hidden:false},
            {key:"section", label:labelsObj.DATA_TABLE_COLS.section, sortable:true, resizeable:true},
            {key:"priority", label: labelsObj.DATA_TABLE_COLS.priority, sortable:true, resizeable:true, 
                editor: new YAHOO.widget.TextboxCellEditor({asyncSubmitter: updatePriority, disableBtns:true, validator:YAHOO.widget.DataTable.validateNumber}) }
        ];

        // Hide columns
        for (var i = 0, l = columnDefs.length; i < l; i++) {
            var columnDef = columnDefs[i];
            
            if ((jQuery.inArray(columnDef.key, hiddenColumns) != -1) && columnDef.key != '')
                columnDef.hidden = true;
        }

        var sectionParser = function(section) {
            return section.name;
        }

        var creatorParser = function(creator) {
            return creator.name;
        }

        var dataSource = new YAHOO.util.DataSource(dataSourceURL);
        dataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;
        dataSource.responseSchema = {
            resultsList: "content.list",
            fields: [
                {key:"name"},
                {key:"modified_date", },
                {key:"hidden_status_string"},
                {key:"class_name"},
                {key:"creator", parser:creatorParser},
                {key:"section", parser:sectionParser},
                {key:"priority"},
                {key:"url"},
                {key:"class_icon"},
                {key:"node_id"},
                {key:"parent_node_id"},
                {key:"published_date"},
                {key:"contentobject_id"},
                {key:"version"}
            ],
            metaFields: {
                totalRecords: "content.total_count" // Access to value in the server response
            }
        };

        var paginator = new YAHOO.widget.Paginator({ rowsPerPage:rowsPerPage,
                                                     containers: ["bpg"], 
                                                     firstPageLinkLabel : labelsObj.ACTION_BUTTONS.first_page,
                                                     lastPageLinkLabel : labelsObj.ACTION_BUTTONS.last_page,
                                                     previousPageLinkLabel : labelsObj.ACTION_BUTTONS.previous_page,
                                                     nextPageLinkLabel : labelsObj.ACTION_BUTTONS.next_page,
                                                     template : '<div class="yui-pg-backward"> {FirstPageLink} {PreviousPageLink} </div>' +
                                                                '{PageLinks}' + 
                                                                '<div class="yui-pg-forward"> {NextPageLink} {LastPageLink} </div>'
                                                     });
        
        paginator.subscribe('render', function () {
            var prevPageLink, prevPageLink, prevPageLinkNode, nextPageLinkNode, tpg;

            tpg = YAHOO.util.Dom.get('tpg');

            // Instantiate the UI Component
            prevPageLink = new YAHOO.widget.Paginator.ui.PreviousPageLink(this);
            nextPageLink = new YAHOO.widget.Paginator.ui.NextPageLink(this);

            // render the UI Component
            prevPageLinkNode = prevPageLink.render(tpg);
            nextPageLinkNode = nextPageLink.render(tpg);

            // Append the generated node into the container
            tpg.appendChild(prevPageLinkNode);
            tpg.appendChild(nextPageLinkNode);
        });

        var buildQueryString = function (state,dt) {
                return "::" + state.pagination.rowsPerPage +
                       "::" + state.pagination.recordOffset +
                       "::" + state.sortedBy.key +
                       "::" + ((state.sortedBy.dir === YAHOO.widget.DataTable.CLASS_ASC) ? "1" : "0") +
                       "?ContentType=json";
        };

        var config = {
            initialRequest: "::" + rowsPerPage + "::0" + "::" + sortKey + "::" + sortOrder + "?ContentType=json",           // Initial request for first page of data
            dynamicData: true,                                                                                              // Enables dynamic server-driven data
            generateRequest: buildQueryString,
            sortedBy : {key:sortKey, 
                        dir:((sortOrder === "1") ? YAHOO.widget.DataTable.CLASS_ASC : YAHOO.widget.DataTable.CLASS_DESC) }, // Sets UI initial sort arrow
            paginator: paginator,                                                                                           // Enables pagination
            MSG_LOADING: labelsObj.DATA_TABLE.msg_loading
        };

        var subItemsTable = new YAHOO.widget.DataTable( "content-sub-items-list",
                                                        columnDefs,
                                                        dataSource,
                                                        config );

        // Cell editing
        var highlightEditableCell = function(oArgs) {
            var elCell = oArgs.target;
            if (YAHOO.util.Dom.hasClass(elCell, "yui-dt-editable")) {
                this.highlightCell(elCell);
            }
        };
        
        subItemsTable.subscribe("cellMouseoverEvent", highlightEditableCell);
        subItemsTable.subscribe("cellMouseoutEvent", subItemsTable.onEventUnhighlightCell);
        subItemsTable.subscribe("cellClickEvent", subItemsTable.onEventShowCellEditor);
        
        // Update totalRecords on the fly with value from server
        subItemsTable.handleDataReturnPayload = function(oRequest, oResponse, oPayload) {
            oPayload.totalRecords = oResponse.meta.totalRecords;
            return oPayload;
        }

        // Table options

        // Shows dialog, creating one when necessary
        var colLayoutHasChanged = true;
        var showTblOptsDialog = function(e) {
            YAHOO.util.Event.stopEvent(e);

            if (colLayoutHasChanged) {
                // Populate Dialog
                var colOptionsHTML = '<fieldset>';
                colOptionsHTML += '<legend>' + labelsObj.TABLE_OPTIONS.header_noipp + '</legend><div class="block">';

                var rowsPerPageDef = [ {id:1, count:10}, {id:2, count:25}, {id:3, count:50} ];

                for (var i = 0, l = rowsPerPageDef.length; i < l ; i++) {
                    var rowDef = rowsPerPageDef[i];
                    colOptionsHTML += '<div class="table-options-row"><span class="table-options-key">'+ rowDef.count + '</span>';
                    colOptionsHTML += '<span class="table-options-value"><input id="table-option-row-btn-' + rowDef.id + '" type="radio" name="TableOptionValue" value="' + rowDef.count + '"' + ( rowsPerPage == rowDef.count ? ' checked="checked"' : '' ) + ' /></span></div>';

                    YAHOO.util.Event.on("table-option-row-btn-" + rowDef.id, "click", function(e, a) {
                        paginator.setRowsPerPage(a.count);
                        jQuery.post( jQuery.ez.url.replace( 'ezjscore/', 'user/preferences/set_and_exit/admin_list_limit/' ) + a.id );
                    }, rowDef);
                }

                colOptionsHTML += '</div></fieldset><br />';
                colOptionsHTML += '<fieldset>';
                
                var columns = subItemsTable.getColumnSet().keys;
                colOptionsHTML += '<legend>' + labelsObj.TABLE_OPTIONS.header_vtc + '</legend><div class="block">';

                // Create one section in the SimpleDialog for each column
                for (var i = 0, l = columns.length; i < l; i++) {
                    var column = columns[i], label = column.getDefinition().label, key = column.getDefinition().key;

                    // Skip empty columns
                    if (!label || !key)
                        continue;

                    colOptionsHTML += '<div class="table-options-row"><span class="table-options-key">'+ label + '</span>';
                    colOptionsHTML += '<span class="table-options-value"><input id="table-option-col-btn-' + i + '" type="checkbox" name="TableOptionColumn" value="' + key + '"' + ( jQuery.inArray( key, hiddenColumns ) < 0 ? ' checked="checked"' : ''  ) + ' /></span></div>';

                    YAHOO.util.Event.on("table-option-col-btn-" + i, "click", function(e, a) {
                        if (this.checked) {
                            subItemsTable.showColumn(a);
                        }
                        else {
                            subItemsTable.hideColumn(a);
                        }
                        var hiddenKeys = [];
                        $('#to-dialog-container input[name=TableOptionColumn]').each(function(i, e) {
                            if ($(this).attr('checked') == false)
                                hiddenKeys.push( $(this).attr('value') );
                        });
                       
                        jQuery.post( jQuery.ez.url.replace( 'ezjscore/', 'user/preferences/set_and_exit/admin_hidden_columns/' ) + hiddenKeys.join(',') );
                    }, key);
                }

                colOptionsHTML += '</div></fieldset>';
                
                tblOptsDialog.setBody(colOptionsHTML);
                colLayoutHasChanged = false;
            }
            tblOptsDialog.show();
        };

        var hideTblOptsDialog = function(e) {
            this.hide();
        };

        
        // SimpleDialog for Table options
        
        var tblOptsDialog = new YAHOO.widget.SimpleDialog("to-dialog-container", { width: "25em",
                                                                                   visible: false,
                                                                                   modal: true,
                                                                                   buttons: [ { text: "Close", 
                                                                                                handler: hideTblOptsDialog } ],
                                                                                   fixedcenter: true,
                                                                                   constrainToViewport: true });

        var escKeyListener = new YAHOO.util.KeyListener(document, { keys:27 },
                                                                  { fn:tblOptsDialog.hide,
                                                                    scope:tblOptsDialog,
                                                                    correctScope:true } );

        tblOptsDialog.cfg.queueProperty("keylisteners", escKeyListener);
        tblOptsDialog.setHeader(labelsObj.TABLE_OPTIONS.header);
        tblOptsDialog.render();

        
        // Toolbar buttons: Select, Create new, More actions

        var selectItemsBtnAction = function( type, args, item ) {
            $('#content-sub-items-list').find(':checkbox').attr('checked', item.value);
        }

        var selectItemsBtnActions = [
            { text: labelsObj.ACTION_BUTTONS.select_sav, id: "ezopt-menu-check", value: 1, onclick: { fn: selectItemsBtnAction } },
            { text: labelsObj.ACTION_BUTTONS.select_sn, id: "ezopt-menu-uncheck", value: 0, onclick: { fn: selectItemsBtnAction } }
        ];

        var selectItemsBtn = new YAHOO.widget.Button({ type: "menu",
                                                       id: "ezbtn-items",
                                                       label: labelsObj.ACTION_BUTTONS.select,
                                                       name: "select-items-button",
                                                       menu: selectItemsBtnActions,
                                                       container:"action-controls" });
    
        var createNewBtnAction = function( type, args ) {
            var event = args[0], item = args[1];
            $('form[name=children]').append($('<input type="hidden" name="ClassID" value="' + item.value + '" />')).append($('<input type="hidden" name="NewButton" />')).submit();
        }

        var createNewBtn = new YAHOO.widget.Button({ type: "menu",
                                                     id: "ezbtn-new",
                                                     label: labelsObj.ACTION_BUTTONS.create_new,
                                                     name: "create-new-button",
                                                     menu: createNewBtnActions,
                                                     container:"action-controls" });

        var createNewBtnMenu  = createNewBtn.getMenu();
        createNewBtnMenu.cfg.setProperty("scrollincrement", 5);
        createNewBtnMenu.subscribe("click", createNewBtnAction);
        
        for (var i = 0, l = createNewBthGroups.length; i < l; i++) {
            var groupName = createNewBthGroups[i];
            createNewBtnMenu.setItemGroupTitle(groupName, i);
        }

        var moreActBtnAction = function( type, args, item ) {
            if ($('form[name=children] input[name=DeleteIDArray[]]:checked').length == 0)
                return;

            if (item.value == 0) {
                $('form[name=children]').append($('<input type="hidden" name="RemoveButton" />')).submit();
            } else {
                $('form[name=children]').append($('<input type="hidden" name="MoveButton" />')).submit();
            }
        }

        var moreActBtnActions = [
            { text: labelsObj.ACTION_BUTTONS.more_actions_rs, id: "ezopt-menu-remove", value: 0, onclick: { fn: moreActBtnAction }, disabled: false },
            { text: labelsObj.ACTION_BUTTONS.more_actions_ms, id: "ezopt-menu-move", value: 1, onclick: { fn: moreActBtnAction }, disabled: false }
        ];

        var noMoreActBtnActions = [
            { text: labelsObj.ACTION_BUTTONS.more_actions_no, disabled: true }
        ];

        var moreActBtn = new YAHOO.widget.Button({ type: "menu",
                                                   id: "ezbtn-more",
                                                   label: labelsObj.ACTION_BUTTONS.more_actions,
                                                   name: "more-actions-button",
                                                   menu: noMoreActBtnActions,
                                                   container:"action-controls" });
        
        //  enable menuitems when rows are checked
        moreActBtn.getMenu().subscribe("beforeShow", function () {
            if ($('form[name=children] input[name=DeleteIDArray[]]:checked').length == 0) {
                this.clearContent();
                this.addItems(noMoreActBtnActions);
                this.render();
            } else {
                this.clearContent();
                this.addItems(moreActBtnActions);
                this.render();
            }
        });
        
        var tableOptionsBtn = new YAHOO.widget.Button({ label: labelsObj.ACTION_BUTTONS.table_options,
                                                        id:"ezbtn-options",
                                                        container:"action-controls",
                                                        onclick: { fn: showTblOptsDialog, obj: this, scope: true } });

        // Context menu on right-click
        
        var contextMenuItemAction = function(type, args, dt) {
            var task = args[1];
            if (!task)
                return;

            var row = dt.getTrEl(this.contextEventTarget);
            if (!row)
                return;
        }

        var contextMenuShowAction = function(type, args, dt){ 
            var row = dt.getTrEl(this.contextEventTarget);
            dt.selectRow(row);

            // Right alignes the menu within the clicked tr
            //this.cfg.setProperty('context', [row, 'tr', 'br']);

            //  Updates URL-"macros" in menuitems according to the selected node
            var record = dt.getRecord(row);
            var nodeId = record.getData('node_id');
            var objectId = record.getData('contentobject_id');
            var version = record.getData('version');

            var items = this.getItems();
            var len=items.length;
            for (var i=0; i<len; i++) {
                var item = items[i];
                var url = item.cfg.getProperty('url');
                url = url.replace('%nodeID%', nodeId);
                url = url.replace('%objectID%', objectId);
                url = url.replace('%currentURL%', currentURL);
                url = url.replace('%version%', version);
                item.cfg.setProperty('url', url);
            }
        }

        var contextMenuHideAction = function(type, args, dt) {
            var row = dt.getTrEl(this.contextEventTarget);
            dt.unselectRow(row);
        }

        var contextMenu = new YAHOO.widget.ContextMenu("ezdt-context-menu", {trigger:subItemsTable.getTbodyEl()});
        contextMenu.cfg.setProperty("scrollincrement", 5);
        contextMenu.addItem({ text: labelsObj.CONTEXT_MENU.edit, id: "ezopt-menu-edit", url: editURL});
        contextMenu.addItem({ text: labelsObj.CONTEXT_MENU.preview, id: "ezopt-menu-preview", url: previewURL});

        var whiteList = ['advanced', 'contextmenu'];        // Accepted menus (note: using keys, since not all menus have headerID)

        $(menuArray).each(function() {                                      // Loop array returned from jquery
            var group = 0;
            $.each(this, function(key, value) {                             // Loop menuArray
                var k = jQuery.trim(key).toLowerCase();
                if (jQuery.inArray(k, whiteList) != -1) {                   // Validate menu against whiteList
                    if (this.elements && this.elements.length != 0) {       // check for valid menu items
                        $.each( this.elements, function(key, value) {       // Loop menu element per group
                            if ($('#' + key).text() && value.url) {         // Check if element has html-markup'ed text
                                contextMenu.addItem({ text: $('#' + key).text(), id:"ezopt-" + key, url: value.url }, group);
                            }
                        });
                    }
                    //contextMenu.setItemGroupTitle(k, group); 
                    group += 1;
                }
            });
        });

        //  hide the focus outline for MenuItem instances
        contextMenu.subscribe("render", function () {
            $.each(this.getItems(), function() {
                this.element.firstChild.hideFocus = true;
                });
        });

        // Render the ContextMenu instance to the parent container of the DataTable
        contextMenu.render('content-sub-items-list');
        
        contextMenu.clickEvent.subscribe(contextMenuItemAction, subItemsTable);
        contextMenu.subscribe('beforeShow', contextMenuShowAction, subItemsTable);
        contextMenu.subscribe('hide', contextMenuHideAction, subItemsTable);
    }

    YUILoader.require(['datatable', 'button', 'container']);

    // Load the files using the insert() method.
    var options = [];
    YUILoader.insert(options, 'js');
})();
{/literal}
</script>

<div id="action-controls-container">
    <div id="action-controls"></div>
    <div id="tpg"></div>
</div>
<div id="content-sub-items-list" class="content-navigation-childlist"></div>
<div id="bpg"></div>

<div id="to-dialog-container"></div>
