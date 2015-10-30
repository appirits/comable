module Comable
  module Inventory
    describe Adjuster do
      let(:packages) { [] }
      let(:units) { [] }

      subject { described_class.new(packages, units) }

      it { is_expected.to have_attr_accessor(:packages) }
      it { is_expected.to have_attr_accessor(:units) }

      describe '#initialize' do
        it 'sets the packages as @packages' do
          adjuster = described_class.new(packages, units)
          expect(adjuster.instance_variable_get(:@packages)).to eq(packages)
        end

        it 'sets the units as @units' do
          adjuster = described_class.new(packages, units)
          expect(adjuster.instance_variable_get(:@units)).to eq(units)
        end
      end

      describe '#adjusted_packages' do
        it 'returns an Array with the instance of Shipment' do
          stock_location = build(:stock_location)
          package = Package.new(stock_location)
          subject.packages = [package]

          allow(subject).to receive(:remove_duplicated_items)

          expect(subject.adjusted_packages.first).to eq(package)
        end
      end

      describe '#remove_duplicated_items' do
        it 'calls #remove_duplicated' do
          expect(subject).to receive(:remove_duplicated).exactly(1).times

          variant = build(:variant)
          unit = Unit.new(variant)
          subject.units = [unit]
          subject.send(:remove_duplicated_items)
        end
      end

      describe '#remove_duplicated' do
        it 'removes a duplicated unit' do
          # Set a unit into units
          variant = build(:variant)
          unit = Unit.new(variant)
          subject.units = [unit]

          # Set the first package into packages
          stock_location_first = build(:stock_location)
          package_first = Package.new(stock_location_first)
          subject.packages += [package_first]

          # Set the second package into packages
          stock_location_second = build(:stock_location)
          package_second = Package.new(stock_location_second)
          subject.packages += [package_second]

          # Add units into packages
          package_first.add(unit)
          package_second.add(unit)

          subject.send(:remove_duplicated, unit)

          expect(package_first.size).to eq(1)
          expect(package_second.size).to eq(0)
        end
      end
    end
  end
end
