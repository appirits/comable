describe 'comable/admin/navigations/edit' do
  let(:navigation) { create(:navigation, navigation_items: [create(:navigation_item)]) }

  before { assign(:navigation, navigation) }

  it 'renders the edit navigation form' do
    render
    assert_select 'form[action=?]', comable.admin_navigation_path(navigation)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
