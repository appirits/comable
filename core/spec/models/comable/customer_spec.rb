describe Comable::Customer do
  it { is_expected.to have_many(:addresses).class_name(Comable::Address.name).with_foreign_key(described_class.table_name.singularize.foreign_key).dependent(:destroy) }
  it { is_expected.to belong_to(:bill_address).class_name(Comable::Address.name).dependent(:destroy) }
  it { is_expected.to belong_to(:ship_address).class_name(Comable::Address.name).dependent(:destroy) }

  context 'カート処理' do
    let(:stocks) { FactoryGirl.create_list(:stock, 5, :unsold, :with_product) }
    let(:stock) { stocks.first }

    subject { FactoryGirl.build_stubbed(:customer) }

    it '商品を投入できること' do
      subject.add_cart_item(stock)
    end

    it '商品の個数を増やした際の合計金額が正しいこと' do
      subject.add_cart_item(stock)
      subject.add_cart_item(stock)
      expect(subject.cart.price).to eq(stock.price * 2)
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
      expect(subject.cart_items.first.current_subtotal_price).to eq(stock.price)
    end

    it '商品を削除した際の合計金額が正しいこと' do
      subject.add_cart_item(stocks)
      subject.remove_cart_item(stock)
      expect(subject.cart.price).to eq(stocks.sum(&:price) - stock.price)
    end

    it '商品を初期化できること' do
      subject.add_cart_item(stock)
      subject.reset_cart_item(stock)
      expect(subject.cart.count).to eq(0)
    end

    context '在庫がない場合' do
      let(:stocks) { FactoryGirl.create_list(:stock, 5, :soldout, :with_product) }

      it '商品を投入できないこと' do
        expect { subject.add_cart_item(stock) }.to raise_error(Comable::NoStock)
      end
    end
  end

  context '注文処理' do
    let(:payment) { FactoryGirl.create(:payment) }
    let(:stock) { FactoryGirl.create(:stock, :unsold, :with_product) }
    let(:order_quantity) { 10 }

    subject { FactoryGirl.create(:customer) }

    before { subject.incomplete_order.update_attributes(payment: payment) }
    before { subject.add_cart_item(stock, quantity: order_quantity) }

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
      expect(subject.orders.last.family_name).to eq(subject.family_name)
    end

    it '受注配送レコードが正しく存在すること' do
      subject.order
      expect(subject.orders.last.order_deliveries.last.family_name).to eq(subject.family_name)
    end

    it '受注詳細レコードが１つ存在すること' do
      subject.order
      expect(subject.orders.last.order_deliveries.last.order_details.count).to eq(1)
    end

    it '受注詳細レコードが１つ存在すること' do
      subject.order
      expect(subject.orders.last.order_deliveries.last.order_details.last.stock).to eq(stock)
    end

    it '在庫が減っていること' do
      expect { subject.order }.to change { stock.reload.quantity }.by(-order_quantity)
    end

    context '在庫がない場合' do
      before { stock.update_attributes(quantity: 0) }

      it '商品を購入できないこと' do
        expect { subject.order }.to raise_error(Comable::InvalidOrder)
      end
    end

    # TODO: 複数配送先の完全な実装 or 機能削除
    pending '複数配送' do
      let(:order) { FactoryGirl.build(:order) }
      let(:order_delivery) { FactoryGirl.build(:order_delivery) }

      pending '複数配送先は削除予定'

      let(:params) do
        {
          order: {
            family_name: order.family_name,
            first_name: order.first_name,
            email: order.email,
            order_deliveries_attributes: {
              0 => {
                family_name: order_delivery.family_name,
                first_name: order_delivery.first_name + '_one'
              },
              1 => {
                family_name: order_delivery.family_name,
                first_name: order_delivery.first_name + '_two'
              },
              2 => {
                family_name: order_delivery.family_name,
                first_name: order_delivery.first_name + '_three'
              }
            }
          }
        }
      end

      let(:invalid_params) do
        params[:order][:order_deliveries_attributes][1].update(
          order_details_attributes: {
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
        expect(subject.orders.last.order_deliveries.map { |order_delivery| order_delivery.order_details.count }.sum).to eq(1)
      end

      it '不正なパラメータが渡された場合にエラーが発生すること' do
        expect { subject.order(invalid_params[:order]) }.to raise_error(ActiveRecord::UnknownAttributeError)
      end
    end
  end

  describe 'Associations' do
    subject { FactoryGirl.build_stubbed(:customer) }

    it 'has one bill_address' do
      subject.build_bill_address
      expect(subject.bill_address).to be
    end

    it 'has one bill_address' do
      subject.build_ship_address
      expect(subject.ship_address).to be
    end
  end
end
