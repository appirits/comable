require 'spec_helper'

describe Comable::ProductsController do
  render_views

  before { request }

  context '通常商品' do
    let(:product) { FactoryGirl.create(:product) }

    describe "GET 'index'" do
      let(:request) { get :index }
      its(:response) { should be_success }
    end

    describe "GET 'show'" do
      let(:request) { get :show, id: product.id }
      its(:response) { should be_success }
    end
  end

  context 'SKU商品' do
    let(:product) { FactoryGirl.create(:product, :sku) }

    describe "GET 'show'" do
      let(:request) { get :show, id: product.id }
      its(:response) { should be_success }
    end
  end

  context 'SKU商品（横軸のみ）' do
    let(:product) { FactoryGirl.create(:product, :sku_h) }

    describe "GET 'show'" do
      let(:request) { get :show, id: product.id }
      its(:response) { should be_success }
    end
  end
end
