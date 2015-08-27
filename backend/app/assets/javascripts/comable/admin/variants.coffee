class @Variant
  initialized: false

  constructor: ->
    @initialize_tagits()
    @register_click_event_to_add_option_button()
    @register_click_event_to_remove_option_button()
    @initialized = true

  initialize_tagits: ->
    _this = @
    $('.js-tagit-option-values').each( ->
      _this.initialize_tagit(this)
    )

  initialize_tagit: (element) ->
    $element = $(element)
    index = $element.data('index')
    $element.tagit({
      fieldName: 'product[option_types_attributes][' + index + '][values][]',
      caseSensitive: false,
      removeConfirmation: true,
      readOnly: $element.hasClass('tagit-readonly'),
      afterTagAdded: @rebuild_variants,
      afterTagRemoved: @rebuild_variants
    })

  register_click_event_to_add_option_button: ->
    $('.js-add-option').click( =>
      @change_from_master()
      setTimeout( =>
        @initialize_tagits()
      , 1)
    )

  register_click_event_to_remove_option_button: ->
    $(document).on('click', '.js-remove-option', ->
      $(this).closest('.js-new-variants').remove()
      @change_to_master()
    )

  rebuild_variants: (event, ui) =>
    return unless @initialized
    @remove_variants()
    @build_variants()

  build_variants: ->
    _this = @
    option_types = []
    $('.js-tagit-option-values').each( ->
      return unless $(this).hasClass('tagit')
      option_values = $(this).tagit('assignedTags')
      option_types.push(option_values)
    )
    option_values_for_variants = _product(_compact(option_types))
    option_values_for_variants.forEach((option_values_for_variant) ->
      _this.build_variant(option_values_for_variant)
    )

  build_variant: (option_values) ->
    $variant = @new_variant()

    $variant.find('[data-name="names"] > input').val(option_values)
    option_values.forEach((option_value) ->
      $variant.find('[data-name="names"]').append('<span class="comable-variant-name">' + option_value + '</span> ')
    )

    $('.js-variants-table').find('tbody').append($variant)

  remove_variants: ->
    $('.js-new-variants:not(.hidden)').remove()

  new_variant: ->
    new_id = new Date().getTime()
    $('.js-add-variant').click()
    $variant = $('.js-new-variants').last()
    $variant.removeClass('hidden')
    $variant.html($variant.html().replace(/new_variant/g, new_id))
    $variant

  change_from_master: ->
    $('.js-variants-table').removeClass('hidden')
    $('#product_variants_attributes_0__destroy').val(1)

  change_to_master: ->
    $('.js-variants-table').removeClass('hidden')
    $('.js-variants-table').addClass('hidden')
    $('#product_variants_attributes_0__destroy').val(0) if $('.js-new-variants').length == 0

  # refs http://stackoverflow.com/questions/281264/remove-empty-elements-from-an-array-in-javascript/2843625#2843625
  _compact = (arrays) ->
    $.grep(arrays, (n) -> n if n && n.length != 0)

  # refs http://cwestblog.com/2011/05/02/cartesian-product-of-multiple-arrays/
  _product = (arrays) ->
    Array.prototype.reduce.call(arrays, (a, b) ->
      ret = []
      a.forEach((a) ->
        b.forEach((b) ->
          ret.push(a.concat([b]))
        )
      )
      ret
    , [[]])
