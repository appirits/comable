describe Comable::Admin::OrdersController do
  sign_in_admin

  let(:comable) { controller.comable }

  before { request.env['HTTP_REFERER'] = 'http://localhost:3000' }

  describe 'GET index' do
    it 'assigns all orders as @orders' do
      order = FactoryGirl.create(:order, :completed)
      get :index
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe 'GET show' do
    it 'assigns the requested order as @order' do
      order = FactoryGirl.create(:order, :completed)
      get :show, id: order.to_param
      expect(assigns(:order)).to eq(order)
    end
  end

  describe 'GET export' do
    it 'exports the csv file' do
      order = FactoryGirl.create(:order, :completed)
      order_item = FactoryGirl.create(:order_item, order: order)
      get :export, format: :csv
      expect(response.body).to include(order.code)
      expect(response.body).to include(order.bill_address.first_name)
      expect(response.body).to include(order.bill_address.family_name)
      expect(response.body).to include(order_item.code)
    end

    it 'exports the xlsx file' do
      order = FactoryGirl.create(:order, :completed)
      FactoryGirl.create(:order_item, order: order)
      get :export, format: :xlsx
      expect(response.content_type).to eq(Mime::XLSX)
    end
  end

  describe 'POST cancel' do
    let(:order) { FactoryGirl.create(:order, :completed) }

    it 'cancel the requested order' do
      post :cancel, id: order.to_param
      order.reload
      expect(order).to be_canceled
    end

    it 'restock the requested order' do
      stock = FactoryGirl.create(:stock, :stocked, :with_product)
      order_item = FactoryGirl.create(:order_item, stock: stock)
      order.order_items << order_item

      expect { post :cancel, id: order.to_param }.to change { stock.reload.quantity }.by(order_item.quantity)
    end

    it 'redirects back' do
      post :cancel, id: order.to_param
      expect(response).to redirect_to(:back)
    end
  end

  describe 'POST resume' do
    let(:order) { FactoryGirl.create(:order, :completed) }
    let(:order_item) { FactoryGirl.create(:order_item, stock: stock) }
    let(:stock) { FactoryGirl.create(:stock, :stocked, :with_product) }

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

      it 'keep the requested order cancel' do
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
  end

  describe 'POST cancel_shipment' do
    let(:order) { FactoryGirl.create(:order, :completed) }

    before { order.payment.next_state! }

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
    let(:order) { FactoryGirl.create(:order, :completed) }

    before { order.payment.next_state! }
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
    let(:order) { FactoryGirl.create(:order, :completed) }

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
    let(:order) { FactoryGirl.create(:order, :completed) }

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
    let(:order) { FactoryGirl.create(:order, :completed) }

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
