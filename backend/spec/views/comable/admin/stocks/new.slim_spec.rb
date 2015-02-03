describe 'comable/admin/stocks/new' do
  let(:product) { FactoryGirl.create(:product) }
  let(:stock) { FactoryGirl.build(:stock, product: product) }

  before { assign(:product, product) }
  before { assign(:stock, stock) }

  it 'renders new stock form' do
    render
    assert_select 'form[action=?][method=?]', comable.admin_product_stocks_path(product), 'post'
  end
end
