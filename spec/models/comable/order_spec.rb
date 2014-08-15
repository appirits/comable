describe Comable::Order do
  it { expect { described_class.new }.to_not raise_error }

  let(:title) { 'sample product' }
  let(:order) { FactoryGirl.build(:order) }

  describe 'attributes' do
    subject { order }

    describe '#save' do
      context 'complete order' do
        before { order.complete }
        its(:completed_at) { should be }
        its(:code) { should match(/^C\d{11}$/) }
      end

      context 'incomplete order' do
        before { subject.save }
        its(:completed_at) { should be_nil }
        its(:code) { should be_nil }
      end
    end
  end
end
