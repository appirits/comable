describe Comable::UsersController do
  render_views

  before { request }

  context 'Guest' do
    describe "GET 'index'" do
      let(:request) { get :show }
      its(:response) { is_expected.to redirect_to(controller.comable.new_user_session_path) }
    end
  end
end
