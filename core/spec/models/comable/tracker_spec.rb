RSpec.describe Comable::Tracker do
  subject { build(:tracker) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:place) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_length_of(:tracker_id).is_at_most(255) }
  it { is_expected.to validate_length_of(:place).is_at_most(255) }
end
