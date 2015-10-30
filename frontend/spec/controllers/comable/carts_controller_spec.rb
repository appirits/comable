describe Comable::CartsController do
  render_views

  let(:current_comable_user) { controller.current_comable_user }

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }
  before { controller.request.env['HTTP_REFERER'] = controller.comable.product_path(product) }
  before { request }

  describe 'inherit cart items' do
    let(:product) { create(:product, :with_stock) }
    let(:user) { create(:user) }

    subject { current_comable_user }

    context 'when sign in' do
      let(:request) do
        post :add, product_id: product.id
        sign_in :user, user
        get :show
      end

      it 'is signed in user' do
        expect(subject.signed_in?).to be true
      end

      it 'inherit cart items' do
        expect(subject.cart.count).to eq(1)
      end
    end

    context 'when sign out' do
      let(:request) do
        sign_in user
        post :add, product_id: product.id
        sign_out user
      end

      it 'is guest' do
        expect(subject.signed_in?).to be false
      end

      it 'do not inherit cart items' do
        expect(subject.cart.count).to eq(0)
      end
    end

    context 'when sign in and already existed a cart' do
      let(:products) { create_list(:product, 2, :with_stock) }
      let(:product) { products.first }

      let(:request) do
        sign_in user
        post :add, product_id: products.first.id

        sign_out user
        post :add, product_id: products.last.id

        sign_in user
        get :show
      end

      it 'is signed in user' do
        expect(subject.signed_in?).to be true
      end

      it 'inherit cart items' do
        expect(subject.cart.count).to eq(2)
      end
    end
  end

  context 'ゲストの場合' do
    context '通常商品' do
      let(:product) { create(:product, :with_stock) }

      describe "GET 'show'" do
        let(:request) { get :show }
        its(:response) { should be_success }

        it 'カートに商品が投入されていないこと' do
          expect(current_comable_user.cart.count).to be_zero
        end
      end

      describe "POST 'add'" do
        let(:request) { post :add, product_id: product.id }

        its(:response) { is_expected.to redirect_to(controller.comable.cart_path) }

        it 'カートに１つの商品が投入されていること' do
          expect(current_comable_user.cart.count).to eq(1)
        end

        it 'flashにメッセージが格納されていること' do
          expect(flash[:notice]).to eq Comable.t('carts.added')
        end

        context 'when product unstocked' do
          let(:stock) { create(:stock, :unstocked) }
          let(:product) { create(:product, stocks: [stock]) }

          its(:response) { is_expected.to render_template(:show) }

          it 'shows the error' do
            expect(flash.now[:alert]).to eq Comable.t('carts.invalid')
          end
        end
      end
    end

    context 'SKU商品' do
      let(:product) { create(:product, :sku) }

      describe "GET 'show'" do
        let(:request) { get :show }
        its(:response) { should be_success }

        it 'カートに商品が投入されていないこと' do
          expect(current_comable_user.cart.count).to be_zero
        end
      end

      describe "POST 'add'" do
        let(:request) { post :add, product_id: product.id, stock_id: product.stocks.first.id }

        its(:response) { is_expected.to redirect_to(controller.comable.cart_path) }

        it 'カートに１つの商品が投入されていること' do
          expect(current_comable_user.cart.count).to eq(1)
        end

        it 'flashにメッセージが格納されていること' do
          expect(flash[:notice]).to eq Comable.t('carts.added')
        end

        context 'SKUが選択されていない場合' do
          let(:request) { post :add, product_id: product.id }

          it 'カートに商品が投入されていないこと' do
            expect(current_comable_user.cart.count).to eq(0)
          end

          it 'flashにメッセージが格納されていること' do
            expect(flash.now[:alert]).to eq Comable.t('errors.messages.products_not_found')
          end
        end
      end
    end
  end

  describe 'PUT update' do
    let(:product) { create(:product, :with_stock) }

    describe 'with valid params' do
      it 'updates the requested cart item' do
        current_comable_user.add_cart_item(product)
        cart_item = current_comable_user.cart.first
        expect { put :update, product_id: product.to_param, quantity: cart_item.quantity + 1 }.to change { cart_item.reload.quantity }.by(1)
      end

      it 'redirects to the cart' do
        current_comable_user.add_cart_item(product)
        cart_item = current_comable_user.cart.first
        put :update, product_id: product.to_param, quantity: cart_item.quantity + 1
        expect(response).to redirect_to([controller.comable, :cart])
      end
    end

    describe 'with invalid params' do
      it "re-renders the 'show' template" do
        put :update, product_id: product.to_param
        expect(response).to render_template(:show)
      end

      it 'assigns the message as flash.now[:alert]' do
        put :update, product_id: product.to_param
        expect(flash.now[:alert]).to eq(Comable.t('carts.invalid'))
      end
    end
  end

  describe 'DELETE destroy' do
    let(:product) { create(:product, :with_stock) }

    describe 'with valid params' do
      it 'destroys the requested cart_item' do
        current_comable_user.add_cart_item(product)
        expect { delete :destroy, product_id: product.to_param }.to change(Comable::OrderItem, :count).by(-1)
      end

      it 'redirects to the cart' do
        current_comable_user.add_cart_item(product)
        delete :destroy, product_id: product.to_param
        expect(response).to redirect_to([controller.comable, :cart])
      end
    end

    describe 'with invalid params' do
      it "re-renders the 'show' template" do
        delete :destroy, product_id: product.to_param
        expect(response).to render_template(:show)
      end

      it 'assigns the message as flash.now[:alert]' do
        delete :destroy, product_id: product.to_param
        expect(flash.now[:alert]).to eq(Comable.t('carts.invalid'))
      end
    end
  end

  describe '#resets_shipments' do
    let(:product) { create(:product, :with_stock) }
    let(:order) { create(:order, :completed) }
    let(:shipments) { build_list(:shipment, 2) }

    before do
      order.shipments = shipments
      allow(controller).to receive(:current_order).and_return(order)
    end

    it 'destroys all shipments' do
      expect { post :add, product_id: product.id }.to change(order.shipments.reload, :count).to(0)
    end

    it 'changes the order state to "cart"' do
      post :add, product_id: product.id
      expect(order).to be_cart
    end
  end

  private

  # TODO: Move to the support directory.
  # HACK: for calling Comable::User#after_set_user method form 'after_set_user' callback of warden.
  def sign_in(*_)
    super.tap { controller.current_comable_user.after_set_user }
  end
end
