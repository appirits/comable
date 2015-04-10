describe Comable::Order do
  subject(:order) { FactoryGirl.build(:order) }

  subject { order }

  it { is_expected.to belong_to(:bill_address).class_name(Comable::Address.name).dependent(:destroy) }
  it { is_expected.to belong_to(:ship_address).class_name(Comable::Address.name).dependent(:destroy) }

  describe 'validations' do
    describe 'for order details' do
      let!(:order_detail) { FactoryGirl.create(:order_detail, stock: stock, order: order) }

      context 'when out of stock' do
        let(:stock) { FactoryGirl.create(:stock, :stocked, :with_product) }

        it 'has errors' do
          stock.update_attributes(quantity: 0)
          order.complete
          expect(order.errors['order_details.quantity'].any?).to be
        end
      end
    end
  end

  describe 'attributes' do
    describe '#save' do
      context 'complete order' do
        let!(:order_detail) { FactoryGirl.create(:order_detail, order: order, quantity: 10) }

        let(:stock) { order_detail.stock }
        let(:product) { stock.product }
        let(:item_total_price) { product.price * order_detail.quantity }

        before { subject.complete }
        before { subject.reload }

        its(:completed_at) { should be }
        its(:code) { should match(/^C\d{11}$/) }
        its(:total_price) { should eq(item_total_price) }

        it 'has been subtracted stock' do
          expect { stock.reload }.to change { stock.quantity }.from(order_detail.quantity).to(0)
        end

        context 'with shipment method' do
          subject(:order) { FactoryGirl.build(:order, shipment_method: shipment_method) }

          let(:shipment_method) { FactoryGirl.create(:shipment_method) }

          its(:shipment_fee) { is_expected.to eq(shipment_method.fee) }
          its(:total_price) { should eq(item_total_price + shipment_method.fee) }
        end

        context 'with user' do
          subject(:order) { FactoryGirl.build(:order, user: user, bill_address: address, ship_address: address) }

          let(:address) { FactoryGirl.create(:address) }

          context 'has addresses used in order' do
            let(:user) { FactoryGirl.create(:user, addresses: [address]) }

            it 'has copied address from order to user' do
              user.reload
              expect(user.bill_address).to eq(address)
              expect(user.ship_address).to eq(address)
            end
          end

          context 'has addresses not used in order' do
            let(:user) { FactoryGirl.create(:user, :with_addresses) }

            it 'has cloned address from order to user' do
              user.reload
              expect(user.bill_address.attributes_without_id).to eq(address.attributes_without_id)
              expect(user.ship_address.attributes_without_id).to eq(address.attributes_without_id)
            end
          end
        end
      end

      context 'incomplete order' do
        before { subject.save }
        before { subject.reload }

        its(:completed_at) { should be_nil }
        its(:code) { should be_nil }

        context 'with user address' do
          subject(:order) { FactoryGirl.build(:order, user: user) }

          let(:user) { FactoryGirl.create(:user, :with_addresses) }

          its(:bill_address) { is_expected.to be }
          its(:ship_address) { is_expected.to be }
        end
      end
    end
  end
end
