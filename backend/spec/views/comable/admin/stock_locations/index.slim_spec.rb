describe 'comable/admin/stock_locations/index' do
  let!(:stock_locations) { create_list(:stock_location, 2) }

  before { assign(:stock_locations, Comable::StockLocation.all) }

  it 'renders a list of stock_locations' do
    render
    expect(rendered).to include(*stock_locations.map(&:name))
  end
end
