describe Comable::Admin::DraftOrdersController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) do
    attributes_for(
      :order,
      :draft,
      bill_address_attributes: address_attributes,
      ship_address_attributes: address_attributes,
      order_items_attributes: [order_items_attributes]
    )
  end
  let(:invalid_attributes) { valid_attributes.merge(email: 'x' * 1024) }
  let(:address_attributes) { attributes_for(:address) }
  # Generate attributes with a product
  let(:order_items_attributes) { build(:order_item).attributes }

  describe 'GET index' do
    it 'assigns all draft orders as @orders' do
      order = create(:order, :draft)
      get :index
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe 'GET show' do
    it 'assigns the requested draft order as @order' do
      order = create(:order, :draft)
      get :show, id: order.to_param
      expect(assigns(:order)).to eq(order)
    end
  end

  describe 'GET new' do
    it 'assigns a new draft order as @order' do
      get :new
      expect(assigns(:order)).to be_a_new(Comable::Order)
      expect(assigns(:order)).to be_draft
    end
  end

  describe 'GET edit' do
    it 'assigns the requested draft order as @order' do
      order = create(:order, :draft)
      get :edit, id: order.to_param
      expect(assigns(:order)).to eq(order)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new order' do
        expect { post :create, order: valid_attributes }.to change(Comable::Order, :count).by(1)
      end

      it 'assigns a newly created order as @order' do
        post :create, order: valid_attributes
        expect(assigns(:order)).to be_a(Comable::Order)
        expect(assigns(:order)).to be_persisted
        expect(assigns(:order)).not_to be_draft
        expect(assigns(:order)).to be_completed
      end

      it 'redirects to the created order on completed' do
        post :create, order: valid_attributes
        expect(response).to redirect_to([comable, :admin, assigns(:order)])
      end

      context 'when a shipment method is existed' do
        before { create(:shipment_method) }

        it 'creates a new draft order' do
          expect { post :create, order: valid_attributes }.to change(Comable::Order.draft, :count).by(1)
        end

        it 'assigns a newly created order as @order' do
          post :create, order: valid_attributes
          expect(assigns(:order)).to be_a(Comable::Order)
          expect(assigns(:order)).to be_persisted
          expect(assigns(:order)).to be_draft
          expect(assigns(:order)).to be_shipment
        end

        it 'redirects to the created draft order' do
          post :create, order: valid_attributes
          expect(response).to redirect_to([comable, :admin, :draft, assigns(:order)])
        end
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved draft order as @order' do
        post :create, order: invalid_attributes
        expect(assigns(:order)).to be_a_new(Comable::Order)
        expect(assigns(:order)).to be_draft
      end

      it "re-renders the 'new' template" do
        post :create, order: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:order) { create(:order, :draft) }

    describe 'with valid params' do
      let(:new_attributes) { { email: "NEW: #{order.email}" } }

      it 'updates the requested draft order' do
        put :update, id: order.to_param, order: new_attributes
        order.reload
        expect(order).to have_attributes(new_attributes)
      end

      it 'assigns the requested draft order as @order' do
        put :update, id: order.to_param, order: valid_attributes
        expect(assigns(:order)).to eq(order)
      end

      it 'redirects to the order on complete' do
        put :update, id: order.to_param, order: valid_attributes
        expect(assigns(:order)).to be_completed
        expect(response).to redirect_to([comable, :admin, order])
      end

      it 'redirects to the draft order on shipment' do
        create(:shipment_method)
        put :update, id: order.to_param, order: valid_attributes
        expect(assigns(:order)).to be_shipment
        expect(response).to redirect_to([comable, :admin, :draft, order])
      end
    end

    describe 'with invalid params' do
      it 'assigns the draft order as @order' do
        put :update, id: order.to_param, order: invalid_attributes
        expect(assigns(:order)).to eq(order)
      end

      it "re-renders the 'edit' template" do
        put :update, id: order.to_param, order: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end
end
