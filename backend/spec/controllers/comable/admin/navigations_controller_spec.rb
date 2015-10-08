describe Comable::Admin::NavigationsController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) do
    attributes_for(:navigation).merge(
      navigation_items_attributes: build(:navigation_item).attributes
    )
  end
  let(:invalid_attributes) { valid_attributes.merge(name: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all navigations as @navigations' do
      navigation = create(:navigation, navigation_items: [create(:navigation_item)])
      get :index
      expect(assigns(:navigations)).to eq([navigation])
    end
  end

  describe 'GET show' do
    it 'assigns the requested navigation as @navigation' do
      navigation = create(:navigation, navigation_items: [create(:navigation_item)])
      get :show, id: navigation.to_param
      expect(assigns(:navigation)).to eq(navigation)
    end
  end

  describe 'GET new' do
    it 'assigns a new navigation as @navigation' do
      get :new
      expect(assigns(:navigation)).to be_a_new(Comable::Navigation)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested navigation as @navigation' do
      navigation = create(:navigation, navigation_items: [create(:navigation_item)])
      get :edit, id: navigation.to_param
      expect(assigns(:navigation)).to eq(navigation)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::Navigation' do
        expect { post :create, navigation: valid_attributes }.to change(Comable::Navigation, :count).by(1)
      end

      it 'assigns a newly created navigation as @navigation' do
        post :create, navigation: valid_attributes
        expect(assigns(:navigation)).to be_a(Comable::Navigation)
        expect(assigns(:navigation)).to be_persisted
      end

      it 'redirects to the created navigation' do
        post :create, navigation: valid_attributes
        expect(response).to redirect_to([comable, :admin, Comable::Navigation.last])
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved navigation as @navigation' do
        post :create, navigation: invalid_attributes
        expect(assigns(:navigation)).to be_a_new(Comable::Navigation)
      end

      it "re-renders the 'new' template" do
        post :create, navigation: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:navigation) { create(:navigation, navigation_items: [create(:navigation_item)]) }

    describe 'with valid params' do
      let(:new_attributes) { { name: "NEW: #{navigation.name}" } }

      it 'updates the requested navigation' do
        put :update, id: navigation.to_param, navigation: new_attributes
        navigation.reload
        expect(navigation).to have_attributes(new_attributes)
      end

      it 'assigns the requested navigation as @navigation' do
        put :update, id: navigation.to_param, navigation: valid_attributes
        expect(assigns(:navigation)).to eq(navigation)
      end

      it 'redirects to the navigation' do
        put :update, id: navigation.to_param, navigation: valid_attributes
        expect(response).to redirect_to([comable, :admin, navigation.reload])
      end
    end

    describe 'with invalid params' do
      it 'assigns the navigation as @navigation' do
        put :update, id: navigation.to_param, navigation: invalid_attributes
        expect(assigns(:navigation)).to eq(navigation)
      end

      it "re-renders the 'edit' template" do
        put :update, id: navigation.to_param, navigation: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested navigation' do
      navigation = create(:navigation, navigation_items: [create(:navigation_item)])
      expect { delete :destroy, id: navigation.to_param }.to change(Comable::Navigation, :count).by(-1)
    end

    it 'redirects to the navigations list' do
      navigation = create(:navigation, navigation_items: [create(:navigation_item)])
      delete :destroy, id: navigation.to_param
      expect(response).to redirect_to([comable, :admin, :navigations])
    end
  end

  describe 'POST search_linkable_ids' do
    context 'with valid params' do
      before do
        post :search_linkable_ids, linkable_type: Comable::Product.to_s, position: 0
      end

      it 'assigns the linkable_id_options' do
        expect(assigns(:linkable_id_options)).to eq Comable::NavigationItem.linkable_id_options(Comable::Product)
      end

      it 'layout false' do
        expect(response).to render_template(layout: false)
      end
    end

    context 'with invalid params' do
      before do
        post :search_linkable_ids, position: 0
      end

      it 'assigns the linkable_id_options' do
        expect(assigns(:linkable_id_options).all?(&:blank?)).to eq true
      end

      it 'layout false' do
        expect(response).to render_template(layout: false)
      end
    end
  end
end
