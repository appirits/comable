$url = $('#navigation_navigation_items_attributes_<%= params[:position] %>_url')
$linkable_id = $('#navigation_navigation_items_attributes_<%= params[:position] %>_linkable_id')

$linkable_id.html('<%= options_for_select(@linkable_id_options) %>')

if <%= params[:linkable_type].blank? %>
  # アドレスを入力する場合
  $linkable_id.closest('.linkable_id').hide()
  $linkable_id.val('')
  $url.closest('.url').show()

else
  $url.closest('.url').hide()
  $url.val('')
  $linkable_id.closest('.linkable_id').show()
