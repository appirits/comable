#= require jquery
#= require jasmine-jquery
#= require comable/admin/order_item_builder

describe 'OrderItemBuilder', ->
  described_class = null
  subject = null

  beforeEach ->
    described_class = OrderItemBuilder
    subject = described_class.prototype

  describe '#fillOrderItem', ->
    variant = {
      id: 1
      text: 'T-Shirt (Red)'
      sku: 'tshirt-red'
      price: 1000
      image_url: 'image.png'
    }

    it 'fills variant-id filed', ->
      setFixtures('<div class="js-new-order-item"><input type="text" data-name="variant-id" /></div>')
      $orderItem = $('.js-new-order-item').first()
      subject.fillOrderItem($orderItem, variant)
      expect($orderItem.find('input')).toHaveValue(variant.id.toString())

    it 'fills name filed', ->
      setFixtures('<div class="js-new-order-item"><input type="text" data-name="name" /></div>')
      $orderItem = $('.js-new-order-item').first()
      subject.fillOrderItem($orderItem, variant)
      expect($orderItem.find('input')).toHaveValue(variant.text)

    it 'fills sku filed', ->
      setFixtures('<div class="js-new-order-item"><input type="text" data-name="sku" /></div>')
      $orderItem = $('.js-new-order-item').first()
      subject.fillOrderItem($orderItem, variant)
      expect($orderItem.find('input')).toHaveValue(variant.sku)

    it 'fills price filed', ->
      setFixtures('<div class="js-new-order-item"><input type="text" data-name="price" /></div>')
      $orderItem = $('.js-new-order-item').first()
      subject.fillOrderItem($orderItem, variant)
      expect($orderItem.find('input')).toHaveValue(variant.price.toString())

    it 'fills subtotal-price filed', ->
      setFixtures('<div class="js-new-order-item"><input type="text" data-name="subtotal-price" /></div>')
      $orderItem = $('.js-new-order-item').first()
      subject.fillOrderItem($orderItem, variant)
      expect($orderItem.find('input')).toHaveValue(variant.price.toString())

    it 'fills image-url filed', ->
      setFixtures('<div class="js-new-order-item"><img data-name="image-url" /></div>')
      $orderItem = $('.js-new-order-item').first()
      subject.fillOrderItem($orderItem, variant)
      expect($orderItem.find('img')).toHaveAttr('src', variant.image_url)
