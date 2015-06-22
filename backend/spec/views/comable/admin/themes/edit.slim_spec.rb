describe 'comable/admin/themes/edit' do
  helper Comable::ApplicationHelper

  let(:theme) { create(:theme) }

  before { assign(:theme, theme) }

  it 'renders the edit theme form' do
    render
    assert_select 'form[action=?]', comable.admin_theme_path(theme)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
