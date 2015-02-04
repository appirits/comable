describe Comable::Admin::StoreController, type: :controller do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { FactoryGirl.attributes_for(:store) }
  let(:invalid_attributes) { valid_attributes.merge(name: 'x' * 1024) }

  describe 'GET show' do
    it "renders the 'edit' template" do
      get :show
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET edit' do
    context 'when store is not persisted' do
      it 'assigns a newly store as @store' do
        get :edit
        expect(assigns(:store)).to be_a_new(Comable::Store)
      end
    end

    context 'when store is persisted' do
      let!(:store) { FactoryGirl.create(:store) }

      it 'assigns the requested store as @store' do
        get :edit
        expect(assigns(:store)).to eq(store)
      end
    end
  end

  describe 'PUT update' do
    context 'when store is persisted' do
      let!(:store) { FactoryGirl.create(:store) }

      describe 'with valid params' do
        let(:new_attributes) { { name: "NEW: #{store.name}" } }

        it 'updates the requested store' do
          put :update, id: store.to_param, store: new_attributes
          store.reload
          expect(store).to have_attributes(new_attributes)
        end

        it 'assigns the requested store as @store' do
          put :update, id: store.to_param, store: valid_attributes
          expect(assigns(:store)).to eq(store)
        end

        it 'redirects to the store' do
          put :update, id: store.to_param, store: valid_attributes
          expect(response).to redirect_to(comable.admin_store_path)
        end
      end

      describe 'with invalid params' do
        it 'assigns the store as @store' do
          put :update, id: store.to_param, store: invalid_attributes
          expect(assigns(:store)).to eq(store)
        end

        it "re-renders the 'edit' template" do
          put :update, id: store.to_param, store: invalid_attributes
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when store is not persisted' do
      describe 'with valid params' do
        it 'creates a new Comable::Store' do
          expect { put :update, store: valid_attributes }.to change(Comable::Store, :count).by(1)
        end

        it 'assigns a newly created store as @store' do
          put :update, store: valid_attributes
          expect(assigns(:store)).to be_a(Comable::Store)
          expect(assigns(:store)).to be_persisted
        end

        it 'redirects to the created store' do
          put :update, store: valid_attributes
          expect(response).to redirect_to(comable.admin_store_path)
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved store as @store' do
          put :update, store: invalid_attributes
          expect(assigns(:store)).to be_a_new(Comable::Store)
        end

        it "re-renders the 'edit' template" do
          put :update, store: invalid_attributes
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
