require 'spec_helper'

describe Customer do
  it { expect { described_class.new }.to_not raise_error }

  context 'カート処理' do
    let(:stocks) { FactoryGirl.create_list(:stock, 5, :many, :unsold, :with_product) }
    let(:stock) { stocks.first }

    subject { FactoryGirl.build_stubbed(described_class.name.underscore) }

    it '商品を投入できること' do
      subject.add_cart_item(stock)
    end

    it '商品の個数を増やした際の合計金額が正しいこと' do
      subject.add_cart_item(stock)
      subject.add_cart_item(stock)
      expect(subject.cart_items.first.price).to eq(stock.price * 2)
    end

    it '商品を複数投入した際の合計金額が正しいこと' do
      subject.add_cart_item(stocks)
      expect(subject.cart.price).to eq(stocks.sum(&:price))
    end

    it '商品を削除できること' do
      subject.add_cart_item(stock)
      subject.remove_cart_item(stock)
    end

    it '商品の個数を減らした際の合計金額が正しいこと' do
      subject.add_cart_item(stock)
      subject.add_cart_item(stock)
      subject.remove_cart_item(stock)
      expect(subject.cart_items.first.price).to eq(stock.price)
    end

    it '商品を削除した際の合計金額が正しいこと' do
      subject.add_cart_item(stocks)
      subject.remove_cart_item(stock)
      expect(subject.cart.price).to eq(stocks.sum(&:price) - stock.price)
    end

    context '在庫がない場合' do
      let(:stocks) { FactoryGirl.create_list(:stock, 5, :many, :soldout, :with_product) }

      it '商品を投入できないこと' do
        expect { subject.add_cart_item(stock) }.to raise_error
      end
    end
  end

  context '注文処理' do
    let(:stock) { FactoryGirl.create(:stock, :unsold, :with_product) }

    subject { FactoryGirl.create(described_class.name.underscore) }
    before { subject.add_cart_item(stock) }

    it '商品を購入できること' do
      subject.order
    end

    it '商品を購入後はカートが空になること' do
      subject.order
      expect(subject.cart_items).to be_empty
    end

    it '受注レコードが正しく存在すること' do
      subject.order
      expect(subject.orders.last).to be
    end

    it '受注配送レコードが１つ存在すること' do
      subject.order
      expect(subject.orders.last.order_deliveries.count).to eq(1)
    end

    it '受注配送レコードが正しく存在すること' do
      subject.order
      expect(subject.orders.last.order_deliveries.last.family_name).to eq(subject.family_name)
    end

    it '受注詳細レコードが１つ存在すること' do
      subject.order
      expect(subject.orders.last.order_deliveries.last.order_details.last.stock).to eq(stock)
    end

    it '在庫が減っていること' do
      expect { subject.order }.to change { stock.reload.quantity }.by(-1)
    end

    context '在庫がない場合' do
      before { stock.update_attributes(quantity: 0) }

      it '商品を購入できないこと' do
        expect { subject.order }.to raise_error(Comable::InvalidOrder)
      end
    end

    context '複数配送' do
      let(:params) do
        {
          order: {
            family_name: 'comable',
            first_name: 'orderer',
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
                    stock_id: stock.id,
                    quantity: 1,
                    price: stock.price
                  }
                }
              }
            }
          }
        }
      end

      let(:invalid_params) do
        params[:order][:comable_order_deliveries_attributes][1].update(
          comable_order_details_attributes: {
            0 => {
              stock_id: stock.id,
              quantity: 1,
              price: stock.price
            }
          }
        )
        params
      end

      it '受注配送レコードが複数個存在すること' do
        subject.order(params[:order])
        expect(subject.orders.last.order_deliveries.count).to eq(3)
      end

      it '１つの受注レコードに受注詳細レコードが１つだけ紐づくこと' do
        subject.order(params[:order])
        expect(subject.orders.last.order_deliveries.map(&:order_details).flatten.count).to eq(1)
      end

      it '不正なパラメータが渡された場合にエラーが発生すること' do
        expect { subject.order(invalid_params[:order]) }.to raise_error(Comable::InvalidOrder)
      end
    end
  end
end
