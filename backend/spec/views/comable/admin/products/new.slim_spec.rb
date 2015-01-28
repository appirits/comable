describe 'comable/admin/products/new' do
  let(:product) { FactoryGirl.build(:product) }

  before { assign(:product, product) }

  it 'renders new product form' do
    render
    assert_select 'form[action=?][method=?]', comable.admin_products_path, 'post'
  end
end
