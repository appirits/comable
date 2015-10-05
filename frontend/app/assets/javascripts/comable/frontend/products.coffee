class @VariantSelector
  class: VariantSelector

  @setProduct: (productJson) ->
    @variants = productJson.variants

  constructor: ->
    @setSelectors()
    @$optionSelector.on('change', => @selectVariant())

  setSelectors: ->
    @$optionSelector = $('[name="option_values[]"]')
    @$variantSelector = $('[name="variant_id"]')

  selectVariant: ->
    options = @getSelectedOptions()
    variant = @getVariant(options)
    @resetVariantSelector(variant && variant.id)
    new ProductPage(variant)

  getVariant: (optionValues) ->
    matchedVariant = null
    $.each(@class.variants, (_, variant) =>
      matched = true
      $.each(variant.options, (index, option) =>
        return matched = false if option != optionValues[index]
      )
      matchedVariant = variant if matched
      return !matched
    )
    matchedVariant

  getSelectedOptions: ->
    @$optionSelector.find(':selected').map( ->
      $(this).text()
    )

  resetVariantSelector: (id = null) ->
    @$variantSelector.find(':selected').each(
      -> $(this).prop('selected', false)
    )
    @$variantSelector.find('[value="' + id + '"]').prop('selected', true) if id

class @ProductPage extends Comable.Module
  @include Comable.helpers

  # TODO: Get translations from Rails
  translations: {
    add_to_cart: 'カートに入れる'
    sold_out: '品切れ'
    currency_format: '%{number}円'
  }

  constructor: (variant) ->
    @variant = variant
    @setSelectors()
    @changeProductInfomations()

  setSelectors: ->
    @$productPrice = $('#comable-product .price')
    @$cartForm = $('#comable-product form')
    @$cartFormSubmit = @$cartForm.find('input[type="submit"]')

  changeProductInfomations: ->
    @changeProductPrice()
    @changeCartForm()

  changeProductPrice: ->
    return unless @variant
    currency = @numberToCurrency(@variant.price)
    @$productPrice.text(currency)

  changeCartForm: ->
    if @variant
      @enableCartFormSubmit()
    else
      @disableCartFormSubmit()

  enableCartFormSubmit: ->
    @$cartFormSubmit.prop('disabled', false)
    @$cartFormSubmit.val(@translations.add_to_cart)

  disableCartFormSubmit: ->
    @$cartFormSubmit.prop('disabled', true)
    @$cartFormSubmit.val(@translations.sold_out)

  numberToCurrency: (number) ->
    numberLabel = @numberWithDelimiter(number)
    @translations.currency_format.replace(/%{number}/, numberLabel)
