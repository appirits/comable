require 'spec_helper'

describe Customer do
  it { expect { described_class.new }.to_not raise_error }

  subject { FactoryGirl.build_stubbed(described_class.name.underscore) }

  context "カート処理" do
    let (:products) { FactoryGirl.create_list(:product, 5, :many) }
    let (:product) { products.first }

    it "商品を投入できること" do
      subject.add_cart_item(product)
    end

    it "商品の個数を増やした際の合計金額が正しいこと" do
      subject.add_cart_item(product)
      subject.add_cart_item(product)
      expect(subject.cart_items.first.price).to eq(product.price * 2)
    end

    it "商品を複数投入した際の合計金額が正しいこと" do
      subject.add_cart_item(products)
      expect(subject.cart.price).to eq(products.sum(&:price))
    end

    it "商品を削除できること" do
      subject.add_cart_item(product)
      subject.remove_cart_item(product)
    end

    it "商品の個数を減らした際の合計金額が正しいこと" do
      subject.add_cart_item(product)
      subject.add_cart_item(product)
      subject.remove_cart_item(product)
      expect(subject.cart_items.first.price).to eq(product.price)
    end

    it "商品を削除した際の合計金額が正しいこと" do
      subject.add_cart_item(products)
      subject.remove_cart_item(product)
      expect(subject.cart.price).to eq(products.sum(&:price) - product.price)
    end
  end

  context "注文処理" do
    let (:product) { FactoryGirl.create(:product) }

    it "商品を購入できること" do
      subject.add_cart_item(product)
      subject.order
    end

    it "受注レコードが正しく存在すること" do
      subject.add_cart_item(product)
      subject.order
      expect(subject.orders.last).to be
    end
  end
end
