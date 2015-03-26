module Comable
  class Order < ActiveRecord::Base
    module Morrisable
      extend ActiveSupport::Concern

      module ClassMethods
        def morris_keys
          %w( count price )
        end

        def to_morris
          this = (Rails::VERSION::MAJOR == 3) ? scoped : all
          this.group_by { |order| order.completed_at.to_date }.map do |date, orders|
            { date: date, count: orders.count, price: orders.sum(&:total_price) }
          end.to_json
        end
      end
    end
  end
end
