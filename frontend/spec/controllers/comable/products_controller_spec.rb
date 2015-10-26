describe Comable::ProductsController do
  render_views

  describe "GET 'index'" do
    it 'assigns all products as @products' do
      product = create(:product)
      get :index
      expect(assigns(:products)).to eq([product])
    end

    pending 'assigns the matched products as @products' do
      create_list(:product, 5)

      name = 'Sample Product #1'
      product = create(:product, name: name)

      get :index, q: name

      expect(assigns(:products)).to eq([product])
    end
  end

  describe "GET 'show'" do
    it 'assigns the requested product as @product' do
      product = create(:product)
      get :show, id: product.to_param
      expect(assigns(:product)).to eq(product)
    end
  end

  context 'SKU商品' do
    let(:product) { create(:product, :sku) }

    describe "GET 'show'" do
      before { get :show, id: product.id }

      it { expect(response).to be_success }
    end
  end

  context 'SKU商品（横軸のみ）' do
    let(:product) { create(:product, :sku_h) }

    describe "GET 'show'" do
      before { get :show, id: product.id }

      it { expect(response).to be_success }
    end
  end

  context 'with images' do
    let!(:product) { create(:product) }
    let!(:images) { create_list(:image, 5, product: product) }

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
    let!(:parent_category) { create(:category, name: 'parent_category') }
    let!(:category) { create(:category, name: 'category', parent: parent_category) }
    let!(:child_category) { create(:category, name: 'child_category', parent: category) }

    let!(:product) { create(:product, categories: [child_category]) }

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
    let!(:products) { create_list(:product, per_page + 1) }

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
