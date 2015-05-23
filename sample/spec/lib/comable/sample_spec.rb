describe Comable::Sample do
  describe '.import_all' do
    it 'should not raise error' do
      expect { described_class.import_all }.to_not raise_error
    end
  end
end
