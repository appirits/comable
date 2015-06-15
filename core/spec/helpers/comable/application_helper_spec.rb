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
    before do
      allow(subject).to receive(:current_resource).and_return(page)
    end

    describe 'インスタンス変数があってメタタグのメソッドがある場合' do
      context 'インスタンス変数のメタタグを表示する' do
        it '#current_meta_description' do
          expect(subject.current_meta_description).to eq(page.meta_description)
        end

        it '#current_meta_keywords' do
          expect(subject.current_meta_keywords).to eq(page.meta_keywords)
        end
      end

      context '#current_page_title' do
        it 'インスタンス変数のpage_titleとストアのnameを結合したものであること' do
          expect(subject.current_page_title).to eq([page.page_title, store.name].compact.join(' - '))
        end
      end
    end

    describe 'インスタンス変数があってメタタグのメソッドがない場合' do
      before do
        allow(subject).to receive(:current_store).and_return(store)
        allow(subject).to receive_message_chain(:current_resource, :respond_to?).and_return(false)
      end

      context 'ストアのメタタグを表示する' do
        it '#current_meta_description' do
          expect(subject.current_meta_description).to eq(store.meta_description)
        end

        it '#current_meta_keywords' do
          expect(subject.current_meta_keywords).to eq(store.meta_keywords)
        end

        it '#current_page_title' do
          expect(subject.current_page_title).to eq(store.name)
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

        it '#current_page_title' do
          expect(subject.current_page_title).to eq(store.name)
        end
      end
    end
  end
end
