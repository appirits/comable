require 'spec_helper'

describe Customer do
  it { expect { described_class.new }.to_not raise_error }

  context "カート処理" do
    let (:products) { FactoryGirl.create_list(:product, 5, :many) }
    let (:product) { products.first }

    subject { FactoryGirl.build_stubbed(described_class.name.underscore) }

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

    subject { FactoryGirl.create(described_class.name.underscore) }

    it "商品を購入できること" do
      subject.add_cart_item(product)
      subject.order
    end

    it "商品を購入後はカートが空になること" do
      subject.add_cart_item(product)
      subject.order
      expect(subject.cart_items).to be_empty
    end

    it "受注レコードが正しく存在すること" do
      subject.add_cart_item(product)
      subject.order
      expect(subject.orders.last).to be
    end

    it "受注配送レコードが１つ存在すること" do
      subject.add_cart_item(product)
      subject.order
      expect(subject.orders.last.order_deliveries.count).to eq(1)
    end

    it "受注配送レコードが正しく存在すること" do
      subject.add_cart_item(product)
      subject.order
      expect(subject.orders.last.order_deliveries.last.family_name).to eq(subject.family_name)
    end

    it "受注詳細レコードが１つ存在すること" do
      subject.add_cart_item(product)
      subject.order
      expect(subject.orders.last.order_deliveries.last.order_details.count).to eq(1)
    end

    it "受注詳細レコードが正しく存在すること" do
      subject.add_cart_item(product)
      subject.order
      expect(subject.orders.last.order_deliveries.last.order_details.last.product).to eq(product)
    end

    context "複数配送" do
      let (:params) {
        {
          order: {
            comable_order_deliveries_attributes: {
              0 => {
                family_name: 'comable',
                first_name: 'one'
              },
              1 => {
                family_name: 'comable',
                first_name: 'two'
              },
              2 => {
                family_name: 'comable',
                first_name: 'three',
                comable_order_details_attributes: {
                  0 => {
                    product_id: product.id,
                    quantity: 1,
                    price: product.price
                  }
                }
              }
            }
          }
        }
      }
      let (:invalid_params) {
        params[:order][:comable_order_deliveries_attributes][1].update(
          comable_order_details_attributes: {
            0 => {
              product_id: product.id,
              quantity: 1,
              price: product.price
            }
          }
        )
        params
      }

      it "受注配送レコードが複数個存在すること" do
        subject.add_cart_item(product)
        subject.order(params[:order])
        expect(subject.orders.last.order_deliveries.count).to eq(3)
      end

      it "１つの受注レコードに受注詳細レコードが１つだけ紐づくこと" do
        subject.add_cart_item(product)
        subject.order(params[:order])
        expect(subject.orders.last.order_deliveries.map(&:order_details).flatten.count).to eq(1)
      end

      it "不正なパラメータが渡された場合にエラーが発生すること" do
        subject.add_cart_item(product)
        expect { subject.order(invalid_params[:order]) }.to raise_error(Comable::InvalidOrder)
      end
    end
  end
end
