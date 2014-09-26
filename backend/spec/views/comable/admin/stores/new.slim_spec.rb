describe 'comable/admin/stores/new' do
  before(:each) do
    assign(:store, Comable::Store.new)
  end

  it 'renders new store form' do
    render

    assert_select 'form[action=?][method=?]', comable.admin_stores_path, 'post'
  end
end
