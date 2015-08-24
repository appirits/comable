describe Comable::Stock do
  it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
end
