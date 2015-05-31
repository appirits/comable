describe Comable::HomeController do
  describe 'GET show' do
    it 'assigns the products as @products' do
      product = create(:product)
      get :show
      expect(assigns(:products)).to include(product)
    end
  end
end
