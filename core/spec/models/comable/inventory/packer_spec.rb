module Comable
  module Inventory
    describe Packer do
      let(:stock_location) { build(:stock_location) }
      let(:units) { [] }

      subject { described_class.new(stock_location, units) }

      it { is_expected.to have_attr_accessor(:stock_location) }
      it { is_expected.to have_attr_accessor(:units) }

      describe '#initialize' do
        it 'sets the stock location as @stock_location' do
          packer = described_class.new(stock_location, units)
          expect(packer.instance_variable_get(:@stock_location)).to eq(stock_location)
        end

        it 'sets the units as @units' do
          packer = described_class.new(stock_location, units)
          expect(packer.instance_variable_get(:@units)).to eq(units)
        end
      end

      describe '#package' do
        it 'returns an instance of Package' do
          expect(subject.package).to be_an_instance_of(Package)
        end

        it 'puts a one unit' do
          stock = create(:stock, stock_location: stock_location, quantity: 1)
          variant = create(:variant, :with_product, stocks: [stock])

          subject.units = [Unit.new(variant)]

          expect(subject.package.size).to eq(1)
        end

        it 'puts two units from the same variant' do
          stock = create(:stock, stock_location: stock_location, quantity: 2)
          variant = create(:variant, :with_product, stocks: [stock])

          subject.units = [Unit.new(variant), Unit.new(variant)]

          expect(subject.package.size).to eq(2)
        end

        it 'puts two units from the different variants' do
          stock_first = create(:stock, stock_location: stock_location, quantity: 1)
          variant_first = create(:variant, :with_product, stocks: [stock_first])

          stock_last = create(:stock, stock_location: stock_location, quantity: 1)
          variant_last = create(:variant, :with_product, stocks: [stock_last])

          subject.units = [Unit.new(variant_first), Unit.new(variant_last)]

          expect(subject.package.size).to eq(2)
        end

        it 'puts no units when missing stock items in the stock location' do
          stock = create(:stock, quantity: 10)
          variant = create(:variant, :with_product, stocks: [stock])

          subject.units = [Unit.new(variant)]

          expect(subject.package.size).to eq(0)
        end

        it 'puts no units when out of stock items' do
          stock = create(:stock, stock_location: stock_location, quantity: 0)
          variant = create(:variant, :with_product, stocks: [stock])

          subject.units = [Unit.new(variant)]

          expect(subject.package.size).to eq(0)
        end
      end
    end
  end
end
