can_comable_tagit = ->
  return false unless comable_tagit_available_tags?
  return false unless $("#comable-tagit").length
  true

initializa_comable_tagit = ->
  return unless can_comable_tagit()

  $("#comable-tagit").tagit({
    fieldName: 'product[category_path_names][]',
    availableTags: comable_tagit_available_tags,
    autocomplete: { delay: 0, minLength: 0 },
    showAutocompleteOnFocus: true,
    removeConfirmation: true,
    # Only allow available tags
    beforeTagAdded: (event, ui) -> (comable_tagit_available_tags.indexOf(ui.tagLabel) != -1)
  })

$(document).ready(->
  initializa_comable_tagit()
)

class @Product
  constructor: ->
    @radio_published = $('#product_published_at_published')
    @radio_unpublished = $('#product_published_at_unpublished')
    @published_at = $('#product_published_at')
    @property = $('#product_property')
    @properties = $('#properties')
    @add_property = $('.add_property')

    @initialize_visibility()
    @add_event_to_set_visibility()
    @add_event_to_property()

  # 公開/非公開の制御
  initialize_visibility: ->
    if @radio_published.is(':checked')
      @published()
    if @radio_unpublished.is(':checked')
      @unpublished()

  # 公開の際の制御
  published: =>
    @published_at.show()
    @published_at.val(moment().format('YYYY-MM-DD HH:mm')) unless @published_at.val()

  # 非公開の際の制御
  unpublished: =>
    @published_at.hide()
    @published_at.val('')

  add_event_to_set_visibility: ->
    @radio_published.click(@published)
    @radio_unpublished.click(@unpublished)

    # 日付を空にされたら非公開にする
    @published_at.blur( =>
      @radio_unpublished.click() unless @published_at.val()
    )

  add_event_to_property: ->
    @properties.on('change', 'input', @reset_property)
    @properties.on('click', '.remove_property', @remove_property)
    @properties.on('click', '.remove_property', @reset_property)
    @add_property.click(@adding_property_field)

  reset_property: =>
    property_attrbutes = $('.property').map( (_index, property) ->
      property_key = $(property).find('.property_key').val()
      property_value = $(property).find('.property_value').val()
      return unless property_key && property_value
      {
        'property_key': property_key,
        'property_value': property_value
      }
    )
    @property.val(JSON.stringify(property_attrbutes.get()))

  remove_property: ->
    $(this).closest('tr').remove()

  adding_property_field: ->
    field_tags = $(this).data('fields')
    $field = $(field_tags)
    $('#properties').append($field) # タグを追加
