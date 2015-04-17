describe Comable::Importable do
  before(:all) do
    class DummyModel
      include Comable::Importable

      comma do
        foo
        bar
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, :DummyModel)
  end

  subject { DummyModel }

  describe '.open_spreadsheet' do
    context 'when format is csv' do
      let(:extname) { '.csv' }
      let(:mine_type) { 'text/csv' }

      it 'returns a Roo::CSV object' do
        file = Rack::Test::UploadedFile.new(Rails.root.join('public/favicon.ico'), mine_type)
        allow(File).to receive(:extname).and_return(file.original_filename).and_return(extname)

        expect(Roo::CSV).to receive(:new).with(file.path)

        subject.send(:open_spreadsheet, file)
      end
    end

    context 'when format is xlsx' do
      let(:extname) { '.xlsx' }
      let(:mine_type) { 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }

      it 'returns a Roo::Excelx object' do
        file = Rack::Test::UploadedFile.new(Rails.root.join('public/favicon.ico'), mine_type)
        allow(File).to receive(:extname).and_return(file.original_filename).and_return(extname)

        expect(Roo::Excelx).to receive(:new).with(file.path, nil, :ignore)

        subject.send(:open_spreadsheet, file)
      end
    end

    context 'when format is xls' do
      let(:extname) { '.xls' }
      let(:mine_type) { 'application/vnd.ms-excel' }

      it 'returns a Roo::Excel object' do
        file = Rack::Test::UploadedFile.new(Rails.root.join('public/favicon.ico'), mine_type)
        allow(File).to receive(:extname).and_return(file.original_filename).and_return(extname)

        expect(Roo::Excel).to receive(:new).with(file.path, nil, :ignore)

        subject.send(:open_spreadsheet, file)
      end
    end
  end

  describe '.comma_column_names' do
    it 'returns column names' do
      expect(subject.send(:comma_column_names)).to eq(['foo', 'bar'])
    end
  end

  describe '.human_attributes_to_attributes' do
    it 'converts human attributes to attributes' do
      human_attributes = { 'Foo' => 1, 'Bar' => 2 }
      attributes = { foo: 1, bar: 2 }
      expect(subject.send(:human_attributes_to_attributes, human_attributes)).to eq(attributes)
    end
  end
end
