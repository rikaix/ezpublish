<form action={concat( '/shop/orderlist' )|ezurl} method="post" name="orderlist">

<div class="context-block">
<h2 class="context-title">{'Orders [%count]'|i18n( 'design/admin/shop/orderlist',, hash( '%count', $order_list|count ) )}</h2>

<div class="context-toolbar">
<div class="block">
<div class="left">
<p>
{section show=eq( ezpreference( 'admin_orderlist_sortfield' ), 'user_name' )}
    <a href={'/user/preferences/set/admin_orderlist_sortfield/time'|ezurl}>{'Time'|i18n( 'design/admin/shop/orderlist' )}</a>
    <span class="current">{'Customer'|i18n( 'design/admin/shop/orderlist' )}</span>
{section-else}
    <span class="current">{'Time'|i18n( 'design/admin/shop/orderlist' )}</span>
    <a href={'/user/preferences/set/admin_orderlist_sortfield/user_name'|ezurl}>{'Customer'|i18n( 'design/admin/shop/orderlist' )}</a>
{/section}
</p>
</div>
<div class="right">
<p>
{section show=eq( ezpreference( 'admin_orderlist_sortorder' ), 'desc' )}
    <a href={'/user/preferences/set/admin_orderlist_sortorder/asc'|ezurl}>{'Ascending'|i18n( 'design/admin/shop/orderlist' )}</a>
    <span class="current">{'Descending'|i18n( 'design/admin/shop/orderlist' )}</span>
{section-else}
    <span class="current">{'Ascending'|i18n( 'design/admin/shop/orderlist' )}</span>
    <a href={'/user/preferences/set/admin_orderlist_sortorder/desc'|ezurl}>{'Descending'|i18n( 'design/admin/shop/orderlist' )}</a>
{/section}
</p>
</div>

<div class="break"></div>

</div>
</div>

{section show=$order_list}
<table class="list" cellspacing="0">
<tr>
    <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/admin/shop/orderlist' )}" title="{'Invert selection.'|i18n( 'design/admin/shop/orderlist' )}" onclick="ezjs_toggleCheckboxes( document.orderlist, 'DeleteIDArray[]' ); return false;" /></th>
	<th class="tight">{'ID'|i18n( 'design/admin/shop/orderlist' )}</th>
	<th class="wide">{'Customer'|i18n( 'design/admin/shop/orderlist' )}</th>
	<th class="tight">{'Total (ex. VAT)'|i18n( 'design/admin/shop/orderlist' )}</th>
	<th class="tight">{'Total (inc. VAT)'|i18n( 'design/admin/shop/orderlist' )}</th>
	<th class="wide">{'Time'|i18n( 'design/admin/shop/orderlist' )}</th>
</tr>
{section var=Orders loop=$order_list sequence=array( bglight, bgdark )}
<tr class="{$Orders.sequence}">
    <td><input type="checkbox" name="DeleteIDArray[]" value="{$Orders.item.id}" /></td>
	<td><a href={concat( '/shop/orderview/', $Orders.item.id, '/' )|ezurl}>{$Orders.item.order_nr}</a></td>
	<td><a href={concat( '/shop/customerorderview/', $Orders.item.user_id, '/', $Orders.item.account_email )|ezurl}>{$Orders.item.account_name}</a></td>
	<td>{$Orders.item.total_ex_vat|l10n( currency )}</td>
	<td>{$Orders.item.total_inc_vat|l10n( currency )}</td>
	<td>{$Orders.item.created|l10n( shortdatetime )}</td>
</tr>
{/section}
</table>
{section-else}
<p>{'The order list is empty'|i18n( 'design/admin/shop/orderlist' )}</p>
{/section}

<div class="context-toolbar">
{include name=navigator
         uri='design:navigator/google.tpl'
         page_uri='/shop/orderlist'
         item_count=$order_list_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>

<div class="controlbar">
<div class="block">
    <input class="button" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/shop/orderlist' )}" {section show=$order_list|not}disabled="disabled"{/section} />
</div>
</div>

</div>

</form>