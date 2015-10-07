#= require jquery
#= require jasmine-jquery
#= require comable/frontend/module
#= require comable/frontend/products

describe 'VariantSelector', ->
  described_class = null
  subject = null
  optionsHtml = '<select name="option_values[]" />'
  variantHtml = '<select name="variant_id" />'

  beforeEach ->
    described_class = VariantSelector
    subject = described_class.prototype

  afterEach ->
    # Reset @variants
    described_class.variants = undefined

  describe '#getVariant', ->
    it 'returns a variant when options are matched', ->
      variantRed = { options: ['M', 'Red'] }
      variantBlue = { options: ['M', 'Blue'] }
      described_class.variants = [variantRed, variantBlue]
      expect(subject.getVariant(variantRed.options)).toBe(variantRed)

    it 'returns null when options are not matched', ->
      variantRed = { options: ['M', 'Red'] }
      variantBlue = { options: ['M', 'Blue'] }
      described_class.variants = [variantRed]
      expect(subject.getVariant(variantBlue.options)).toBe(null)

  describe '.setProduct', ->
    it 'sets @variants', ->
      variant = { options: ['M', 'Red'] }
      product = { variants: [variant] }
      described_class.setProduct(product)
      expect(described_class.variants[0]).toBe(variant)

  describe '#constructor', ->
    beforeEach ->
      spyOn(subject, 'setSelectors')
      spyOn(subject, 'selectVariant')
      subject.$optionSelector = $('<select />')

    it 'calls #setSelectors', ->
      subject.constructor()
      expect(subject.setSelectors).toHaveBeenCalled()
      expect(subject.setSelectors.calls.count()).toEqual(1)

    it 'calls #selectVariant', ->
      subject.constructor()
      expect(subject.selectVariant).toHaveBeenCalled()
      expect(subject.setSelectors.calls.count()).toEqual(1)

    it 'handles "change" of @$optionSelector with #selectVariant', ->
      # Set @$optionSelector
      setFixtures(optionsHtml)
      subject.setSelectors.and.callThrough()
      subject.setSelectors()

      # Trigger "change" of @$optionSelector after spy on #selectVariant
      subject.constructor()
      subject.selectVariant.calls.reset()
      subject.$optionSelector.trigger('change')
      expect(subject.selectVariant).toHaveBeenCalled()
      expect(subject.selectVariant.calls.count()).toEqual(1)

  describe '#setSelectors', ->
    it 'sets @$optionSelector', ->
      setFixtures(optionsHtml)
      subject.setSelectors()
      expect(subject.$optionSelector).toEqual('[name="option_values[]"]')

    it 'sets @$variantSelector', ->
      setFixtures(variantHtml)
      subject.setSelectors()
      expect(subject.$variantSelector).toEqual('[name="variant_id"]')

  describe '#selectVariant', ->
    beforeEach ->
      spyOn(subject, 'getSelectedOptions')
      spyOn(subject, 'getVariant')
      spyOn(subject, 'resetVariantSelector')
      spyOn(window, 'ProductPage')

      # Set @variants
      variant = {}
      described_class.variants = [variant]

    it 'calls #getSelectedOptions', ->
      subject.selectVariant()
      expect(subject.getSelectedOptions).toHaveBeenCalled()
      expect(subject.getSelectedOptions.calls.count()).toEqual(1)

    it 'calls #getVariant with options', ->
      options = {}
      subject.getSelectedOptions.and.returnValue(options)
      subject.selectVariant()
      expect(subject.getVariant).toHaveBeenCalledWith(options)
      expect(subject.getVariant.calls.count()).toEqual(1)

    it 'calls #resetVariantSelector with null when variant is null', ->
      variant = null
      subject.getVariant.and.returnValue(variant)
      subject.selectVariant()
      expect(subject.resetVariantSelector).toHaveBeenCalledWith(variant)
      expect(subject.resetVariantSelector.calls.count()).toEqual(1)

    it 'calls #resetVariantSelector with variant#id when variant is exist', ->
      variant = { id: 100 }
      subject.getVariant.and.returnValue(variant)
      subject.selectVariant()
      expect(subject.resetVariantSelector).toHaveBeenCalledWith(variant.id)
      expect(subject.resetVariantSelector.calls.count()).toEqual(1)

    it 'initializes ProductPage with variant', ->
      variant = {}
      subject.getVariant.and.returnValue(variant)
      subject.selectVariant()
      expect(ProductPage).toHaveBeenCalledWith(variant)
      expect(ProductPage.calls.count()).toEqual(1)

    it 'does not call any methods when variants is undefined', ->
      described_class.variants = undefined
      subject.selectVariant()
      expect(subject.getSelectedOptions).not.toHaveBeenCalled()
      expect(subject.getVariant).not.toHaveBeenCalled()
      expect(subject.resetVariantSelector).not.toHaveBeenCalled()
      expect(ProductPage).not.toHaveBeenCalled()

  describe '#getSelectedOptions', ->
    it 'gets selected options', ->
      $options = $('<div />')

      $colorOptions = $(optionsHtml)
      $colorOptions.append('<option value="Red" selected>Red</option>')
      $colorOptions.append('<option value="Blue">Blue</option>')
      $colorOptions.appendTo($options)

      $sizeOptions = $(optionsHtml)
      $sizeOptions.append('<option value="S">S</option>')
      $sizeOptions.append('<option value="M" selected>M</option>')
      $sizeOptions.appendTo($options)

      setFixtures($options)
      subject.setSelectors()

      expect(subject.getSelectedOptions()).toEqual(['Red', 'M'])

  describe '#resetVariantSelector', ->
    beforeEach ->
      setFixtures(variantHtml)
      subject.setSelectors()

    it 'selects the blank option', ->
      subject.$variantSelector.append('<option>Blank</option>')
      subject.$variantSelector.append('<option value="1" selected>Product (Red)</option>')
      subject.resetVariantSelector()
      expect(subject.$variantSelector.find(':selected')).not.toHaveValue()

    it 'selects the requested variant', ->
      variantId = 1
      subject.$variantSelector.append('<option selected>Blank</option>')
      subject.$variantSelector.append('<option value="' + variantId + '">Product (Red)</option>')
      subject.resetVariantSelector(variantId)
      expect(subject.$variantSelector.find(':selected')).toHaveValue(variantId.toString())


describe 'ProductPage', ->
  described_class = null
  subject = null
  priceHtml = '<div id="comable-product"><p class="price">100</p></div>'
  cartFormHtml = '<div id="comable-product"><form><input type="submit" value="Add to cart" /></form></div>'

  beforeEach ->
    described_class = ProductPage
    subject = described_class.prototype

  describe '#numberToCurrency', ->
    it 'returns the currency', ->
      expect(subject.numberToCurrency(1000)).toBe('1,000円')

  describe '#constructor', ->
    beforeEach ->
      spyOn(subject, 'setSelectors')
      spyOn(subject, 'changeProductInfomations')

    it 'sets @variants', ->
      variant = {}
      subject.constructor(variant)
      expect(subject.variant).toEqual(variant)

    it 'calls #setSelectors', ->
      subject.constructor(null)
      expect(subject.setSelectors.calls.count()).toEqual(1)

    it 'calls #changeProductInfomations', ->
      subject.constructor(null)
      expect(subject.changeProductInfomations.calls.count()).toEqual(1)

  describe '#setSelectors', ->
    it 'sets @$productPrice', ->
      setFixtures(priceHtml)
      subject.setSelectors()
      expect(subject.$productPrice).toEqual('#comable-product .price')

    it 'sets @$cartForm', ->
      setFixtures(cartFormHtml)
      subject.setSelectors()
      expect(subject.$cartForm).toEqual('#comable-product form')

    it 'sets @$cartFormSubmit', ->
      setFixtures(cartFormHtml)
      subject.setSelectors()
      expect(subject.$cartFormSubmit).toEqual('#comable-product form input[type="submit"]')

  describe '#changeProductPrice', ->
    beforeEach ->
      setFixtures(priceHtml)
      subject.setSelectors()
      subject.variant = { price: parseInt(subject.$productPrice.text()) + 100 }

    it 'changes the text of @$productPrice', ->
      subject.changeProductPrice()
      currency = subject.numberToCurrency(subject.variant.price)
      expect(subject.$productPrice).toHaveText(currency)

    it 'does not change text of @$productPrice when @variant is null', ->
      currency = subject.$productPrice.text()
      subject.variant = null
      subject.changeProductPrice()
      expect(subject.$productPrice).toHaveText(currency)

  describe '#changeProductInfomations', ->
    it 'calls #changeProductPrice', ->
      spyOn(subject, 'changeProductPrice')
      subject.changeProductInfomations()
      expect(subject.changeProductPrice).toHaveBeenCalled()
      expect(subject.changeProductPrice.calls.count()).toEqual(1)

    it 'calls #changeProductPrice', ->
      spyOn(subject, 'changeCartForm')
      subject.changeProductInfomations()
      expect(subject.changeCartForm).toHaveBeenCalled()
      expect(subject.changeCartForm.calls.count()).toEqual(1)

  describe '#changeCartForm', ->
    it 'calls #enableCartFormSubmit when @variant is available', ->
      subject.variant = { quantity: 100 }
      spyOn(subject, 'enableCartFormSubmit')
      subject.changeCartForm()
      expect(subject.enableCartFormSubmit).toHaveBeenCalled()
      expect(subject.enableCartFormSubmit.calls.count()).toEqual(1)

    it 'calls #disableCartFormSubmit when @variant is sold out', ->
      subject.variant = { quantity: 0 }
      spyOn(subject, 'disableCartFormSubmit')
      subject.changeCartForm()
      expect(subject.disableCartFormSubmit).toHaveBeenCalled()
      expect(subject.disableCartFormSubmit.calls.count()).toEqual(1)

    it 'calls #disableCartFormSubmit when @variant is not exist', ->
      spyOn(subject, 'disableCartFormSubmit')
      subject.changeCartForm()
      expect(subject.disableCartFormSubmit).toHaveBeenCalled()
      expect(subject.disableCartFormSubmit.calls.count()).toEqual(1)

  describe '#enableCartFormSubmit', ->
    beforeEach ->
      setFixtures(cartFormHtml)
      subject.setSelectors()

    it 'enables @$cartFormSubmit', ->
      subject.enableCartFormSubmit()
      expect(subject.$cartFormSubmit).not.toBeDisabled()

    it 'changes the value of @$cartFormSubmit', ->
      subject.enableCartFormSubmit()
      expect(subject.$cartFormSubmit).toHaveValue('カートに入れる')

  describe '#disableCartFormSubmit', ->
    beforeEach ->
      setFixtures(cartFormHtml)
      subject.setSelectors()

    it 'disables @$cartFormSubmit', ->
      subject.disableCartFormSubmit()
      expect(subject.$cartFormSubmit).toBeDisabled()

    it 'changes the value of @$cartFormSubmit', ->
      subject.disableCartFormSubmit()
      expect(subject.$cartFormSubmit).toHaveValue('品切れ')
