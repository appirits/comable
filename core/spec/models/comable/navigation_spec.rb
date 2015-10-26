describe Comable::Navigation do
  subject { create(:navigation, navigation_items: [create(:navigation_item)]) }

  it { is_expected.to scope(:by_newest) { reorder(created_at: :desc) } }

  describe 'associations' do
    it { is_expected.to have_many(:navigation_items).class_name(Comable::NavigationItem.name) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
  end
end
