class @Stock
  constructor: ->
    @register_click_event_to_remove_comable_stock_button()

  register_click_event_to_remove_comable_stock_button: ->
    $(document).on('click', '.js-remove-comable-stock', ->
      $stock = $(this).closest('.comable-stock')
      $stock.addClass('hidden')
      $stock.find('input[data-name="destroy"]').val(true)
    )
