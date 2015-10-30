module Comable
  module Inventory
    describe Unit do
      let(:variant) { build(:variant) }

      subject { described_class.new(variant) }

      it { is_expected.to have_attr_accessor(:variant) }

      describe '#initialize' do
        it 'sets the variant as @variant' do
          unit = described_class.new(variant)
          expect(unit.instance_variable_get(:@variant)).to eq(variant)
        end
      end

      describe '#to_shipment_item' do
        it 'returns an instance of ShipmentItem' do
          stock = build(:stock)
          allow(subject).to receive(:find_stock_item).and_return(stock)

          shipment = build(:shipment)
          shipment_item = subject.to_shipment_item(shipment)

          expect(shipment_item).to be_instance_of(ShipmentItem)
        end

        it 'has the stock item' do
          stock = build(:stock)
          allow(subject).to receive(:find_stock_item).and_return(stock)

          shipment = build(:shipment)
          shipment_item = subject.to_shipment_item(shipment)

          expect(shipment_item.stock).to eq(stock)
        end
      end

      describe '#find_stock_item' do
        it 'returns the stock item' do
          product = build(:product)
          stock = build(:stock)
          variant.update!(product: product, stocks: [stock])

          shipment = build(:shipment, stock_location: stock.stock_location)

          expect(subject.send(:find_stock_item, shipment)).to eq(stock)
        end
      end
    end
  end
end
