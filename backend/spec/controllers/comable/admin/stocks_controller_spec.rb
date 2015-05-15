describe Comable::Admin::StocksController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { attributes_for(:stock) }
  let(:invalid_attributes) { valid_attributes.merge(code: 'x' * 1024) }

  let(:product) { create(:product) }

  describe 'GET index' do
    it 'assigns all stocks as @stocks' do
      stock = create(:stock, product: product)
      get :index
      expect(assigns(:stocks)).to eq([stock])
    end
  end

  describe 'GET show' do
    it 'assigns the requested stock as @stock' do
      stock = create(:stock, product: product)
      get :show, id: stock.to_param
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
      stock = create(:stock, product: product)
      get :edit, id: stock.to_param
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
        expect(response).to redirect_to([comable, :admin, stock])
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
    let!(:stock) { create(:stock, product: product) }

    describe 'with valid params' do
      let(:new_attributes) { { code: "new_#{stock.code}" } }

      it 'updates the requested stock' do
        put :update, id: stock.to_param, stock: new_attributes
        stock.reload
        expect(stock).to have_attributes(new_attributes)
      end

      it 'assigns the requested stock as @stock' do
        put :update, id: stock.to_param, stock: valid_attributes
        expect(assigns(:stock)).to eq(stock)
      end

      it 'redirects to the stock' do
        put :update, id: stock.to_param, stock: valid_attributes
        expect(response).to redirect_to([comable, :admin, stock])
      end
    end

    describe 'with invalid params' do
      it 'assigns the stock as @stock' do
        put :update, id: stock.to_param, stock: invalid_attributes
        expect(assigns(:stock)).to eq(stock)
      end

      it "re-renders the 'edit' template" do
        put :update, id: stock.to_param, stock: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested stock' do
      stock = create(:stock, product: product)
      expect { delete :destroy, id: stock.to_param }.to change(Comable::Stock, :count).by(-1)
    end

    it 'redirects to the stocks list' do
      stock = create(:stock, product: product)
      delete :destroy, id: stock.to_param
      expect(response).to redirect_to([comable, :admin, :stocks])
    end
  end

  describe 'GET export' do
    it 'exports the csv file' do
      stock = create(:stock, product: product)
      get :export, format: :csv
      expect(response.body).to include(product.code)
      expect(response.body).to include(stock.code)
      expect(response.body).to include(stock.quantity.to_s)
    end

    it 'exports the xlsx file' do
      create(:stock, product: product)
      get :export, format: :xlsx
      expect(response.content_type).to eq(Mime::XLSX)
    end
  end

  describe 'POST import' do
    context 'successful' do
      it 'redirects to the stocks list' do
        allow(Comable::Stock).to receive(:import_from)
        post :import
        expect(response).to redirect_to([comable, :admin, :stocks])
      end

      it 'assigns the message as flash[:notine]' do
        allow(Comable::Stock).to receive(:import_from)
        post :import
        expect(flash[:notice]).to eq(Comable.t('successful'))
      end
    end

    context 'failure' do
      it 'redirects to the stocks list' do
        allow(Comable::Stock).to receive(:import_from) { fail Comable::Importable::Exception }
        post :import
        expect(response).to redirect_to([comable, :admin, :stocks])
      end

      it 'assigns the message as flash[:alert]' do
        alert_message = 'message'
        allow(Comable::Stock).to receive(:import_from) { fail Comable::Importable::Exception, alert_message }
        post :import
        expect(flash[:alert]).to eq(alert_message)
      end
    end
  end
end
