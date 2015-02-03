describe Comable::Admin::StocksController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { FactoryGirl.attributes_for(:stock) }
  let(:invalid_attributes) { valid_attributes.merge(code: 'x' * 1024) }

  let!(:product) { FactoryGirl.create(:product) }

  describe 'GET index' do
    it 'assigns all stocks as @stocks' do
      stock = FactoryGirl.create(:stock, product: product)
      get :index, product_id: product.id
      expect(assigns(:stocks)).to eq([stock])
    end
  end

  describe 'GET show' do
    it 'assigns the requested stock as @stock' do
      stock = FactoryGirl.create(:stock, product: product)
      get :show, product_id: product.id, id: stock.to_param
      expect(assigns(:stock)).to eq(stock)
    end
  end

  describe 'GET new' do
    it 'assigns a new stock as @stock' do
      get :new, product_id: product.id
      expect(assigns(:stock)).to be_a_new(Comable::Stock)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested stock as @stock' do
      stock = FactoryGirl.create(:stock, product: product)
      get :edit, product_id: product.id, id: stock.to_param
      expect(assigns(:stock)).to eq(stock)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::Stock' do
        expect { post :create, product_id: product.id, stock: valid_attributes }.to change(Comable::Stock, :count).by(1)
      end

      it 'assigns a newly created stock as @stock' do
        post :create, product_id: product.id, stock: valid_attributes
        expect(assigns(:stock)).to be_a(Comable::Stock)
        expect(assigns(:stock)).to be_persisted
      end

      it 'redirects to the created stock' do
        post :create, product_id: product.id, stock: valid_attributes
        stock = Comable::Stock.last
        expect(response).to redirect_to([comable, :admin, stock.product, stock])
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved stock as @stock' do
        post :create, product_id: product.id, stock: invalid_attributes
        expect(assigns(:stock)).to be_a_new(Comable::Stock)
      end

      it "re-renders the 'new' template" do
        post :create, product_id: product.id, stock: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:stock) { FactoryGirl.create(:stock, product: product) }

    describe 'with valid params' do
      let(:new_attributes) { { code: "new_#{stock.code}" } }

      it 'updates the requested stock' do
        put :update, product_id: product.id, id: stock.to_param, stock: new_attributes
        stock.reload
        expect(stock).to have_attributes(new_attributes)
      end

      it 'assigns the requested stock as @stock' do
        put :update, product_id: product.id, id: stock.to_param, stock: valid_attributes
        expect(assigns(:stock)).to eq(stock)
      end

      it 'redirects to the stock' do
        put :update, product_id: product.id, id: stock.to_param, stock: valid_attributes
        expect(response).to redirect_to([comable, :admin, stock.product, stock])
      end
    end

    describe 'with invalid params' do
      it 'assigns the stock as @stock' do
        put :update, product_id: product.id, id: stock.to_param, stock: invalid_attributes
        expect(assigns(:stock)).to eq(stock)
      end

      it "re-renders the 'edit' template" do
        put :update, product_id: product.id, id: stock.to_param, stock: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested stock' do
      stock = FactoryGirl.create(:stock, product: product)
      expect { delete :destroy, product_id: product.id, id: stock.to_param }.to change(Comable::Stock, :count).by(-1)
    end

    it 'redirects to the stocks list' do
      stock = FactoryGirl.create(:stock, product: product)
      delete :destroy, product_id: product.id, id: stock.to_param
      expect(response).to redirect_to([comable, :admin, product, :stocks])
    end
  end
end
