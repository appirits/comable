describe 'comable/admin/users/index' do
  let!(:users) { create_list(:user, 2) }

  let(:q) { Comable::User.ransack }

  before { assign(:q, q) }
  before { assign(:users, q.result.page(1)) }

  it 'renders a list of users' do
    render
    expect(rendered).to include(*users.map(&:email))
  end
end
