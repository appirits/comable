describe 'comable/admin/shipment_methods/show' do
  before(:each) do
    @shipment_method = assign(:shipment_method, FactoryGirl.create(:shipment_method))
  end

  it 'renders attributes in <p>' do
    render
  end
end
