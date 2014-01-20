require 'spec_helper'

describe Customer do
  it { expect { described_class.new }.to_not raise_error }

  context "カート処理" do
    let (:products) { FactoryGirl.create_list(:product, 5, :many) }
    let (:product) { products.first }

    subject { FactoryGirl.build_stubbed(described_class.name.underscore) }

    it "商品を投入できること" do
      subject.add_cart(product)
    end

    it "投入した１つの商品の合計金額が正しいこと" do
      subject.add_cart(product)
      subject.add_cart(product)
      expect(subject.cart_items.first.price).to eq(product.price * 2)
    end

    it "投入したすべての商品の合計金額が正しいこと" do
      subject.add_cart(products)
      expect(subject.cart.price).to eq(products.sum(&:price))
    end
  end
end
