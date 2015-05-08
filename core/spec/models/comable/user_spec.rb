describe Comable::User do
  let(:cookies) { OpenStruct.new(signed: signed_cookies, permanent: OpenStruct.new(signed: signed_cookies)) }
  let(:signed_cookies) { Hash.new }

  it { is_expected.to have_many(:addresses).class_name(Comable::Address.name).dependent(:destroy) }
  it { is_expected.to belong_to(:bill_address).class_name(Comable::Address.name).dependent(:destroy) }
  it { is_expected.to belong_to(:ship_address).class_name(Comable::Address.name).dependent(:destroy) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to validate_length_of(:email).is_at_most(255) }
  end

  describe 'incomplete order' do
    context 'when guest' do
      let(:stock) { FactoryGirl.create(:stock, :stocked, :with_product) }

      subject { described_class.new.with_cookies(cookies) }

      # TODO: Refactoring
      it 'has the order item that is same object in different accesses' do
        order = subject.incomplete_order
        order_item = order.order_items.first
        expect(order_item.object_id).to eq(order.order_items.first.object_id)
      end

      it 'has the order item that is same object in different accesses' do
        order = subject.incomplete_order
        expect(order.order_items.size).to eq(0)

        order.order_items.create(stock: stock, quantity: 1)
        expect(order.order_items.size).to eq(1)
        expect(order.reload.order_items.size).to eq(1)
      end

      it 'has the order item that is same object in different accesses' do
        order = subject.incomplete_order
        expect(subject.cart.size).to eq(0)

        subject.add_cart_item(stock)
        expect(order.order_items.size).to eq(1)
        expect(subject.cart.size).to eq(1)
      end
    end
  end

  context 'カート処理' do
    let(:stocks) { FactoryGirl.create_list(:stock, 5, :stocked, :with_product) }
    let(:stock) { stocks.first }

    # when guest
    subject { FactoryGirl.build(:user).with_cookies(cookies) }

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

    context 'when product unstocked' do
      let(:stocks) { FactoryGirl.create_list(:stock, 5, :unstocked, :with_product) }

      it 'has a error in cart' do
        subject.add_cart_item(stock)
        expect(subject.cart.errors.count).to eq(1)
      end

      it 'has a error message in cart' do
        subject.add_cart_item(stock)
        expect(subject.cart.errors.full_messages.join).to include(Comable.t('errors.messages.out_of_stock', name: stock.name_with_sku))
      end
    end
  end

  context '注文処理' do
    let(:stock) { FactoryGirl.create(:stock, :stocked, :with_product, quantity: order_quantity) }
    let(:address) { FactoryGirl.create(:address) }
    let(:order_quantity) { 10 }
    let(:current_order) { subject.incomplete_order }

    subject { FactoryGirl.create(:user) }

    before { subject.incomplete_order.update_attributes(bill_address: address, ship_address: address) }
    before { subject.add_cart_item(stock, quantity: order_quantity) }

    it '商品を購入できること' do
      current_order.complete
    end

    it '商品を購入後はカートが空になること' do
      current_order.state = 'complete'
      current_order.complete
      expect(subject.cart_items).to be_empty
    end

    it '受注レコードが正しく存在すること' do
      current_order.complete
      expect(subject.orders.last).to be
    end

    it '受注詳細レコードが１つ存在すること' do
      current_order.complete
      expect(subject.orders.last.order_items.count).to eq(1)
    end

    it '受注詳細レコードが１つ存在すること' do
      current_order.complete
      expect(subject.orders.last.order_items.last.stock).to eq(stock)
    end

    it '在庫が減っていること' do
      expect { current_order.complete }.to change { stock.reload.quantity }.by(-order_quantity)
    end

    context '在庫がない場合' do
      before { stock.update_attributes(quantity: 0) }

      it '商品を購入できないこと' do
        expect { current_order.complete! }.to raise_error(ActiveRecord::RecordInvalid, /#{stock.name_with_sku}/)
      end
    end
  end

  describe 'Associations' do
    subject { FactoryGirl.build_stubbed(:user) }

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
