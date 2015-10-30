describe 'comable/admin/stock_locations/edit' do
  let(:stock_location) { create(:stock_location) }

  before { assign(:stock_location, stock_location) }

  it 'renders the edit stock_location form' do
    render
    assert_select 'form[action=?]', comable.admin_stock_location_path(stock_location)
    assert_select 'input[name=_method][value=?]', 'patch'
  end
end
