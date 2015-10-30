module Comable
  module Inventory
    describe Package do
      let(:stock_location) { build(:stock_location) }
      let(:variant) { build(:variant) }

      subject { described_class.new(stock_location) }

      it { is_expected.to have_attr_accessor(:stock_location) }
      it { is_expected.to have_attr_accessor(:units) }

      describe '#initialize' do
        it 'sets the stock location as @stock_location' do
          package = described_class.new(stock_location)
          expect(package.instance_variable_get(:@stock_location)).to eq(stock_location)
        end
      end

      describe '#initialize_copy' do
        it 'clones the requested units' do
          units = [Unit.new(variant)]
          subject.units = units
          package = subject.clone
          expect(subject.units).not_to be package.units
        end
      end

      describe '#add' do
        it 'puts an unit into units' do
          unit = Unit.new(variant)
          subject.add(unit)
          expect(subject.units.size).to eq(1)
        end

        it 'puts multiple units into units' do
          units = [Unit.new(variant), Unit.new(variant)]
          subject.add(units)
          expect(subject.units.size).to eq(units.size)
        end
      end

      describe '#remove' do
        it 'deletes an unit from units' do
          unit = Unit.new(variant)
          subject.add(unit)
          subject.remove(unit)
          expect(subject.units.size).to eq(0)
        end
      end

      describe '#find' do
        it 'detects an unit from units' do
          unit = Unit.new(variant)
          subject.add(unit)
          expect(subject.find(unit)).to eq(unit)
        end
      end

      describe '#to_shipment' do
        it 'returns an instance of Shipment' do
          expect(subject.to_shipment).to be_an_instance_of(Shipment)
        end

        it 'sets shipment items' do
          shipment_items = [ShipmentItem.new]
          allow(subject).to receive(:build_shipment_items).and_return(shipment_items)

          shipment = subject.to_shipment
          expect(shipment.shipment_items).to eq(shipment_items)
        end
      end

      describe '#build_shipment_items' do
        it 'returns an Array' do
          shipment = build(:shipment)
          shipment_items = subject.send(:build_shipment_items, shipment)
          expect(shipment_items).to be_an_instance_of(Array)
        end

        it 'returns an Array with the instance of Package' do
          unit = Unit.new(variant)
          subject.units = [unit]

          allow(unit).to receive(:to_shipment_item).and_return(ShipmentItem.new)

          shipment = build(:shipment)
          shipment_items = subject.send(:build_shipment_items, shipment)
          expect(shipment_items.first).to be_an_instance_of(ShipmentItem)
        end
      end
    end
  end
end
