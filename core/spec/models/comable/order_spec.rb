describe Comable::Order do
  subject(:order) { FactoryGirl.build(:order) }

  subject { order }

  it { is_expected.to belong_to(:bill_address).class_name(Comable::Address.name).dependent(:destroy) }
  it { is_expected.to belong_to(:ship_address).class_name(Comable::Address.name).dependent(:destroy) }

  describe 'attributes' do
    describe '#save' do
      context 'complete order' do
        let(:item_total_price) { 500 }

        before { allow(subject).to receive(:current_item_total_price) { item_total_price } }
        before { subject.complete }

        its(:completed_at) { should be }
        its(:code) { should match(/^C\d{11}$/) }
        its(:total_price) { should eq(item_total_price) }

        context 'with shipment method' do
          subject(:order) { FactoryGirl.build(:order, shipment_method: shipment_method) }

          let(:shipment_method) { FactoryGirl.create(:shipment_method) }

          its(:shipment_fee) { is_expected.to eq(shipment_method.fee) }
          its(:total_price) { should eq(item_total_price + shipment_method.fee) }
        end

        context 'with customer' do
          subject(:order) { FactoryGirl.build(:order, customer: customer, bill_address: address, ship_address: address) }

          let(:address) { FactoryGirl.create(:address) }

          context 'has addresses used in order' do
            let(:customer) { FactoryGirl.create(:customer, addresses: [address]) }

            it 'has copied address from order to customer' do
              expect(customer.bill_address).to eq(address)
              expect(customer.ship_address).to eq(address)
            end
          end

          context 'has addresses not used in order' do
            let(:customer) { FactoryGirl.create(:customer, :with_addresses) }

            it 'has cloned address from order to customer' do
              expect(customer.bill_address.attributes_without_id).to eq(address.attributes_without_id)
              expect(customer.ship_address.attributes_without_id).to eq(address.attributes_without_id)
            end
          end
        end
      end

      context 'incomplete order' do
        before { subject.save }

        its(:completed_at) { should be_nil }
        its(:code) { should be_nil }

        context 'with customer address' do
          subject(:order) { FactoryGirl.build(:order, customer: customer) }

          let(:customer) { FactoryGirl.create(:customer, :with_addresses) }

          its(:bill_address) { is_expected.to be }
          its(:ship_address) { is_expected.to be }
        end
      end
    end
  end
end
