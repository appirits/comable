require 'spec_helper'

describe Customer do
  it { expect { described_class.new }.to_not raise_error }

  context "カート処理" do
    let (:product) { FactoryGirl.create(:product) }

    subject { FactoryGirl.build_stubbed(described_class.name.underscore) }

    it "商品を投入できること" do
      subject.add_cart(product)
    end

    it "投入した商品の合計金額が正しいこと" do
      subject.add_cart(product)
      subject.add_cart(product)
      expect(subject.cart_items.first.price).to eq(product.price * 2)
    end
  end
end
