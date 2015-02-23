describe 'comable/admin/stocks/edit' do
  let(:product) { FactoryGirl.create(:product) }
  let(:stock) { FactoryGirl.create(:stock, product: product) }

  before { assign(:product, product) }
  before { assign(:stock, stock) }

  it 'renders the edit stock form' do
    render
    assert_select 'form[action=?]', comable.admin_stock_path(stock)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
