describe Comable::Address do
  it { is_expected.to enumerize(:assign_key).in(:nothing, :bill, :ship) }
end
