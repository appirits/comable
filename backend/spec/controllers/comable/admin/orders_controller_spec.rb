describe Comable::Admin::OrdersController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { attributes_for(:order, :completed) }
  let(:invalid_attributes) { valid_attributes.merge(email: 'x' * 1024) }

  before { request.env['HTTP_REFERER'] = 'http://localhost:3000' }

  describe 'GET index' do
    it 'assigns all orders as @orders' do
      order = create(:order, :completed)
      get :index
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe 'GET show' do
    it 'assigns the requested order as @order' do
      order = create(:order, :completed)
      get :show, id: order.to_param
      expect(assigns(:order)).to eq(order)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested order as @order' do
      order = create(:order, :completed)
      get :edit, id: order.to_param
      expect(assigns(:order)).to eq(order)
    end
  end

  describe 'PUT update' do
    let!(:order) { create(:order, :completed) }

    describe 'with valid params' do
      let(:new_attributes) { { email: "NEW: #{order.email}" } }

      it 'updates the requested order' do
        put :update, id: order.to_param, order: new_attributes
        order.reload
        expect(order).to have_attributes(new_attributes)
      end

      it 'assigns the requested order as @order' do
        put :update, id: order.to_param, order: valid_attributes
        expect(assigns(:order)).to eq(order)
      end

      it 'redirects to the order' do
        put :update, id: order.to_param, order: valid_attributes
        expect(response).to redirect_to([comable, :admin, order])
      end
    end

    describe 'with invalid params' do
      it 'assigns the order as @order' do
        put :update, id: order.to_param, order: invalid_attributes
        expect(assigns(:order)).to eq(order)
      end

      it "re-renders the 'edit' template" do
        put :update, id: order.to_param, order: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET export' do
    it 'exports the csv file' do
      order = create(:order, :completed)
      order_item = create(:order_item, order: order)
      get :export, format: :csv
      expect(response.body).to include(order.code)
      expect(response.body).to include(order.bill_address.first_name)
      expect(response.body).to include(order.bill_address.family_name)
      expect(response.body).to include(order_item.sku)
    end

    it 'exports the xlsx file' do
      order = create(:order, :completed)
      create(:order_item, order: order)
      get :export, format: :xlsx
      expect(response.content_type).to eq(Mime::XLSX)
    end
  end

  describe 'POST cancel' do
    let(:order) { create(:order, :completed) }

    it 'cancel the requested order' do
      post :cancel, id: order.to_param
      order.reload
      expect(order).to be_canceled
    end

    it 'restock the requested order' do
      stock = create(:stock, :stocked, :with_product)
      order_item = create(:order_item, stock: stock)
      order.order_items << order_item

      expect { post :cancel, id: order.to_param }.to change { stock.reload.quantity }.by(order_item.quantity)
    end

    it 'redirects back' do
      post :cancel, id: order.to_param
      expect(response).to redirect_to(:back)
    end

    context 'with payment error' do
      before do
        allow(Comable::Order).to receive(:find).and_return(order)
        allow(order).to receive(:payment_cancel!).and_raise(Comable::PaymentProvider::Error)
      end

      it 'keep the state of requested order' do
        post :cancel, id: order.to_param
        order.reload
        expect(order).not_to be_canceled
      end

      it 'redirects back' do
        post :cancel, id: order.to_param
        expect(response).to redirect_to(:back)
      end
    end
  end

  describe 'POST resume' do
    let(:order) { create(:order, :completed) }
    let(:order_item) { create(:order_item, stock: stock) }
    let(:stock) { create(:stock, :stocked, :with_product) }

    before { order.cancel! }

    context 'with resumable order' do
      it 'resume the requested order' do
        post :resume, id: order.to_param
        order.reload
        expect(order).to be_resumed
      end

      it 'unstock the requested order' do
        order.order_items << order_item

        expect { post :resume, id: order.to_param }.to change { stock.reload.quantity }.by(-order_item.quantity)
      end

      it 'redirects back' do
        post :resume, id: order.to_param
        expect(response).to redirect_to(:back)
      end
    end

    context 'with out of stock' do
      before do
        order.order_items << order_item
        stock.update_attributes(quantity: 0)
      end

      it 'keep the state of requested order' do
        post :resume, id: order.to_param
        order.reload
        expect(order).to be_canceled
      end

      it 'redirects back' do
        post :resume, id: order.to_param
        expect(response).to redirect_to(:back)
      end

      it 'assigns the message as flash[:alert]' do
        post :resume, id: order.to_param
        order.reload
        expect(flash[:alert]).to include(Comable.t('errors.messages.out_of_stock', name: stock.name_with_sku))
      end
    end

    context 'with payment error' do
      before do
        allow(order.payment).to receive(:resume!).and_raise(StandardError)
      end

      it 'keep the state of requested order' do
        post :resume, id: order.to_param
        order.reload
        expect(order).not_to be_resumed
      end

      it 'redirects back' do
        post :resume, id: order.to_param
        expect(response).to redirect_to(:back)
      end

      it 'assigns the message as flash[:alert]' do
        post :resume, id: order.to_param
        order.reload
        expect(flash[:alert]).to include(Comable::Payment.model_name.human)
      end
    end
  end

  describe 'POST cancel_shipment' do
    let(:order) { create(:order, :completed) }

    it 'cancel the shipment of the requested order' do
      post :cancel_payment, id: order.to_param
      order.reload
      expect(order.payment).to be_canceled
    end

    it 'redirects back' do
      post :cancel_payment, id: order.to_param
      expect(response).to redirect_to(:back)
    end
  end

  describe 'POST resume_shipment' do
    let(:order) { create(:order, :completed) }

    before { order.payment.cancel! }

    it 'resume the payment of the requested order' do
      post :resume_payment, id: order.to_param
      order.reload
      expect(order.payment).to be_resumed
    end

    it 'redirects back' do
      post :resume_payment, id: order.to_param
      expect(response).to redirect_to(:back)
    end
  end

  describe 'POST ship' do
    let(:order) { create(:order, :completed) }

    it 'ship the requested order' do
      post :ship, id: order.to_param
      order.reload
      expect(order.shipment).to be_completed
    end

    it 'redirects back' do
      post :ship, id: order.to_param
      expect(response).to redirect_to(:back)
    end
  end

  describe 'POST cancel_shipment' do
    let(:order) { create(:order, :completed) }

    before { order.shipment.ship! }

    it 'cancel the shipment of the requested order' do
      post :cancel_shipment, id: order.to_param
      order.reload
      expect(order.shipment).to be_canceled
    end

    it 'redirects back' do
      post :cancel_shipment, id: order.to_param
      expect(response).to redirect_to(:back)
    end
  end

  describe 'POST resume_shipment' do
    let(:order) { create(:order, :completed) }

    before { order.shipment.ship! }
    before { order.shipment.cancel! }

    it 'resume the shipment of the requested order' do
      post :resume_shipment, id: order.to_param
      order.reload
      expect(order.shipment).to be_resumed
    end

    it 'redirects back' do
      post :resume_shipment, id: order.to_param
      expect(response).to redirect_to(:back)
    end
  end
end
