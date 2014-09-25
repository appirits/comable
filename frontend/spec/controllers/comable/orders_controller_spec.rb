describe Comable::OrdersController do
  render_views

  let(:payment) { FactoryGirl.create(:payment) }
  let(:shipment_method) { FactoryGirl.create(:shipment_method) }
  let(:product) { FactoryGirl.create(:product, stocks: [stock]) }
  let(:stock) { FactoryGirl.create(:stock, :unsold) }
  let(:add_to_cart) { customer.add_cart_item(product) }
  let(:order_params) { { order: { family_name: 'foo', first_name: 'bar', comable_payment_id: payment.id, shipment_method_id: shipment_method.id } } }

  context 'カートが空の場合' do
    before { request }

    describe "GET 'new'" do
      let(:request) { get :new }
      its(:response) { should redirect_to(:cart) }

      it 'flashにメッセージが格納されていること' do
        expect(flash[:alert]).to eq I18n.t('comable.carts.empty')
      end
    end
  end

  # TODO: ゲストの場合と会員の場合を共通化
  context 'ゲストの場合' do
    before { add_to_cart }
    before { request }

    let(:customer) { Comable::Customer.new(cookies) }

    describe "GET 'new'" do
      let(:request) { get :new }
      its(:response) { should be_success }

      it 'カートが空でないこと' do
        expect(customer.cart.count).to be_nonzero
      end
    end

    describe "GET 'orderer'" do
      let(:request) { get :orderer }
      its(:response) { should be_success }
    end

    # TODO: post => put
    describe "POST 'orderer'" do
      let(:request) { post :orderer, order_params }
      its(:response) { should redirect_to(:delivery_order) }
    end

    describe "GET 'delivery'" do
      let(:request) { get :delivery }
      its(:response) { should be_success }
    end

    describe "POST 'delivery'" do
      let(:request) { post :delivery, order_params }
      its(:response) { should redirect_to(:shipment_order) }
    end

    describe "GET 'shipment'" do
      let(:request) { get :shipment }
      its(:response) { should be_success }
    end

    describe "POST 'shipment'" do
      let(:request) { post :shipment, order_params }
      its(:response) { should redirect_to(:payment_order) }
    end

    describe "GET 'payment'" do
      let(:request) { get :payment }
      its(:response) { should be_success }
    end

    describe "POST 'payment'" do
      let(:request) { post :payment, order_params }
      its(:response) { should redirect_to(:confirm_order) }
    end

    describe "GET 'confirm'" do
      let(:request) { get :confirm }
      its(:response) { should be_success }
    end

    describe "POST 'create'" do
      context '正常な手順のリクエストの場合' do
        let(:request) { request_orderer && request_delivery && request_payment && request_create }
        let(:request_orderer) { post :orderer, order_params }
        let(:request_delivery) { post :delivery, order_params }
        let(:request_payment) { post :payment, order_params }
        let(:request_create) { post :create, order_params }
        let(:complete_orders) { Comable::Order.complete.where(guest_token: cookies.signed[:guest_token]) }

        its(:response) { should be_success }

        it 'flashにメッセージが格納されていること' do
          expect(flash[:notice]).to eq I18n.t('comable.orders.success')
        end

        it '注文が１つ存在すること' do
          expect(complete_orders.count).to eq(1)
        end

        it '注文に紐づく配送情報が１つ存在すること' do
          expect(complete_orders.first.order_deliveries.count).to eq(1)
        end

        it '注文に紐づく明細情報が１つ存在すること' do
          expect(complete_orders.first.order_deliveries.first.order_details.count).to eq(1)
        end
      end

      context '不正な手順のリクエストの場合' do
        let(:request) { post :create, order_params }

        its(:response) { should redirect_to(controller.comable.cart_path) }

        it 'flashにメッセージが格納されていること' do
          expect(flash[:alert]).to eq I18n.t('comable.orders.failure')
        end
      end

      context '在庫が不足している場合' do
        let(:add_to_cart) { customer.add_cart_item(product, quantity: stock.quantity + 1) }
        let(:request) { post :create, order_params }

        its(:response) { should redirect_to(controller.comable.cart_path) }
      end
    end
  end

  context '会員の場合' do
    before { login }
    before { add_to_cart }
    before { request }

    let(:customer) { FactoryGirl.create(:customer) }
    let(:login) { allow(controller).to receive(:logged_in_customer).and_return(customer) }

    describe "GET 'new'" do
      let(:request) { get :new }
      its(:response) { should redirect_to(:delivery_order) }
    end

    describe "GET 'orderer'" do
      let(:request) { get :orderer }
      its(:response) { should redirect_to(:delivery_order) }
    end

    describe "POST 'orderer'" do
      let(:request) { post :orderer, order_params }
      its(:response) { should redirect_to(:delivery_order) }
    end

    describe "GET 'delivery'" do
      let(:request) { get :delivery }
      its(:response) { should be_success }
    end

    describe "POST 'delivery'" do
      let(:request) { post :delivery, order_params }
      its(:response) { should redirect_to(:shipment_order) }
    end

    describe "GET 'shipment'" do
      let(:request) { get :shipment }
      its(:response) { should be_success }
    end

    describe "POST 'shipment'" do
      let(:request) { post :shipment, order_params }
      its(:response) { should redirect_to(:payment_order) }
    end

    describe "GET 'payment'" do
      let(:request) { get :payment }
      its(:response) { should be_success }
    end

    describe "POST 'payment'" do
      let(:request) { post :payment, order_params }
      its(:response) { should redirect_to(:confirm_order) }
    end

    describe "GET 'confirm'" do
      let(:request) { get :confirm }
      its(:response) { should be_success }
    end

    describe "POST 'create'" do
      let(:request) { payment_request && create_request }
      let(:payment_request) { post :payment, order_params }
      let(:create_request) { post :create, order_params }
      its(:response) { should be_success }

      it 'flashにメッセージが格納されていること' do
        expect(flash[:notice]).to eq I18n.t('comable.orders.success')
      end
    end
  end
end
