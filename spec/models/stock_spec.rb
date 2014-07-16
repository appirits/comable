describe Stock do
  it { expect { described_class.new }.to_not raise_error }

  context 'belongs_to' do
    let(:stock) { FactoryGirl.create(:stock, :with_product) }

    describe 'product' do
      subject { stock.product }
      it { should be }
      its(:name) { should be }
    end
  end
end
