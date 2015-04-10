describe Comable::CartsController do
  render_views

  let(:current_comable_user) { controller.current_comable_user }

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }
  before { controller.request.env['HTTP_REFERER'] = controller.comable.product_path(product) }
  before { request }

  describe 'inherit cart items' do
    let(:product) { FactoryGirl.create(:product, :with_stock) }
    let(:user) { FactoryGirl.create(:user) }

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
      let(:products) { FactoryGirl.create_list(:product, 2, :with_stock) }
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
      let(:product) { FactoryGirl.create(:product, :with_stock) }

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
          let(:stock) { FactoryGirl.create(:stock, :unstocked) }
          let(:product) { FactoryGirl.create(:product, stocks: [stock]) }

          its(:response) { is_expected.to render_template(:show) }

          it 'shows the error' do
            expect(flash.now[:alert]).to eq Comable.t('carts.invalid')
          end
        end
      end
    end

    context 'SKU商品' do
      let(:product) { FactoryGirl.create(:product, :sku) }

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

  private

  # TODO: Move to the support directory.
  # HACK: for calling Comable::User#after_set_user method form 'after_set_user' callback of warden.
  def sign_in(*_)
    super.tap { controller.current_comable_user.after_set_user }
  end
end
