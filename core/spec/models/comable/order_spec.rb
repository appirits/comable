describe Comable::Order do
  it { expect { described_class.new }.to_not raise_error }

  let(:title) { 'sample product' }
  let(:order) { FactoryGirl.build(:order) }

  subject { order }

  describe 'attributes' do
    describe '#save' do
      context 'complete order' do
        before { subject.complete }
        its(:completed_at) { should be }
        its(:code) { should match(/^C\d{11}$/) }

        context 'with shipment method' do
          let(:shipment_method) { FactoryGirl.create(:shipment_method) }
          let(:order) { FactoryGirl.build(:order, shipment_method: shipment_method) }

          its(:shipment_fee) { is_expected.to eq(shipment_method.fee) }
        end
      end

      context 'incomplete order' do
        before { subject.save }
        its(:completed_at) { should be_nil }
        its(:code) { should be_nil }
      end
    end
  end
end
