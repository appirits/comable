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
    let!(:store) do
      FactoryGirl.create(:store, name: 'store_name', meta_description: 'store_meta_description', meta_keywords: 'store_keywords')
    end
    let(:page_mata_tags_params) do
      {
        'title' => page.page_title,
        'description' => page.meta_description,
        'keywords' => page.meta_keywords
      }
    end

    describe 'インスタンス変数があってメタタグのメソッドがある場合' do
      context 'インスタンス変数のメタタグも表示する' do
        it '#set_current_meta_tags' do
          allow(subject).to receive(:current_resource).and_return(page)
          allow(subject).to receive(:current_store).and_return(store)
          expect(subject.set_current_meta_tags).to eq(page_mata_tags_params)
        end
      end
    end

    describe 'インスタンス変数があってメタタグのメソッドがない場合' do
      context 'ストアのメタタグを表示する' do
        it '#set_current_meta_tags' do
          allow(subject).to receive_message_chain(:current_resource, :respond_to?).and_return(false)
          expect(subject.set_current_meta_tags).to eq(nil)
        end
      end
    end

    describe 'インスタンス変数がない場合' do
      context 'ストアのメタタグを表示する' do
        it '#set_current_meta_tags' do
          allow(subject).to receive(:current_store).and_return(store)
          allow(subject).to receive(:current_resource)
          expect(subject.set_current_meta_tags).to eq(nil)
        end
      end
    end
  end
end
