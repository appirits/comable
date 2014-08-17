describe Comable::OrderDetail do
  it { expect { described_class.new }.to_not raise_error }

  # 仕様変更につきテスト不要
  xdescribe 'after_create' do
    let(:title) { 'sample product' }
    let(:product) { FactoryGirl.create(:product) }
    let(:stock) { FactoryGirl.create(:stock, product: product, quantity: 100) }
    let(:order_detail) { FactoryGirl.build(:order_detail, quantity: 10, stock: stock) }

    subject { order_detail }

    describe '#save' do
      before { subject.save }

      it '注文商品数が正しいこと' do
        expect(subject.quantity).to eq(10)
      end

      it '注文数分だけ在庫が減算されていること' do
        expect(subject.stock.quantity).to eq(90)
      end
    end
  end
end
