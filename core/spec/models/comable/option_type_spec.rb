describe Comable::OptionType do
  it { is_expected.to have_many(:option_values).class_name(Comable::OptionValue.name) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
end
