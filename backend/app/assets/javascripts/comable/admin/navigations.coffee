class @Navigation
  constructor: ->
    @navigation_items = $('#navigation-items')
    @add_fields = $('.add_fields')
    @add_event()

  # linkable_idの検索
  search_linkable_ids: ->
    $linkable_type = $('#linkable_type')
    $position = $('#position')
    $linkable_type.val($(this).val())
    $position.val($('.linkable_type').index(this))
    $linkable_type.closest('form').submit()

  # アイテムの追加
  adding_navigation_item_field: ->
    regexp = new RegExp($(this).data('index'), 'g')
    field_tags = $(this).data('fields').replace(regexp,  $('.navigation-item').length) # 置換予定文字を添字に置換する
    $field = $(field_tags)
    $field.addClass('js-new-record')
    $('#navigation-items').append($field) # タグを追加

  # アイテムの削除
  remove_navigation_item_field: ->
    $navigation_item = $(this).closest('.navigation-item')
    if $navigation_item.hasClass('js-new-record')
      $navigation_item.remove()
    else
      $navigation_item.find('.destroy').val(true)
      $navigation_item.addClass('hidden')

  # イベント設定
  add_event: ->
    @navigation_items.on('change', '.linkable_type', @search_linkable_ids)
    @navigation_items.on('click', '.remove_fields', @remove_navigation_item_field)
    @add_fields.click(@adding_navigation_item_field)

