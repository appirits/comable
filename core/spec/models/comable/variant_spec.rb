describe Comable::Variant do
  it { is_expected.to belong_to(:product).class_name(Comable::Product.name).inverse_of(:variants) }
  it { is_expected.to have_one(:stock).class_name(Comable::Stock.name).inverse_of(:variant).dependent(:destroy).autosave(true) }
  it { is_expected.to have_and_belong_to_many(:option_values).class_name(Comable::OptionValue.name) }

  it { is_expected.to validate_presence_of(:product).with_message(Comable.t('admin.is_not_exists')) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_length_of(:sku).is_at_most(255) }
end
