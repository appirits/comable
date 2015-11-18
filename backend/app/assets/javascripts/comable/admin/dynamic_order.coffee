class @DynamicOrder
  @refresh_trigger_attributes = ['price', 'quantity', 'payment_fee', 'shipment_fee']

  constructor: (@options = {}) ->
    @options['order_item_selector'] = '.comable-order-items' unless @options['order_item_selector']
    @listen_events()

  listen_events: ->
    self = this
    $(document).on('change', 'input', ->
      attribute_name = $(this).attr('data-name')
      return unless jQuery.inArray(attribute_name, self.refresh_trigger_attributes)
      self.refresh_order_item_prices_for(this)
    )

  refresh_order_item_prices_for: (element) ->
    $group = $(element).closest(@options['order_item_selector'])

    $price = $group.find('[data-name="price"]')
    $quantity = $group.find('[data-name="quantity"]')
    $subtotal_price = $group.find('[data-name="subtotal-price"]')

    price = Number($price.val())
    quantity = Number($quantity.val())
    $subtotal_price.val(price * quantity)

    @refresh_order_prices()

  refresh_order_prices: ->
    item_total_price = 0
    $('[data-name="subtotal-price"]').each( ->
      item_total_price += Number($(this).val())
    )

    $item_total_price = $('[data-name="item-total-price"]')
    $payment_fee = $('[data-name="payment-fee"]')
    $shipment_fee = $('[data-name="shipment-fee"]')
    $total_price = $('[data-name="total-price"]')

    payment_fee = Number($payment_fee.val())
    shipment_fee = Number($shipment_fee.val())

    $item_total_price.val(item_total_price)
    $total_price.val(item_total_price + payment_fee + shipment_fee)
