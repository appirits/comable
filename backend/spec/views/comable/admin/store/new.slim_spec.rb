describe 'comable/admin/store/new' do
  before(:each) do
    assign(:store, Comable::Store.new)
  end

  it 'renders new store form' do
    render

    assert_select 'form[action=?][method=?]', comable.admin_store_path, 'post'
  end
end
