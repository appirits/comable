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
