#= require jquery
#= require comable/frontend/module

describe 'Comable.helpers', ->
  described_class = null

  beforeEach ->
    described_class = Comable.helpers

  describe '#numberWithDelimiter', ->
    it 'returns the number with default delimiter', ->
      expect(described_class.numberWithDelimiter(100)).toBe('100')
      expect(described_class.numberWithDelimiter(100000)).toBe('100,000')
      expect(described_class.numberWithDelimiter(100000.000001)).toBe('100,000.000001')
