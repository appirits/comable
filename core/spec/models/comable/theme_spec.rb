describe Comable::Theme, type: :model do
  subject { build(:theme) }

  it { is_expected.to have_one(:store).class_name(Comable::Store.name) }

  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:version) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:version) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_length_of(:version).is_at_most(255) }
  it { is_expected.to validate_length_of(:display).is_at_most(255) }
  it { is_expected.to validate_length_of(:description).is_at_most(255) }
  it { is_expected.to validate_length_of(:homepage).is_at_most(255) }
  it { is_expected.to validate_length_of(:author).is_at_most(255) }
end
