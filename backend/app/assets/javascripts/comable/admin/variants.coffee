class @Variant
  initialized: false

  constructor: ->
    @initialize_tagits()
    @register_click_event_to_add_variant_button()
    @register_click_event_to_remove_variant_button()
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
      afterTagAdded: @rebuild_variants,
      afterTagRemoved: @rebuild_variants
    })

  register_click_event_to_add_variant_button: ->
    $('.js-add-variats').click( =>
      setTimeout( =>
        @initialize_tagits()
      , 1)
    )

  register_click_event_to_remove_variant_button: ->
    $(document).on('click', '.js-remove-variant', ->
      $(this).closest('.js-new-variants').remove()
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
    option_values_for_variants = _product(option_types)
    console.log(option_values_for_variants)
    option_values_for_variants.forEach((option_values_for_variant) ->
      _this.build_variant(option_values_for_variant)
    )

  build_variant: (option_values) ->
    $variant = @new_variant()

    $variant.find('[data-name="names"] > input').val(option_values)
    option_values.forEach((option_value) ->
      $variant.find('[data-name="names"]').append('<span class="comable-variant-name">' + option_value + '</span> ')
    )

    $table = $variant.siblings('table')
    $table.find('tbody').append($variant)

  remove_variants: ->
    $('.js-new-variants:not(.hidden)').remove()

  new_variant: ->
    new_id = new Date().getTime()
    $('.js-add-variant2').click()
    $variant = $('.js-new-variants').last()
    $variant.removeClass('hidden')
    $variant.html($variant.html().replace(/new_variant/g, new_id))
    $variant

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
