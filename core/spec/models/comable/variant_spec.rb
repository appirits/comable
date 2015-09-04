describe Comable::Variant do
  it { is_expected.to belong_to(:product).class_name(Comable::Product.name).inverse_of(:variants) }
  it { is_expected.to have_one(:stock).class_name(Comable::Stock.name).inverse_of(:variant).dependent(:destroy).autosave(true) }
  it { is_expected.to have_and_belong_to_many(:option_values).class_name(Comable::OptionValue.name) }

  it { is_expected.to validate_presence_of(:product).with_message(Comable.t('admin.is_not_exists')) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_length_of(:sku).is_at_most(255) }

  describe '#options' do
    it 'should returns name of OptionValue' do
      option_value = build(:option_value)
      subject.option_values = [option_value]
      expect(subject.options.first[:value]).to eq(option_value.name)
    end

    it 'should returns name of OptionType' do
      option_type = build(:option_type)
      option_value = build(:option_value, option_type: option_type)
      subject.option_values = [option_value]
      expect(subject.options.first[:name]).to eq(option_type.name)
    end
  end

  describe '#options=' do
    it 'should sets OptionValue' do
      option_value_name = 'Red'
      subject.options = [name: 'Color', value: option_value_name]
      expect(subject.option_values.first.name).to eq(option_value_name)
    end

    it 'should sets OptionValue by JSON' do
      option_value_name = 'Red'
      subject.options = [name: 'Color', value: option_value_name].to_json
      expect(subject.option_values.first.name).to eq(option_value_name)
    end

    it 'should sets OptionType' do
      option_type_name = 'Color'
      subject.options = [name: option_type_name, value: 'Red']
      expect(subject.option_values.first.option_type.name).to eq(option_type_name)
    end

    it 'should sets OptionType by JSON' do
      option_type_name = 'Color'
      subject.options = [name: option_type_name, value: 'Red'].to_json
      expect(subject.option_values.first.option_type.name).to eq(option_type_name)
    end
  end
end
