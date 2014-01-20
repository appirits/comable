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

    it "商品の個数を増やした際の合計金額が正しいこと" do
      subject.add_cart(product)
      subject.add_cart(product)
      expect(subject.cart_items.first.price).to eq(product.price * 2)
    end

    it "商品を複数投入した際の合計金額が正しいこと" do
      subject.add_cart(products)
      expect(subject.cart.price).to eq(products.sum(&:price))
    end

    it "商品を削除できること" do
      subject.add_cart(product)
      subject.remove_cart(product)
    end

    it "商品の個数を減らした際の合計金額が正しいこと" do
      subject.add_cart(product)
      subject.add_cart(product)
      subject.remove_cart(product)
      expect(subject.cart_items.first.price).to eq(product.price)
    end

    it "商品を削除した際の合計金額が正しいこと" do
      subject.add_cart(products)
      subject.remove_cart(product)
      expect(subject.cart.price).to eq(products.sum(&:price) - product.price)
    end
  end
end
