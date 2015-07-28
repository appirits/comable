class @Navigation
  constructor: ->
    $(document).ready(@ready)

  ready: =>
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
    $('#navigation-items').append(field_tags) # タグを追加

  # アイテムの削除
  remove_navigation_item_field: ->
    $(this).parent().prev('.destroy').val(true)
    $(this).closest('fieldset').hide()

  # イベント設定
  add_event: ->
    @navigation_items.on('change', '.linkable_type', @search_linkable_ids)
    @navigation_items.on('click', '.remove_fields', @remove_navigation_item_field)
    @add_fields.click(@adding_navigation_item_field)

