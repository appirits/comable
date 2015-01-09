describe Comable::Product::Search do
  before(:all) do
    ActiveRecord::Migration.new.instance_eval do
      self.verbose = false

      create_table :dummy_products do |t|
        t.string :code
        t.string :name
        t.text :caption
      end
    end

    class DummyProduct < ActiveRecord::Base
      include Comable::Product::Search
    end
  end

  after(:all) do
    ActiveRecord::Migration.new.instance_eval do
      self.verbose = false
      drop_table :dummy_products
    end
    Object.send(:remove_const, :DummyProduct)
  end

  describe '.search' do
    context 'when 1 word' do
      let!(:product) { DummyProduct.create(code: 'aaa', name: 'bbb', caption: 'ccc') }

      it 'should return the correct products' do
        expect(DummyProduct.search('aaa').count).to eq(1)
        expect(DummyProduct.search('bbb').count).to eq(1)
        expect(DummyProduct.search('ccc').count).to eq(1)
        expect(DummyProduct.search('ddd').count).to eq(0)
      end
    end

    context 'when 2 words' do
      let!(:product) { DummyProduct.create(code: 'aaabbbccc', name: 'dddeeefff', caption: 'ggghhhiii') }

      it 'should return the correct products' do
        expect(DummyProduct.search('aaa ccc').count).to eq(1)
        expect(DummyProduct.search('ddd fff').count).to eq(1)
        expect(DummyProduct.search('ggg iii').count).to eq(1)
        expect(DummyProduct.search('aaa iii').count).to eq(0) # TODO: 0 => 1
        expect(DummyProduct.search('aaa jjj').count).to eq(0)
      end
    end
  end
end
