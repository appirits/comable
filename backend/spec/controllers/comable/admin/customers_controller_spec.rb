describe Comable::Admin::CustomersController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { FactoryGirl.attributes_for(:customer) }
  let(:invalid_attributes) { valid_attributes.merge(email: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all customers as @customers' do
      customer = FactoryGirl.create(:customer)
      get :index
      expect(assigns(:customers)).to include(customer)
    end
  end

  describe 'GET show' do
    it 'assigns the requested customer as @customer' do
      customer = FactoryGirl.create(:customer)
      get :show, id: customer.to_param
      expect(assigns(:customer)).to eq(customer)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested customer as @customer' do
      customer = FactoryGirl.create(:customer)
      get :edit, id: customer.to_param
      expect(assigns(:customer)).to eq(customer)
    end
  end

  describe 'PUT update' do
    let!(:customer) { FactoryGirl.create(:customer) }

    describe 'with valid params' do
      let(:new_attributes) { { email: "new_#{customer.email}" } }

      it 'updates the requested customer' do
        put :update, id: customer.to_param, customer: new_attributes
        customer.reload
        expect(customer).to have_attributes(new_attributes)
      end

      it 'assigns the requested customer as @customer' do
        put :update, id: customer.to_param, customer: valid_attributes
        expect(assigns(:customer)).to eq(customer)
      end

      it 'redirects to the customer' do
        put :update, id: customer.to_param, customer: valid_attributes
        expect(response).to redirect_to([comable, :admin, customer])
      end
    end

    describe 'with invalid params' do
      it 'assigns the customer as @customer' do
        put :update, id: customer.to_param, customer: invalid_attributes
        expect(assigns(:customer)).to eq(customer)
      end

      it "re-renders the 'edit' template" do
        put :update, id: customer.to_param, customer: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end
end
