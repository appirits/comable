describe Comable::Admin::PaymentMethodsController do
  sign_in_admin

  let(:comable) { controller.comable }

  let(:valid_attributes) { attributes_for(:payment_method) }
  let(:invalid_attributes) { valid_attributes.merge(name: 'x' * 1024) }

  describe 'GET index' do
    it 'assigns all payment_methods as @payment_methods' do
      payment_method = create(:payment_method)
      get :index
      expect(assigns(:payment_methods)).to eq([payment_method])
    end
  end

  describe 'GET show' do
    it 'assigns the requested payment_method as @payment_method' do
      payment_method = create(:payment_method)
      get :show, id: payment_method.to_param
      expect(assigns(:payment_method)).to eq(payment_method)
    end
  end

  describe 'GET new' do
    it 'assigns a new payment_method as @payment_method' do
      get :new
      expect(assigns(:payment_method)).to be_a_new(Comable::PaymentMethod)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested payment_method as @payment_method' do
      payment_method = create(:payment_method)
      get :edit, id: payment_method.to_param
      expect(assigns(:payment_method)).to eq(payment_method)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Comable::PaymentMethod' do
        expect { post :create, payment_method: valid_attributes }.to change(Comable::PaymentMethod, :count).by(1)
      end

      it 'assigns a newly created payment_method as @payment_method' do
        post :create, payment_method: valid_attributes
        expect(assigns(:payment_method)).to be_a(Comable::PaymentMethod)
        expect(assigns(:payment_method)).to be_persisted
      end

      it 'redirects to the created payment_method' do
        post :create, payment_method: valid_attributes
        expect(response).to redirect_to([comable, :admin, Comable::PaymentMethod.last])
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved payment_method as @payment_method' do
        post :create, payment_method: invalid_attributes
        expect(assigns(:payment_method)).to be_a_new(Comable::PaymentMethod)
      end

      it "re-renders the 'new' template" do
        post :create, payment_method: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    let!(:payment_method) { create(:payment_method) }

    describe 'with valid params' do
      let(:new_attributes) { { name: "NEW: #{payment_method.name}" } }

      it 'updates the requested payment_method' do
        put :update, id: payment_method.to_param, payment_method: new_attributes
        payment_method.reload
        expect(payment_method).to have_attributes(new_attributes)
      end

      it 'assigns the requested payment_method as @payment_method' do
        put :update, id: payment_method.to_param, payment_method: valid_attributes
        expect(assigns(:payment_method)).to eq(payment_method)
      end

      it 'redirects to the payment_method' do
        put :update, id: payment_method.to_param, payment_method: valid_attributes
        expect(response).to redirect_to([comable, :admin, payment_method])
      end
    end

    describe 'with invalid params' do
      it 'assigns the payment_method as @payment_method' do
        put :update, id: payment_method.to_param, payment_method: invalid_attributes
        expect(assigns(:payment_method)).to eq(payment_method)
      end

      it "re-renders the 'edit' template" do
        put :update, id: payment_method.to_param, payment_method: invalid_attributes
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested payment_method' do
      payment_method = create(:payment_method)
      expect { delete :destroy, id: payment_method.to_param }.to change(Comable::PaymentMethod, :count).by(-1)
    end

    it 'redirects to the payment_methods list' do
      payment_method = create(:payment_method)
      delete :destroy, id: payment_method.to_param
      expect(response).to redirect_to([comable, :admin, :payment_methods])
    end
  end
end
