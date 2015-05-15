describe Comable::Admin::CategoriesController do
  sign_in_admin

  let(:comable) { controller.comable }

  describe 'GET index' do
    it 'assigns all categories as @categories' do
      category = create(:category)
      get :index
      expect(assigns(:categories)).to eq([category])
    end
  end

  # TODO: Add tests for 'create'
end
