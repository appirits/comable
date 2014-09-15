describe Comable::Admin::ProductsController do
  # This should return the minimal set of attributes required to create a valid
  # ServiceUser::ShopAmazon. As you add validations to ServiceUser::ShopAmazon, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Comable::Admin::ProductsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET index' do
    it 'assigns all products as @products' do
      product = FactoryGirl.create(:product)
      get :index, {}, valid_session
      expect(assigns(:products)).to eq([product])
    end
  end
end
