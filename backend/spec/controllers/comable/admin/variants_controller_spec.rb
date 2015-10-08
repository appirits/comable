describe Comable::Admin::VariantsController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { attributes_for(:variant) }
  let(:invalid_attributes) { valid_attributes.merge(sku: 'x' * 1024) }

  let(:product) { create(:product, variants: []) }

  describe 'GET index' do
    it 'assigns all variants as @variants' do
      variant = create(:variant, product: product)
      get :index, product_id: product.to_param
      expect(assigns(:variants)).to eq([variant])
    end
  end

  describe 'GET show' do
    it 'assigns the requested variant as @variant' do
      variant = create(:variant, product: product)
      get :show, product_id: product.to_param, id: variant.to_param
      expect(assigns(:variant)).to eq(variant)
    end
  end

  describe 'GET new' do
    it 'assigns a new variant as @variant' do
      get :new, product_id: product.to_param
      expect(assigns(:variant)).to be_a_new(Comable::Variant)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested variant as @variant' do
      variant = create(:variant, product: product)
      get :edit, product_id: product.to_param, id: variant.to_param
      expect(assigns(:variant)).to eq(variant)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::Variant' do
        expect { post :create, product_id: product.to_param, variant: valid_attributes }.to change(Comable::Variant, :count).by(1)
      end

      it 'assigns a newly created variant as @variant' do
        post :create, product_id: product.to_param, variant: valid_attributes
        expect(assigns(:variant)).to be_a(Comable::Variant)
        expect(assigns(:variant)).to be_persisted
      end

      it 'redirects to the created variant' do
        post :create, product_id: product.to_param, variant: valid_attributes
        expect(response).to redirect_to([comable, :admin, product, Comable::Variant.last])
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved variant as @variant' do
        post :create, product_id: product.to_param, variant: invalid_attributes
        expect(assigns(:variant)).to be_a_new(Comable::Variant)
      end

      it "re-renders the 'new' template" do
        post :create, product_id: product.to_param, variant: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:variant) { create(:variant, product: product) }

    describe 'with valid params' do
      let(:new_attributes) { { sku: "NEW: #{variant.sku}" } }

      it 'updates the requested variant' do
        put :update, product_id: product.to_param, id: variant.to_param, variant: new_attributes
        variant.reload
        expect(variant).to have_attributes(new_attributes)
      end

      it 'assigns the requested variant as @variant' do
        put :update, product_id: product.to_param, id: variant.to_param, variant: valid_attributes
        expect(assigns(:variant)).to eq(variant)
      end

      it 'redirects to the variant' do
        put :update, product_id: product.to_param, id: variant.to_param, variant: valid_attributes
        expect(response).to redirect_to([comable, :admin, product, variant])
      end
    end

    describe 'with invalid params' do
      it 'assigns the variant as @variant' do
        put :update, product_id: product.to_param, id: variant.to_param, variant: invalid_attributes
        expect(assigns(:variant)).to eq(variant)
      end

      it "re-renders the 'edit' template" do
        put :update, product_id: product.to_param, id: variant.to_param, variant: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested variant' do
      variant = create(:variant, product: product)
      expect { delete :destroy, product_id: product.to_param, id: variant.to_param }.to change(Comable::Variant, :count).by(-1)
    end

    it 'redirects to the variants list' do
      variant = create(:variant, product: product)
      delete :destroy, product_id: product.to_param, id: variant.to_param
      expect(response).to redirect_to([comable, :admin, product])
    end
  end
end
