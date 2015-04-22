describe Comable::Admin::OrdersController do
  sign_in_admin

  let(:comable) { controller.comable }

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

    it 'redirects to the order' do
      post :cancel, id: order.to_param
      expect(response).to redirect_to([comable, :admin, order])
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

      it 'redirects to the order' do
        post :resume, id: order.to_param
        expect(response).to redirect_to([comable, :admin, order])
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

      it 'redirects to the order' do
        post :resume, id: order.to_param
        expect(response).to redirect_to([comable, :admin, order])
      end

      it 'assigns the message as flash[:alert]' do
        post :resume, id: order.to_param
        order.reload
        expect(flash[:alert]).to include(Comable.t('errors.messages.out_of_stock', name: stock.name_with_sku))
      end
    end
  end
end
