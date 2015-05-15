describe 'comable/admin/users/edit' do
  helper Comable::ApplicationHelper

  let(:user) { create(:user) }

  before { assign(:user, user) }

  it 'renders the edit user form' do
    render
    assert_select 'form[action=?]', comable.admin_user_path(user)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
