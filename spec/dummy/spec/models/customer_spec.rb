require 'spec_helper'

describe Customer do
  it { expect { described_class.new }.to_not raise_error }

  context "attributes" do
    let (:product) { Product.create(title: 'test product', code: 'test', price: 200) }

    subject { described_class.create(family_name: 'foo', first_name: 'bar') }

    it "カートに商品を投入できること" do
      subject.add_cart(product)
    end

    it "カートに投入した商品の合計金額が正しいこと" do
      subject.add_cart(product)
      subject.add_cart(product)
      expect(subject.cart_items.first.price).to eq(product.price * 2)
    end
  end
end
