describe Comable::CartsController do
  render_views

  let(:current_customer) { controller.current_customer }

  before { @request.env['devise.mapping'] = Devise.mappings[:customer] }
  before { controller.request.env['HTTP_REFERER'] = controller.comable.product_path(product) }
  before { request }

  context 'when sign-in after it has created a cart' do
    let(:product) { FactoryGirl.create(:product, :with_stock) }
    let(:customer) { FactoryGirl.create(:customer) }

    let(:request) do
      post :add, product_id: product.id
      sign_in :customer, customer
      get :show
    end

    subject { current_customer }

    it 'is signed-in customer' do
      expect(subject.signed_in?).to be true
    end

    it 'inherit cart items' do
      expect(subject.cart.count).to eq(1)
    end
  end

  context 'when sign-out after it has created a cart' do
    let(:product) { FactoryGirl.create(:product, :with_stock) }
    let(:customer) { FactoryGirl.create(:customer) }

    let(:request) do
      sign_in customer
      post :add, product_id: product.id
      sign_out customer
    end

    subject { current_customer }

    it 'is guest' do
      expect(subject.signed_in?).to be false
    end

    it 'do not inherit cart items' do
      expect(subject.cart.count).to eq(0)
    end
  end

  context 'when sign-in after it has added cart items' do
    let(:products) { FactoryGirl.create_list(:product, 2, :with_stock, :many) }
    let(:product) { products.first }
    let(:customer) { FactoryGirl.create(:customer) }

    let(:request) do
      sign_in customer
      post :add, product_id: products.first.id

      sign_out customer
      post :add, product_id: products.last.id

      sign_in customer

      get :show
    end

    subject { current_customer }

    it 'is signed-in customer' do
      expect(subject.signed_in?).to be true
    end

    it 'inherit cart items' do
      expect(subject.cart.count).to eq(2)
    end
  end

  context 'ゲストの場合' do
    context '通常商品' do
      let(:product) { FactoryGirl.create(:product, :with_stock) }

      describe "GET 'show'" do
        let(:request) { get :show }
        its(:response) { should be_success }

        it 'カートに商品が投入されていないこと' do
          expect(current_customer.cart.count).to be_zero
        end
      end

      describe "POST 'add'" do
        let(:request) { post :add, product_id: product.id }
        its(:response) { should redirect_to(:cart) }

        it 'カートに１つの商品が投入されていること' do
          expect(current_customer.cart.count).to eq(1)
        end

        it 'flashにメッセージが格納されていること' do
          expect(flash[:notice]).to eq I18n.t('comable.carts.add_product')
        end

        context 'when no stock' do
          let(:stock) { FactoryGirl.create(:stock, :soldout) }
          let(:product) { FactoryGirl.create(:product, stocks: [stock]) }

          its(:response) { should redirect_to(:cart) }

          it 'shows the error' do
            expect(flash[:alert]).to eq I18n.t('comable.errors.messages.products_soldout')
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
          expect(current_customer.cart.count).to be_zero
        end
      end

      describe "POST 'add'" do
        let(:request) { post :add, product_id: product.id, stock_id: product.stocks.first.id }
        its(:response) { should redirect_to(:cart) }

        it 'カートに１つの商品が投入されていること' do
          expect(current_customer.cart.count).to eq(1)
        end

        it 'flashにメッセージが格納されていること' do
          expect(flash[:notice]).to eq I18n.t('comable.carts.add_product')
        end

        context 'SKUが選択されていない場合' do
          let(:request) { post :add, product_id: product.id }

          it 'カートに商品が投入されていないこと' do
            expect(current_customer.cart.count).to eq(0)
          end

          it 'flashにメッセージが格納されていること' do
            expect(flash[:alert]).to eq I18n.t('comable.errors.messages.products_not_found')
          end
        end
      end
    end
  end

  private

  # TODO: Move to the support directory.
  # HACK: for calling Comable::Customer#inherit_cart_items method.
  def sign_in(*_)
    super.tap { controller.current_customer.update_attributes(current_sign_in_at: Time.now) }
  end
end
