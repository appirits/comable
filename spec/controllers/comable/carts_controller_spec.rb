require 'spec_helper'

describe Comable::CartsController do
  render_views

  let(:product) { FactoryGirl.create(:product) }
  let(:current_customer) { controller.current_customer }

  before { request }

  context 'ゲストの場合' do
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
    end
  end
end
