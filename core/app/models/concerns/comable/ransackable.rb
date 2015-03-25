module Comable
  module Ransackable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_reader :_ransack_options

      def ransack_options(options = nil)
        if options
          @_ransack_options = options
        else
          @_ransack_options || {}
        end
      end

      def ransackable_attribute?
        klass.ransackable_attributes(auth_object).include? str
      end

      def ransackable_attributes(_auth_object = nil)
        ransackable_attributes_options = ransack_options[:ransackable_attributes] || {}
        if ransackable_attributes_options[:only]
          [ransackable_attributes_options[:only]].flatten.map(&:to_s)
        else
          column_names + _ransackers.keys - [ransackable_attributes_options[:except]].flatten.map(&:to_s)
        end
      end

      def ransackable_association?
        klass.ransackable_associations(auth_object).include? str
      end

      def ransackable_associations(_auth_object = nil)
        reflect_on_all_associations.map { |a| a.name.to_s }
      end
    end
  end
end
