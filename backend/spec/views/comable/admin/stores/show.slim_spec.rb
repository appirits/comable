describe 'comable/admin/stores/show' do
  before(:each) do
    @store = assign(:store, FactoryGirl.create(:store))
  end

  it 'renders attributes in <p>' do
    render
  end
end
