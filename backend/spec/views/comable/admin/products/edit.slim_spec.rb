describe 'comable/admin/products/edit' do
  let(:product) { FactoryGirl.create(:product) }

  before { assign(:product, product) }

  it 'renders the edit product form' do
    render
    assert_select 'form[action=?]', comable.admin_product_path(product)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
