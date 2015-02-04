describe Comable::Admin::ShipmentMethodsController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { FactoryGirl.attributes_for(:shipment_method) }
  let(:invalid_attributes) { valid_attributes.merge(name: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all shipment_methods as @shipment_methods' do
      shipment_method = FactoryGirl.create(:shipment_method)
      get :index
      expect(assigns(:shipment_methods)).to eq([shipment_method])
    end
  end

  describe 'GET show' do
    it 'assigns the requested shipment_method as @shipment_method' do
      shipment_method = FactoryGirl.create(:shipment_method)
      get :show, id: shipment_method.to_param
      expect(assigns(:shipment_method)).to eq(shipment_method)
    end
  end

  describe 'GET new' do
    it 'assigns a new shipment_method as @shipment_method' do
      get :new
      expect(assigns(:shipment_method)).to be_a_new(Comable::ShipmentMethod)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested shipment_method as @shipment_method' do
      shipment_method = FactoryGirl.create(:shipment_method)
      get :edit, id: shipment_method.to_param
      expect(assigns(:shipment_method)).to eq(shipment_method)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::ShipmentMethod' do
        expect { post :create, shipment_method: valid_attributes }.to change(Comable::ShipmentMethod, :count).by(1)
      end

      it 'assigns a newly created shipment_method as @shipment_method' do
        post :create, shipment_method: valid_attributes
        expect(assigns(:shipment_method)).to be_a(Comable::ShipmentMethod)
        expect(assigns(:shipment_method)).to be_persisted
      end

      it 'redirects to the created shipment_method' do
        post :create, shipment_method: valid_attributes
        expect(response).to redirect_to([comable, :admin, Comable::ShipmentMethod.last])
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved shipment_method as @shipment_method' do
        post :create, shipment_method: invalid_attributes
        expect(assigns(:shipment_method)).to be_a_new(Comable::ShipmentMethod)
      end

      it "re-renders the 'new' template" do
        post :create, shipment_method: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:shipment_method) { FactoryGirl.create(:shipment_method) }

    describe 'with valid params' do
      let(:new_attributes) { { name: "NEW: #{shipment_method.name}" } }

      it 'updates the requested shipment_method' do
        put :update, id: shipment_method.to_param, shipment_method: new_attributes
        shipment_method.reload
        expect(shipment_method).to have_attributes(new_attributes)
      end

      it 'assigns the requested shipment_method as @shipment_method' do
        put :update, id: shipment_method.to_param, shipment_method: valid_attributes
        expect(assigns(:shipment_method)).to eq(shipment_method)
      end

      it 'redirects to the shipment_method' do
        put :update, id: shipment_method.to_param, shipment_method: valid_attributes
        expect(response).to redirect_to([comable, :admin, shipment_method])
      end
    end

    describe 'with invalid params' do
      it 'assigns the shipment_method as @shipment_method' do
        put :update, id: shipment_method.to_param, shipment_method: invalid_attributes
        expect(assigns(:shipment_method)).to eq(shipment_method)
      end

      it "re-renders the 'edit' template" do
        put :update, id: shipment_method.to_param, shipment_method: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested shipment_method' do
      shipment_method = FactoryGirl.create(:shipment_method)
      expect { delete :destroy, id: shipment_method.to_param }.to change(Comable::ShipmentMethod, :count).by(-1)
    end

    it 'redirects to the shipment_methods list' do
      shipment_method = FactoryGirl.create(:shipment_method)
      delete :destroy, id: shipment_method.to_param
      expect(response).to redirect_to([comable, :admin, :shipment_methods])
    end
  end
end
