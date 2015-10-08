@Comable = {}

# TODO: Move to comable-core
# Based on https://arcturo.github.io/library/coffeescript/03_classes.html
class Comable.Module
  moduleKeywords = ['extended', 'included']

  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value
    obj.extended?.apply(@)
    this

  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value
    obj.included?.apply(@)
    this

Comable.helpers =
  numberWithDelimiter: (number, delimiter = ',') ->
    numbers = number.toString().split('.')
    integers = numbers[0]
    decimals = if numbers.length > 1 then '.' + numbers[1] else ''
    pattern = /(\d+)(\d{3})/
    integers = integers.replace(pattern, '$1' + delimiter + '$2') while pattern.test(integers)
    integers + decimals
