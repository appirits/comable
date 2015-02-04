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

  context 'with images' do
    let!(:product) { FactoryGirl.create(:product) }
    let!(:images) { FactoryGirl.create_list(:image, 5, product: product) }

    describe "GET 'index'" do
      before { get :index }

      it { expect(response).to be_success }
    end

    describe "GET 'show'" do
      before { get :show, id: product.id }

      it { expect(response).to be_success }

      it 'display five images' do
        expect(assigns(:product).images.count).to eq(images.count)
      end
    end
  end

  context 'with category' do
    let!(:parent_category) { FactoryGirl.create(:category, name: 'parent_category') }
    let!(:category) { FactoryGirl.create(:category, name: 'category', parent: parent_category) }
    let!(:child_category) { FactoryGirl.create(:category, name: 'child_category', parent: category) }

    let!(:product) { FactoryGirl.create(:product, categories: [child_category]) }

    describe "GET 'index'" do
      before { get :index, category_id: category.id }

      it { expect(response).to be_success }
      it { expect(assigns(:products)).to include(product) }
    end

    describe "GET 'show'" do
      before { get :show, id: product.id }

      it { expect(response).to be_success }
    end
  end

  context 'with pagination' do
    let!(:products) { FactoryGirl.create_list(:product, per_page + 1) }

    let(:per_page) { Comable::Config.products_per_page }

    describe "GET 'index'" do
      context 'page 1' do
        before { get :index, page: 1 }

        it { expect(response).to be_success }

        it 'display many products' do
          expect(assigns(:products).count).to eq(per_page)
        end
      end

      context 'page 2' do
        before { get :index, page: 2 }

        it { expect(response).to be_success }

        it 'display a product' do
          expect(assigns(:products).count).to eq(1)
        end
      end
    end
  end
end
