describe Comable::Admin::ProductsController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { attributes_for(:product) }
  let(:invalid_attributes) { valid_attributes.merge(name: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all products as @products' do
      product = create(:product)
      get :index
      expect(assigns(:products)).to eq([product])
    end
  end

  describe 'GET show' do
    it 'assigns the requested product as @product' do
      product = create(:product)
      get :show, id: product.to_param
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'GET new' do
    it 'assigns a new product as @product' do
      get :new
      expect(assigns(:product)).to be_a_new(Comable::Product)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested product as @product' do
      product = create(:product)
      get :edit, id: product.to_param
      expect(assigns(:product)).to eq(product)
    end

    it 'create preview session' do
      product = create(:product)
      get :edit, id: product.to_param
      expect(session[Comable::Product::PREVIEW_SESSION_KEY][product.to_param]).to eq(true)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::Product' do
        expect { post :create, product: valid_attributes }.to change(Comable::Product, :count).by(1)
      end

      it 'assigns a newly created product as @product' do
        post :create, product: valid_attributes
        expect(assigns(:product)).to be_a(Comable::Product)
        expect(assigns(:product)).to be_persisted
      end

      it 'redirects to the created product' do
        post :create, product: valid_attributes
        expect(response).to redirect_to([comable, :admin, Comable::Product.last])
      end

      context 'and a image' do
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('public/favicon.ico'), 'image/vnd.microsoft.icon') }

        it 'assigns a newly created product as @product with a image' do
          post :create, product: valid_attributes.merge(images_attributes: { '0' => { file: file } })
          expect(assigns(:product)).to be_persisted
          expect(assigns(:product).images.count).to eq(1)
        end
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved product as @product' do
        post :create, product: invalid_attributes
        expect(assigns(:product)).to be_a_new(Comable::Product)
      end

      it "re-renders the 'new' template" do
        post :create, product: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:product) { create(:product) }

    describe 'with valid params' do
      let(:new_attributes) { { name: "NEW: #{product.name}" } }

      it 'updates the requested product' do
        put :update, id: product.to_param, product: new_attributes
        product.reload
        expect(product).to have_attributes(new_attributes)
      end

      it 'assigns the requested product as @product' do
        put :update, id: product.to_param, product: valid_attributes
        expect(assigns(:product)).to eq(product)
      end

      it 'redirects to the product' do
        put :update, id: product.to_param, product: valid_attributes
        expect(response).to redirect_to([comable, :admin, product])
      end
    end

    describe 'with invalid params' do
      it 'assigns the product as @product' do
        put :update, id: product.to_param, product: invalid_attributes
        expect(assigns(:product)).to eq(product)
      end

      it "re-renders the 'edit' template" do
        put :update, id: product.to_param, product: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested product' do
      product = create(:product)
      expect { delete :destroy, id: product.to_param }.to change(Comable::Product, :count).by(-1)
    end

    it 'redirects to the products list' do
      product = create(:product)
      delete :destroy, id: product.to_param
      expect(response).to redirect_to([comable, :admin, :products])
    end
  end

  describe 'GET export' do
    it 'exports the csv file' do
      product = create(:product)
      get :export, format: :csv
      expect(response.body).to include(product.code)
      expect(response.body).to include(product.name)
    end

    it 'exports the xlsx file' do
      create(:product)
      get :export, format: :xlsx
      expect(response.content_type).to eq(Mime::XLSX)
    end
  end

  describe 'POST import' do
    context 'successful' do
      it 'redirects to the products list' do
        allow(Comable::Product).to receive(:import_from)
        post :import
        expect(response).to redirect_to([comable, :admin, :products])
      end

      it 'assigns the message as flash[:notine]' do
        allow(Comable::Product).to receive(:import_from)
        post :import
        expect(flash[:notice]).to eq(Comable.t('successful'))
      end
    end

    context 'failure' do
      it 'redirects to the products list' do
        allow(Comable::Product).to receive(:import_from) { fail Comable::Importable::Exception }
        post :import
        expect(response).to redirect_to([comable, :admin, :products])
      end

      it 'assigns the message as flash[:alert]' do
        alert_message = 'message'
        allow(Comable::Product).to receive(:import_from) { fail Comable::Importable::Exception, alert_message }
        post :import
        expect(flash[:alert]).to eq(alert_message)
      end
    end
  end
end
