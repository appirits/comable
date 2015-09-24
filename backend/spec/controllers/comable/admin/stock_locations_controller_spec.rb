describe Comable::Admin::StockLocationsController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { attributes_for(:stock_location) }
  let(:invalid_attributes) { valid_attributes.merge(name: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all stock_locations as @stock_locations' do
      stock_location = create(:stock_location)
      get :index
      expect(assigns(:stock_locations)).to eq([stock_location])
    end
  end

  describe 'GET show' do
    it 'assigns the requested stock_location as @stock_location' do
      stock_location = create(:stock_location)
      get :show, id: stock_location.to_param
      expect(assigns(:stock_location)).to eq(stock_location)
    end
  end

  describe 'GET new' do
    it 'assigns a new stock_location as @stock_location' do
      get :new
      expect(assigns(:stock_location)).to be_a_new(Comable::StockLocation)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested stock_location as @stock_location' do
      stock_location = create(:stock_location)
      get :edit, id: stock_location.to_param
      expect(assigns(:stock_location)).to eq(stock_location)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::StockLocation' do
        expect { post :create, stock_location: valid_attributes }.to change(Comable::StockLocation, :count).by(1)
      end

      it 'assigns a newly created stock_location as @stock_location' do
        post :create, stock_location: valid_attributes
        expect(assigns(:stock_location)).to be_a(Comable::StockLocation)
        expect(assigns(:stock_location)).to be_persisted
      end

      it 'redirects to the created stock_location' do
        post :create, stock_location: valid_attributes
        expect(response).to redirect_to([comable, :admin, Comable::StockLocation.last])
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved stock_location as @stock_location' do
        post :create, stock_location: invalid_attributes
        expect(assigns(:stock_location)).to be_a_new(Comable::StockLocation)
      end

      it "re-renders the 'new' template" do
        post :create, stock_location: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:stock_location) { create(:stock_location) }

    describe 'with valid params' do
      let(:new_attributes) { { name: "NEW: #{stock_location.name}" } }

      it 'updates the requested stock_location' do
        put :update, id: stock_location.to_param, stock_location: new_attributes
        stock_location.reload
        expect(stock_location).to have_attributes(new_attributes)
      end

      it 'assigns the requested stock_location as @stock_location' do
        put :update, id: stock_location.to_param, stock_location: valid_attributes
        expect(assigns(:stock_location)).to eq(stock_location)
      end

      it 'redirects to the stock_location' do
        put :update, id: stock_location.to_param, stock_location: valid_attributes
        expect(response).to redirect_to([comable, :admin, stock_location])
      end
    end

    describe 'with invalid params' do
      it 'assigns the stock_location as @stock_location' do
        put :update, id: stock_location.to_param, stock_location: invalid_attributes
        expect(assigns(:stock_location)).to eq(stock_location)
      end

      it "re-renders the 'edit' template" do
        put :update, id: stock_location.to_param, stock_location: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested stock_location' do
      stock_location = create(:stock_location)
      expect { delete :destroy, id: stock_location.to_param }.to change(Comable::StockLocation, :count).by(-1)
    end

    it 'redirects to the stock_locations list' do
      stock_location = create(:stock_location)
      delete :destroy, id: stock_location.to_param
      expect(response).to redirect_to([comable, :admin, :stock_locations])
    end
  end
end
