describe Comable::CartsController do
  render_views

  let(:current_customer) { controller.current_customer }

  before { controller.request.env['HTTP_REFERER'] = controller.comable.product_path(product) }
  before { request }

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
end
