describe Comable::Admin::ThemesController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { attributes_for(:theme) }
  let(:invalid_attributes) { valid_attributes.merge(display: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all themes as @themes' do
      theme = create(:theme)
      get :index
      expect(assigns(:themes)).to eq([theme])
    end
  end

  describe 'GET show' do
    it 'assigns the requested theme as @theme' do
      theme = create(:theme)
      get :show, id: theme.to_param
      expect(assigns(:theme)).to eq(theme)
    end
  end

  describe 'GET new' do
    it 'assigns a new theme as @theme' do
      get :new
      expect(assigns(:theme)).to be_a_new(Comable::Theme)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested theme as @theme' do
      theme = create(:theme)
      get :edit, id: theme.to_param
      expect(assigns(:theme)).to eq(theme)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::Theme' do
        expect { post :create, theme: valid_attributes }.to change(Comable::Theme, :count).by(1)
      end

      it 'assigns a newly created theme as @theme' do
        post :create, theme: valid_attributes
        expect(assigns(:theme)).to be_a(Comable::Theme)
        expect(assigns(:theme)).to be_persisted
      end

      it 'redirects to the created theme' do
        post :create, theme: valid_attributes
        expect(response).to redirect_to([comable, :admin, Comable::Theme.last])
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved theme as @theme' do
        post :create, theme: invalid_attributes
        expect(assigns(:theme)).to be_a_new(Comable::Theme)
      end

      it "re-renders the 'new' template" do
        post :create, theme: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:theme) { create(:theme) }

    describe 'with valid params' do
      let(:new_attributes) { { name: "NEW: #{theme.name}" } }
      let(:valid_attributes) { theme.attributes }

      it 'updates the requested theme' do
        put :update, id: theme.to_param, theme: new_attributes
        theme.reload
        expect(theme).to have_attributes(new_attributes)
      end

      it 'assigns the requested theme as @theme' do
        put :update, id: theme.to_param, theme: valid_attributes
        expect(assigns(:theme)).to eq(theme)
      end

      it 'redirects to the theme' do
        put :update, id: theme.to_param, theme: valid_attributes
        expect(response).to redirect_to([comable, :admin, theme])
      end
    end

    describe 'with invalid params' do
      it 'assigns the theme as @theme' do
        put :update, id: theme.to_param, theme: invalid_attributes
        expect(assigns(:theme)).to eq(theme)
      end

      it "re-renders the 'edit' template" do
        put :update, id: theme.to_param, theme: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested theme' do
      theme = create(:theme)
      expect { delete :destroy, id: theme.to_param }.to change(Comable::Theme, :count).by(-1)
    end

    it 'redirects to the themes list' do
      theme = create(:theme)
      delete :destroy, id: theme.to_param
      expect(response).to redirect_to([comable, :admin, :themes])
    end
  end

  describe 'GET tree' do
    let!(:theme) { create(:theme) }

    it "renders the 'show_file' template" do
      get :tree, id: theme.to_param
      expect(response).to render_template(:show_file)
    end
  end

  describe 'GET show_file' do
    let!(:theme) { create(:theme) }
    let(:path) { 'path/to/file' }
    let(:fullpath) { theme.dir + path }

    before { allow(File).to receive(:exist?).with(fullpath).and_return(true) }
    before { allow(File).to receive(:read).with(fullpath).and_return('sample code!') }

    it 'assigns the source code as @code' do
      get :show_file, id: theme.to_param, path: path
      expect(assigns(:code)).to be
    end

    it "renders the 'show_file' template" do
      get :show_file, id: theme.to_param, path: path
      expect(response).to render_template(:show_file)
    end
  end

  describe 'PUT update_file' do
    let!(:theme) { create(:theme) }
    let(:path) { 'path/to/file' }

    context 'when success to save the file' do
      it 'calls #save_file method' do
        expect(subject).to receive(:save_file).and_return(true)
        get :update_file, id: theme.to_param, path: path
      end

      it 'redirects to the theme file' do
        allow(subject).to receive(:save_file).and_return(true)
        get :update_file, id: theme.to_param, path: path
        expect(response).to redirect_to(comable.file_admin_theme_path(theme, path: path))
      end
    end

    context 'when fail to save the file' do
      before { allow(subject).to receive(:save_file).and_raise }

      it "re-renders the 'show_file' template" do
        get :update_file, id: theme.to_param, path: path
        expect(response).to render_template(:show_file)
      end

      it 'assigns the alert message as flash.now[:alert]' do
        get :update_file, id: theme.to_param, path: path
        expect(subject.flash.now[:alert]).to be
      end

      it 'assigns the inputed code as @code' do
        code = 'sample code!'
        get :update_file, id: theme.to_param, path: path, code: code
        expect(assigns(:code)).to eq(code)
      end
    end
  end

  describe 'PUT use' do
    let!(:theme) { create(:theme) }
    let!(:store) { create(:store, theme: nil) }

    before { allow(controller).to receive(:current_store).and_return(store) }
    before { request.env['HTTP_REFERER'] = 'where_i_came_from' }

    it 'updates current store to use the requested theme' do
      put :use, id: theme.to_param
      expect(store.theme).to eq(theme)
    end

    it 'redirects to the used theme' do
      put :use, id: theme.to_param
      expect(response).to redirect_to('where_i_came_from')
    end
  end

  describe '#save_file' do
    it 'validates syntax of the liquid code' do
      allow(subject).to receive(:params).and_return(code: <<-CODE)
        {% for product in products %}
          {{ product.name }}
        {% fail before endfor %}
      CODE
      expect { subject.send(:save_file) }.to raise_error(Liquid::SyntaxError)
    end

    it 'save the source code to the theme file' do
      theme = create(:theme)
      code = 'sample code!'
      path = 'path/to/file'
      fullpath = theme.dir + path

      subject.instance_variable_set(:@theme, theme)
      allow(subject).to receive(:params).and_return(path: path, code: code)

      expect(FileUtils).to receive(:mkdir_p).with(File.dirname(fullpath)).and_return(true)
      expect(File).to receive(:exist?).with(fullpath).and_return(false)
      expect(File).to receive(:write).with(fullpath, code).and_return(true)

      subject.send(:save_file)
    end
  end
end
