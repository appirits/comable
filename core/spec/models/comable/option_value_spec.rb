describe Comable::OptionValue do
  it { is_expected.to belong_to(:option_type).class_name(Comable::OptionType.name) }
  it { is_expected.to have_and_belong_to_many(:variants).class_name(Comable::Variant.name) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
end
