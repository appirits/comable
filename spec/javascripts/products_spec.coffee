#= require jquery
#= require comable/frontend/products

describe 'VariantSelector', ->
  described_class = null
  subject = null

  beforeEach ->
    described_class = VariantSelector
    subject = new described_class

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

describe 'ProductPage', ->
  described_class = null
  subject = null

  beforeEach ->
    described_class = ProductPage
    spyOn(described_class, 'constructor')
    subject = new described_class

  describe '#numberWithDelimiter', ->
    it 'returns the number with default delimiter', ->
      expect(subject.numberWithDelimiter(100)).toBe('100')
      expect(subject.numberWithDelimiter(100000)).toBe('100,000')
      expect(subject.numberWithDelimiter(100000.000001)).toBe('100,000.000001')

  describe '#numberToCurrency', ->
    it 'returns the currency', ->
      expect(subject.numberToCurrency(1000)).toBe('1,000円')
