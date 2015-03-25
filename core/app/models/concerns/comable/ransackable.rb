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

      def ransackable_attributes(auth_object = nil)
        column_names + _ransackers.keys
      end

      def ransackable_association?
        klass.ransackable_associations(auth_object).include? str
      end

      def ransackable_associations(auth_object = nil)
        reflect_on_all_associations.map { |a| a.name.to_s }
      end
    end
  end
end
