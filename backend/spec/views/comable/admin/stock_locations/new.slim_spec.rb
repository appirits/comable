describe 'comable/admin/stock_locations/new' do
  let(:stock_location) { build(:stock_location) }

  before { assign(:stock_location, stock_location) }

  it 'renders new stock_location form' do
    render
    assert_select 'form[action=?][method=?]', comable.admin_stock_locations_path, 'post'
  end
end
