describe Comable::Admin::DashboardController do

  let(:comable) { controller.comable }

  describe 'GET show' do
    context 'when the user is not signed-in' do
      it 'should be not success' do
        get :show
        expect(response).not_to be_success
      end
    end

    context 'when the role of the user is customer' do
      sign_in_admin(role: :customer)

      it 'should be not success' do
        get :show
        expect(response).not_to be_success
      end
    end

    context 'when the role of the user is reporter' do
      sign_in_admin(role: :reporter)

      it 'should be success' do
        get :show
        expect(response).to be_success
      end
    end

    context 'when the role of the user is reporter' do
      sign_in_admin

      it 'should be success' do
        get :show
        expect(response).to be_success
      end
    end
  end
end
