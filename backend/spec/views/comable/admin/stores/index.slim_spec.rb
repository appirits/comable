describe 'comable/admin/stores/index' do
  before(:each) do
    assign(:stores, FactoryGirl.create_list(:store, 2))
  end

  it 'renders a list of stores' do
    render
  end
end
