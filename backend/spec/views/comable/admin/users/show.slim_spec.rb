describe 'comable/admin/users/show' do
  let!(:user) { create(:user) }

  before { assign(:user, user) }

  it 'renders attributes in user' do
    render
    expect(rendered).to include(user.email)
  end
end
