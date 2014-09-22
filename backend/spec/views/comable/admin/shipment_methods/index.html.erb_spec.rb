describe 'comable/admin/shipment_methods/index' do
  before(:each) do
    assign(:shipment_methods, FactoryGirl.create_list(:shipment_method, 2))
  end

  it "renders a list of shipment_methods" do
    render
  end
end
