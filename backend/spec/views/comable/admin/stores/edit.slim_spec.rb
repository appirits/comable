describe 'comable/admin/stores/edit' do
  before(:each) do
    @store = assign(:store, FactoryGirl.create(:store))
  end

  it 'renders the edit store form' do
    render

    assert_select 'form[action=?][method=?]', comable.admin_store_path(@store), 'post'
  end
end
