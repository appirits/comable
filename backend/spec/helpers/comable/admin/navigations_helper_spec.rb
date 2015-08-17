require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Comable::Admin::PagesHelper. For example:
#
# describe Comable::Admin::PagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe Comable::Admin::NavigationsHelper, type: :helper do
  subject { helper }

  describe '#linkable_type_options' do
    it 'returns' do
      options = Comable::NavigationItem.linkable_params_lists.map { |attr| attr.slice(:name, :type).values }
      expect(subject.linkable_type_options).to eq(options)
    end
  end
end
