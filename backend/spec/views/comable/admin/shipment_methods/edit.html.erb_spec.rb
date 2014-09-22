describe 'comable/admin/shipment_methods/edit' do
  before(:each) do
    @shipment_method = assign(:shipment_method, FactoryGirl.create(:shipment_method))
  end

  it 'renders the edit shipment_method form' do
    render

    assert_select 'form[action=?][method=?]', comable.admin_shipment_method_path(@shipment_method), 'post' do
    end
  end
end
