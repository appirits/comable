describe 'comable/admin/pages/edit' do
  let(:page) { create(:page) }

  before { assign(:page, page) }

  it 'renders the edit page form' do
    render
    assert_select 'form[action=?]', comable.admin_page_path(page)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
