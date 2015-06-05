describe Comable::ApplicationHelper do
  subject { helper }

  describe '#liquidize' do
    it 'returns liquidized string' do
      string = 'John'
      expect(subject.liquidize('Name: {{ name }}', name: string)).to include(string)
    end

    it 'allows the specified method of a model to liquidize' do
      order = build(:order, total_price: 100)
      expect(subject.liquidize('Total price: {{ order.total_price }}', order: order)).to include(order.total_price.to_s)
    end

    it 'denies the specified method of a model to liquidize' do
      order = build(:order, email: 'john@example.com')
      expect(subject.liquidize('email: {{ order.email }}', order: order)).not_to include(order.email)
    end
  end

  context 'メタタグ' do
    let!(:page) { FactoryGirl.create(:page) }
    describe 'インスタンス変数があってメタタグのメソッドがある場合' do
      before do
        allow(subject).to receive(:current_resource).and_return(page)
        allow(subject).to receive(:current_resource_meta_method_respond_to?).and_return(true)
      end

      context 'インスタンス変数のメタタグを表示する' do
        it '#current_meta_description' do
          expect(subject.current_meta_description).to eq(page.meta_description)
        end

        it '#current_meta_keywords' do
          expect(subject.current_meta_keywords).to eq(page.meta_keywords)
        end
      end
    end

    describe 'インスタンス変数があってメタタグのメソッドがない場合' do
      let!(:store) { FactoryGirl.create(:store, meta_description: 'store_meta_description', meta_keywords: 'store_keywords') }
      before do
        allow(subject).to receive(:current_store).and_return(store)
        allow(subject).to receive(:current_resource).and_return(page)
        allow(subject).to receive(:current_resource_meta_method_respond_to?).and_return(false)
      end

      context 'ストアのメタタグを表示する' do
        it '#current_meta_description' do
          expect(subject.current_meta_description).to eq(store.meta_description)
        end

        it '#current_meta_keywords' do
          expect(subject.current_meta_keywords).to eq(store.meta_keywords)
        end
      end
    end

    describe 'インスタンス変数がない場合' do
      let!(:store) { FactoryGirl.create(:store, meta_description: 'store_meta_description', meta_keywords: 'store_keywords') }
      before do
        allow(subject).to receive(:current_store).and_return(store)
        allow(subject).to receive(:current_resource)
      end

      context 'ストアのメタタグを表示する' do
        it '#current_meta_description' do
          expect(subject.current_meta_description).to eq(store.meta_description)
        end

        it '#current_meta_keywords' do
          expect(subject.current_meta_keywords).to eq(store.meta_keywords)
        end
      end
    end
  end
end
