describe Comable::Admin::PagesController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { attributes_for(:page) }
  let(:invalid_attributes) { valid_attributes.merge(title: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all pages as @pages' do
      page = create(:page)
      get :index
      expect(assigns(:pages)).to eq([page])
    end
  end

  describe 'GET show' do
    it 'assigns the requested page as @page' do
      page = create(:page)
      get :show, id: page.to_param
      expect(assigns(:page)).to eq(page)
    end
  end

  describe 'GET new' do
    it 'assigns a new page as @page' do
      get :new
      expect(assigns(:page)).to be_a_new(Comable::Page)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested page as @page' do
      page = create(:page)
      get :edit, id: page.to_param
      expect(assigns(:page)).to eq(page)
    end

    it 'create preview session' do
      page = create(:page)
      get :edit, id: page.to_param
      expect(session[Comable::Page::PREVIEW_SESSION_KEY][page.slug]).to eq(true)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::Page' do
        expect { post :create, page: valid_attributes }.to change(Comable::Page, :count).by(1)
      end

      it 'assigns a newly created page as @page' do
        post :create, page: valid_attributes
        expect(assigns(:page)).to be_a(Comable::Page)
        expect(assigns(:page)).to be_persisted
      end

      it 'redirects to the created page' do
        post :create, page: valid_attributes
        expect(response).to redirect_to([comable, :admin, Comable::Page.last])
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved page as @page' do
        post :create, page: invalid_attributes
        expect(assigns(:page)).to be_a_new(Comable::Page)
      end

      it "re-renders the 'new' template" do
        post :create, page: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:page) { create(:page) }

    describe 'with valid params' do
      let(:new_attributes) { { title: "NEW: #{page.title}" } }

      it 'updates the requested page' do
        put :update, id: page.to_param, page: new_attributes
        page.reload
        expect(page).to have_attributes(new_attributes)
      end

      it 'assigns the requested page as @page' do
        put :update, id: page.to_param, page: valid_attributes
        expect(assigns(:page)).to eq(page)
      end

      it 'redirects to the page' do
        put :update, id: page.to_param, page: valid_attributes
        expect(response).to redirect_to([comable, :admin, page.reload])
      end
    end

    describe 'with invalid params' do
      it 'assigns the page as @page' do
        put :update, id: page.to_param, page: invalid_attributes
        expect(assigns(:page)).to eq(page)
      end

      it "re-renders the 'edit' template" do
        put :update, id: page.to_param, page: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested page' do
      page = create(:page)
      expect { delete :destroy, id: page.to_param }.to change(Comable::Page, :count).by(-1)
    end

    it 'redirects to the pages list' do
      page = create(:page)
      delete :destroy, id: page.to_param
      expect(response).to redirect_to([comable, :admin, :pages])
    end
  end
end
