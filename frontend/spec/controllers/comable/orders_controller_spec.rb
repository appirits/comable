describe Comable::OrdersController do
  render_views

  let(:product) { FactoryGirl.create(:product, stocks: [stock]) }
  let(:stock) { FactoryGirl.create(:stock, :stocked) }
  let(:address_attributes) { FactoryGirl.attributes_for(:address) }
  let(:current_order) { controller.current_order }

  describe "GET 'signin'" do
    before { get :signin }

    context 'when empty cart' do
      its(:response) { is_expected.to redirect_to(:cart) }

      it 'has flash messages' do
        expect(flash[:alert]).to eq Comable.t('carts.empty')
      end
    end
  end

  # TODO: Refactaring
  #   - subject { response }
  #   - remove 'its'
  #   - 'with state' => context
  shared_examples 'checkout' do
    let!(:payment_method) { FactoryGirl.create(:payment_method) }
    let!(:shipment_method) { FactoryGirl.create(:shipment_method) }

    let(:product) { FactoryGirl.create(:product, stocks: [stock]) }
    let(:stock) { FactoryGirl.create(:stock, :stocked) }
    let(:address_attributes) { FactoryGirl.attributes_for(:address) }
    let(:current_order) { controller.current_order }

    before { allow(controller).to receive(:current_comable_user).and_return(user) }
    before { user.add_cart_item(product) }

    describe "GET 'signin'" do
      before { skip 'Unnecessary test case' if user.signed_in? }
      before { get :signin }

      its(:response) { is_expected.to render_template(:signin) }
      its(:response) { is_expected.not_to be_redirect }

      it 'cart has any items' do
        expect(user.cart.count).to be_nonzero
      end
    end

    describe "PUT 'guest'" do
      let(:order_attributes) { { email: 'test@example.com' } }

      before { skip 'Unnecessary test case' if user.signed_in? }
      before { put :guest, order: order_attributes }

      its(:response) { is_expected.to redirect_to(controller.comable.next_order_path(state: :orderer)) }

      context 'when email is empty' do
        let(:order_attributes) { { email: nil } }

        its(:response) { is_expected.to render_template(:signin) }
        its(:response) { is_expected.not_to be_redirect }
      end
    end

    describe "GET 'edit' with state 'orderer'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_orderer) }

      before { current_order.update_attributes(order_attributes) }
      before { get :edit, state: :orderer }

      its(:response) { is_expected.to render_template(:orderer) }
      its(:response) { is_expected.not_to be_redirect }

      context 'when not exist email' do
        let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_orderer, email: nil) }

        it { is_expected.to redirect_to(controller.comable.signin_order_path) }
      end
    end

    describe "PUT 'update' with state 'orderer'" do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_orderer) }

      before { current_order.update_attributes(order_attributes) }

      context 'when not exist bill address' do
        before { put :update, state: :orderer }

        its(:response) { is_expected.to render_template(:orderer) }
        its(:response) { is_expected.not_to be_redirect }

        it 'has assigned @order with errors' do
          expect(assigns(:order).errors.any?).to be true
          expect(assigns(:order).errors[:bill_address]).to be
        end
      end

      context 'when input new bill address' do
        before { put :update, state: :orderer, order: { bill_address_attributes: address_attributes } }

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
        before { put :update, state: :delivery }

        its(:response) { is_expected.to render_template(:delivery) }
        its(:response) { is_expected.not_to be_redirect }

        it 'has assigned @order with errors' do
          expect(assigns(:order).errors.any?).to be true
          expect(assigns(:order).errors[:ship_address]).to be
        end
      end

      context 'when input new shipping address' do
        before { put :update, state: :delivery, order: { ship_address_attributes: address_attributes } }

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
      before { put :update, state: :shipment, order: { shipment_method_id: shipment_method.id } }

      its(:response) { is_expected.to redirect_to(controller.comable.next_order_path(state: :payment)) }

      it 'has assigned @order with shipemnt method' do
        expect(assigns(:order).shipment.shipment_method).to eq(shipment_method)
      end
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
      before { put :update, state: :payment, order: { payment_method_id: payment_method.id } }

      its(:response) { is_expected.to redirect_to(controller.comable.next_order_path(state: :confirm)) }

      it 'has assigned @order with payment method' do
        expect(assigns(:order).payment_method).to eq(payment_method)
      end
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
        expect(flash[:notice]).to eq Comable.t('orders.success')
      end

      it 'has assigned completed @order' do
        expect(assigns(:order).completed?).to be true
      end

      it 'has assigned completed @order with a item' do
        expect(assigns(:order).order_items.count).to eq(1)
      end

      context 'when out of stock' do
        let(:stock) { FactoryGirl.create(:stock, :unstocked) }

        its(:response) { is_expected.to redirect_to(controller.comable.cart_path) }
      end
    end

    context 'when order invalid' do
      let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_orderer) }

      before { current_order.update_attributes(order_attributes) }
      before { post :create }

      its(:response) { is_expected.to redirect_to(controller.comable.next_order_path(state: :orderer)) }

      it 'has flash messages' do
        expect(flash[:alert]).to eq Comable.t('orders.failure')
      end
    end
  end

  context 'when guest' do
    it_behaves_like 'checkout' do
      let(:user) { Comable::User.new.with_cookies(cookies) }
    end
  end

  context 'when user is signed in' do
    it_behaves_like 'checkout' do
      let(:user) { FactoryGirl.create(:user) }
    end
  end

  describe 'order mailer' do
    let!(:store) { FactoryGirl.create(:store, :email_activate) }

    let(:order_attributes) { FactoryGirl.attributes_for(:order, :for_confirm) }
    let(:user) { Comable::User.new.with_cookies(cookies) }

    before { controller.current_order.update_attributes(order_attributes) }
    before { allow(controller).to receive(:current_comable_user).and_return(user) }
    before { user.add_cart_item(product) }

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
