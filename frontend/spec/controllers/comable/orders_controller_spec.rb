describe Comable::OrdersController do
  render_views

  let(:product) { FactoryGirl.create(:product, stocks: [stock]) }
  let(:stock) { FactoryGirl.create(:stock, :unsold) }
  let(:address_attributes) { FactoryGirl.attributes_for(:address) }
  let(:current_order) { controller.current_order }

  describe "GET 'new'" do
    before { get :new }

    context 'when empty cart' do
      its(:response) { is_expected.to redirect_to(:cart) }

      it 'has flash messages' do
        expect(flash[:alert]).to eq I18n.t('comable.carts.empty')
      end
    end
  end

  shared_examples 'checkout' do
    let!(:payment_method) { FactoryGirl.create(:payment_method) }
    let!(:shipment_method) { FactoryGirl.create(:shipment_method) }

    let(:product) { FactoryGirl.create(:product, stocks: [stock]) }
    let(:stock) { FactoryGirl.create(:stock, :unsold) }
    let(:address_attributes) { FactoryGirl.attributes_for(:address) }
    let(:current_order) { controller.current_order }

    before { allow(controller).to receive(:current_customer).and_return(customer) }
    before { customer.add_cart_item(product) }

    describe "GET 'new'" do
      before { get :new }

      its(:response) { is_expected.to render_template(:new) }
      its(:response) { is_expected.not_to be_redirect }

      it 'cart has any items' do
        expect(customer.cart.count).to be_nonzero
      end
    end

    describe "GET 'edit' with state 'orderer'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_orderer) }

      before { current_order.update_attributes(order_attributes) }
      before { get :edit, state: :orderer }

      its(:response) { is_expected.to render_template(:orderer) }
      its(:response) { is_expected.not_to be_redirect }
    end

    describe "PUT 'update' with state 'orderer'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_orderer) }

      before { current_order.update_attributes(order_attributes) }

      context 'when not exist bill address' do
        before { put :update, order: { state: :orderer } }

        its(:response) { is_expected.to render_template(:orderer) }
        its(:response) { is_expected.not_to be_redirect }

        it 'has assigned @order with errors' do
          expect(assigns(:order).errors.any?).to be true
          expect(assigns(:order).errors[:bill_address]).to be
        end
      end

      context 'when input new bill address' do
        before { put :update, order: { state: :orderer, bill_address_attributes: address_attributes } }

        its(:response) { is_expected.to redirect_to(controller.comable.next_order_path(state: :delivery)) }

        it 'has assigned @order with bill address' do
          expect(assigns(:order).bill_address).to be
          expect(assigns(:order).bill_address.attributes).to include(address_attributes.stringify_keys)
        end
      end
    end

    describe "GET 'edit' with state 'delivery'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_delivery) }

      before { current_order.update_attributes(order_attributes) }
      before { get :edit, state: :delivery }

      its(:response) { is_expected.to render_template(:delivery) }
      its(:response) { is_expected.not_to be_redirect }
    end

    describe "PUT 'update' with state 'delivery'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_delivery) }

      before { current_order.update_attributes(order_attributes) }

      context 'when not exist ship address' do
        before { put :update, order: { state: :delivery } }

        its(:response) { is_expected.to render_template(:delivery) }
        its(:response) { is_expected.not_to be_redirect }

        it 'has assigned @order with errors' do
          expect(assigns(:order).errors.any?).to be true
          expect(assigns(:order).errors[:ship_address]).to be
        end
      end

      context 'when input new shipping address' do
        before { put :update, order: { state: :delivery, ship_address_attributes: address_attributes } }

        its(:response) { is_expected.to redirect_to(controller.comable.next_order_path(state: :shipment)) }

        it 'has assigned @order with ship address' do
          expect(assigns(:order).ship_address).to be
          expect(assigns(:order).ship_address.attributes).to include(address_attributes.stringify_keys)
        end
      end
    end

    describe "GET 'edit' with state 'shipment'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_shipment) }

      before { current_order.update_attributes(order_attributes) }
      before { get :edit, state: :shipment }

      its(:response) { is_expected.to render_template(:shipment) }
      its(:response) { is_expected.not_to be_redirect }
    end

    describe "PUT 'update' with state 'shipment'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_shipment) }

      before { current_order.update_attributes(order_attributes) }
      before { put :update, order: { state: :shipment, shipment_method_id: shipment_method.id } }

      its(:response) { is_expected.to redirect_to(controller.comable.next_order_path(state: :payment)) }
    end

    describe "GET 'edit' with state 'payment'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_payment) }

      before { current_order.update_attributes(order_attributes) }
      before { get :edit, state: :payment }

      its(:response) { is_expected.to render_template(:payment) }
      its(:response) { is_expected.not_to be_redirect }
    end

    describe "PUT 'update' with state 'payment'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_payment) }

      before { current_order.update_attributes(order_attributes) }
      before { put :update, order: { state: :shipment, shipment_method_id: shipment_method.id } }

      its(:response) { is_expected.to redirect_to(controller.comable.next_order_path(state: :confirm)) }
    end

    describe "GET 'edit' with state 'confirm'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_confirm) }

      before { current_order.update_attributes(order_attributes) }
      before { get :edit, state: :confirm }

      its(:response) { is_expected.to render_template(:confirm) }
      its(:response) { is_expected.not_to be_redirect }
    end

    describe "POST 'create'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_confirm) }

      before { current_order.update_attributes(order_attributes) }
      before { post :create }

      let(:complete_orders) { Comable::Order.complete.where(guest_token: cookies.signed[:guest_token]) }

      its(:response) { should be_success }

      it 'has flash messages' do
        expect(flash[:notice]).to eq I18n.t('comable.orders.success')
      end

      it 'has assigned completed @order' do
        expect(assigns(:order).completed?).to be true
      end

      it 'has assigned completed @order with a detail' do
        expect(assigns(:order).order_details.count).to eq(1)
      end

      context 'when out of stock' do
        let(:stock) { FactoryGirl.create(:stock, :soldout) }

        its(:response) { is_expected.to redirect_to(controller.comable.cart_path) }
      end
    end

    context 'when order invalid' do
      before { post :create }

      its(:response) { is_expected.to redirect_to(controller.comable.next_order_path(state: :orderer)) }

      it 'has flash messages' do
        expect(flash[:alert]).to eq I18n.t('comable.orders.failure')
      end
    end
  end

  context 'when guest' do
    it_behaves_like 'checkout' do
      let(:customer) { Comable::Customer.new.with_cookies(cookies) }
    end
  end

  context 'when customer is signed in' do
    it_behaves_like 'checkout' do
      let(:customer) { FactoryGirl.create(:customer) }
    end
  end

  describe 'order mailer' do
    let!(:store) { FactoryGirl.create(:store, :email_activate) }

    let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_confirm) }
    let(:customer) { Comable::Customer.new.with_cookies(cookies) }

    before { controller.current_order.update_attributes(order_attributes) }
    before { allow(controller).to receive(:current_customer).and_return(customer) }
    before { customer.add_cart_item(product) }

    it 'sent a mail' do
      expect { post :create }.to change { ActionMailer::Base.deliveries.length }.by(1)
    end

    context 'No email sender' do
      let!(:store) { FactoryGirl.create(:store, :email_activate, email_sender: nil) }

      it 'not sent a mail' do
        expect { post :create }.to change { ActionMailer::Base.deliveries.length }.by(0)
      end
    end

    context 'No email activate' do
      let!(:store) { FactoryGirl.create(:store, :email_activate, email_activate_flag: false) }

      it 'not sent a mail' do
        expect { post :create }.to change { ActionMailer::Base.deliveries.length }.by(0)
      end
    end
  end
end
