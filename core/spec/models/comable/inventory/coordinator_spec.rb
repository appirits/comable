module Comable
  module Inventory
    describe Coordinator do
      let(:stock_location) { create(:stock_location, default: true) }
      let(:stock) { create(:stock, stock_location: stock_location) }
      let(:variant) { create(:variant, :with_product, stocks: [stock]) }
      let(:order) { build(:order) }

      subject { described_class.new(order) }

      describe '#shipments' do
        it 'returns an Array with the instance of Shipment' do
          shipment = Shipment.new

          package = double('package')
          allow(package).to receive(:to_shipment).and_return(shipment)
          allow(subject).to receive(:packages).and_return([package])

          expect(subject.shipments).to eq([shipment])
        end
      end

      describe '#build_packages' do
        let(:default_stock_location) { create(:stock_location, default: true) }

        it 'returns an Array' do
          expect(subject.send(:build_packages)).to be_an(Array)
        end

        it 'returns an Array with the instance of Package' do
          stock = create(:stock, stock_location: default_stock_location)
          variant = create(:variant, :with_product, stocks: [stock])
          order_item = build(:order_item, variant: variant, quantity: 1)
          order.order_items << order_item

          expect(subject.send(:build_packages).first).to be_an_instance_of(Package)
        end

        it 'builds a package with two contents from an order item with a quantity of two' do
          quantity = 2

          stock = create(:stock, stock_location: default_stock_location, quantity: quantity)
          variant = create(:variant, :with_product, stocks: [stock])
          order_item = build(:order_item, variant: variant, quantity: quantity)
          order.order_items << order_item

          expect(subject.send(:build_packages).first.units.count).to eq(2)
        end
      end

      describe '#adjust_packages' do
        it 'returns an Array' do
          unit = Unit.new(variant)

          package = Package.new(stock_location)
          package.add(unit)
          allow(subject).to receive(:units).and_return([unit])

          expect(subject.send(:adjust_packages, [package])).to be_an(Array)
        end

        it 'returns an Array with the instance of Package' do
          unit = Unit.new(variant)
          allow(subject).to receive(:units).and_return([unit])

          package = Package.new(stock_location)
          package.add(unit)

          expect(subject.send(:adjust_packages, [package]).first).to be_an_instance_of(Package)
        end

        it 'removes a duplicated item from packages' do
          unit = Unit.new(variant)
          allow(subject).to receive(:units).and_return([unit])

          package_first = Package.new(stock_location)
          package_first.add(unit)

          package_last = Package.new(stock_location)
          package_last.add(unit)

          packages = subject.send(:adjust_packages, [package_first, package_last])
          expect(packages.first).not_to be_empty
          expect(packages.last).to be_empty
        end
      end

      describe '#compact_packages' do
        it 'rejects all empty packages' do
          package_first = Package.new(stock_location)
          package_last = Package.new(stock_location)

          packages = subject.send(:compact_packages, [package_first, package_last])
          expect(packages.size).to eq(0)
        end

        it 'does not reject not empty packages' do
          unit = Unit.new(variant)
          allow(subject).to receive(:units).and_return([unit])

          package = Package.new(stock_location)
          package.add(unit)

          packages = subject.send(:compact_packages, [package])
          expect(packages.size).to eq(1)
        end
      end

      describe '#units_exists_in?' do
        it 'returns true when @units exists in requested StockLocation' do
          unit = Unit.new(variant)
          allow(subject).to receive(:units).and_return([unit])

          expect(subject.send(:units_exists_in?, stock_location)).to be true
        end

        it 'returns false when @units does not exist in requested StockLocation' do
          another_stock_location = create(:stock_location)

          unit = Unit.new(variant)
          allow(subject).to receive(:units).and_return([unit])

          expect(subject.send(:units_exists_in?, another_stock_location)).to be false
        end
      end
    end
  end
end
