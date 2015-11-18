describe Comable::Address do
  it { is_expected.to belong_to(:user).class_name(Comable::User.name).autosave(false) }

  it { is_expected.to validate_presence_of(:family_name) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:zip_code) }
  it { is_expected.to validate_presence_of(:state_name) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_length_of(:family_name).is_at_most(255) }
  it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
  it { is_expected.to validate_length_of(:zip_code).is_at_most(255) }
  it { is_expected.to validate_length_of(:state_name).is_at_most(255) }
  it { is_expected.to validate_length_of(:city).is_at_most(255) }
  it { is_expected.to validate_length_of(:detail).is_at_most(255) }
  it { is_expected.to validate_length_of(:phone_number).is_at_most(255) }

  describe 'ransacker' do
    describe ':full_name' do
      it 'returns all required addresses' do
        family_name = 'foo'
        first_name = 'bar'
        address = create(:address, family_name: family_name, first_name: first_name)
        expect(subject.class.ransack(full_name: address.full_name).result).to eq([address])
      end
    end
  end
end
