describe Comable::ProductsController do
  render_views

  context '通常商品' do
    let!(:product) { FactoryGirl.create(:product) }

    describe "GET 'index'" do
      before { get :index }

      it { expect(response).to be_success }
    end

    describe "GET 'show'" do
      before { get :show, id: product.id }

      it { expect(response).to be_success }
    end
  end

  context 'SKU商品' do
    let(:product) { FactoryGirl.create(:product, :sku) }

    describe "GET 'show'" do
      before { get :show, id: product.id }

      it { expect(response).to be_success }
    end
  end

  context 'SKU商品（横軸のみ）' do
    let(:product) { FactoryGirl.create(:product, :sku_h) }

    describe "GET 'show'" do
      before { get :show, id: product.id }

      it { expect(response).to be_success }
    end
  end
end
