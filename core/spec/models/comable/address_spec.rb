describe Comable::Address do
  it { is_expected.to belong_to(:user).class_name(Comable::User.name).autosave(false) }

  it { is_expected.to validate_presence_of(:family_name) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:zip_code) }
  it { is_expected.to validate_presence_of(:state_name) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_length_of(:family_name).is_at_most(255) }
  it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
  it { is_expected.to validate_length_of(:zip_code).is_at_most(8) }
  it { is_expected.to validate_length_of(:state_name).is_at_most(255) }
  it { is_expected.to validate_length_of(:city).is_at_most(255) }
  it { is_expected.to validate_length_of(:detail).is_at_most(255) }
  it { is_expected.to validate_length_of(:phone_number).is_at_most(18) }
end
