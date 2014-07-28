module Comable
  module Able
    module OrderDeliverable
      def self.included(base)
        base.instance_eval do
          belongs_to :order, class_name: Comable::Order.name, foreign_key: Comable::Order.table_name.singularize.foreign_key
          has_many :order_details, dependent: :destroy, class_name: Comable::OrderDetail.name, foreign_key: table_name.singularize.foreign_key

          accepts_nested_attributes_for :order_details

          delegate :customer, to: :order
        end
      end

      private

      def generate_code
        self.code = loop do
          random_token = SecureRandom.urlsafe_base64(nil, false)
          break random_token unless self.class.exists?(code: random_token)
        end
      end
    end
  end
end
