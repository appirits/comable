require 'spec_helper'

describe Comable::OrdersController do
  render_views

  let (:product) { FactoryGirl.create(:product) }

  before { add_to_cart }
  before { request }

  context "ゲストの場合" do
    let (:customer) { Customer.new(session) }
    let (:add_to_cart) { customer.add_cart_item(product) }
    let (:order_params) { { order: { family_name: 'foo', first_name: 'bar', comable_order_deliveries_attributes: [ family_name: 'hoge', first_name: 'piyo' ] } } }

    describe "GET 'new'" do
      let (:request) { get :new }
      its (:response) { should be_success }

      it 'カートが空でないこと' do
        expect(customer.cart.count).to be_nonzero
      end
    end

    describe "GET 'orderer'" do
      let (:request) { get :orderer }
      its (:response) { should be_success }
    end

    describe "POST 'orderer'" do
      let (:request) { post :orderer, order_params }
      its (:response) { should redirect_to(:delivery_order) }
    end

    describe "GET 'delivery'" do
      let (:request) { get :delivery }
      its (:response) { should be_success }
    end

    describe "POST 'delivery'" do
      let (:request) { post :delivery, order_params }
      its (:response) { should redirect_to(:confirm_order) }
    end

    describe "GET 'confirm'" do
      let (:request) { get :confirm }
      its (:response) { should be_success }
    end

    describe "POST 'create'" do
      context "正常な手順のリクエストの場合" do
        let (:request) {
          post :orderer, order_params
          post :delivery, order_params
          post :create, order_params
        }
        its (:response) { should be_success }
      end

      context "不正な手順のリクエストの場合" do
        let (:request) { post :create, order_params }
        its (:response) { should redirect_to(:confirm_order) }
      end
    end
  end
end
