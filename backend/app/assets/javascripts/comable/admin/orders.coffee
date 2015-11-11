class @OrderItemBuilder
  NEW_ORDER_ITEM_SELECTOR = '.js-new-order-item'
  LINK_TO_REMOVE_ORDER_ITEM_SELECTOR = '.js-remove-order-item'

  constructor: ->
    @setSelectors()
    @$variantSelector.on('select2:select', (event) => @buildOrderItem(event.params.data))
    $(document).on('click', LINK_TO_REMOVE_ORDER_ITEM_SELECTOR, (event) => @removeOrderItem(event.target))

  setSelectors: ->
    @$variantSelector = $('#js-variant-selector')
    @$linkToAddOrderItem = $('#js-add-order-item')
    @$orderItemsTable = $('#js-order-items-table').find('tbody')

  buildOrderItem: (variant) ->
    $orderItem = @newOrderItem()
    @fillOrderItem($orderItem, variant)
    @$orderItemsTable.append($orderItem)
    @refreshPricesFor($orderItem)

  # TODO: Commonize this method
  newOrderItem: ->
    newId = new Date().getTime()
    @$linkToAddOrderItem.click()
    $orderItem = $(NEW_ORDER_ITEM_SELECTOR).filter('.hidden').last()
    $orderItem.removeClass('hidden')
    $orderItem.html($orderItem.html().replace(/new_order_item/g, newId))
    $orderItem

  fillOrderItem: ($orderItem, variant) ->
    $orderItem.find('[data-name="variant_id"]').val(variant.id)
    $orderItem.find('[data-name="name"]').val(variant.text)
    $orderItem.find('[data-name="sku"]').val(variant.sku)
    $orderItem.find('[data-name="price"]').val(variant.price)
    $orderItem.find('[data-name="subtotal_price"]').val(variant.price)
    $orderItem.find('[data-name="image_url"]').attr('src', variant.image_url)

  removeOrderItem: (element) ->
    $(element).closest(NEW_ORDER_ITEM_SELECTOR).remove()

  refreshPricesFor: ($orderItem) ->
    $orderItem.find('[data-name="price"]').trigger('change')

class @UserSelector
  constructor: ->
    @setSelectors()
    @$userSelector.on('select2:select', (event) => @fillUser(event.params.data))

  setSelectors: ->
    @$userSelector = $('#js-user-selector')
    @$user = $('#js-user-fields')

  fillUser: (user) ->
    @$user.find('[data-name="email"]').val(user.email)
    @$user.find('[data-name="bill-family-name"]').val(user.bill_address.family_name)
    @$user.find('[data-name="bill-first-name"]').val(user.bill_address.first_name)
    @$user.find('[data-name="bill-zip-code"]').val(user.bill_address.zip_code)
    @$user.find('[data-name="bill-state-name"]').val(user.bill_address.state_name)

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
    $subtotal_price = $group.find('[data-name="subtotal_price"]')

    price = Number($price.val())
    quantity = Number($quantity.val())
    $subtotal_price.val(price * quantity)

    @refresh_order_prices()

  refresh_order_prices: ->
    item_total_price = 0
    $('[data-name="subtotal_price"]').each( ->
      item_total_price += Number($(this).val())
    )

    $item_total_price = $('[data-name="item_total_price"]')
    $payment_fee = $('[data-name="payment_fee"]')
    $shipment_fee = $('[data-name="shipment_fee"]')
    $total_price = $('[data-name="total_price"]')

    payment_fee = Number($payment_fee.val())
    shipment_fee = Number($shipment_fee.val())

    $item_total_price.val(item_total_price)
    $total_price.val(item_total_price + payment_fee + shipment_fee)
