describe 'comable/admin/pages/new' do
  let(:page) { build(:page) }

  before { assign(:page, page) }

  it 'renders new page form' do
    render
    assert_select 'form[action=?][method=?]', comable.admin_pages_path, 'post'
  end
end
