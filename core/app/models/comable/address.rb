module Comable
  class Address < ActiveRecord::Base
    extend Enumerize

    belongs_to :customer, class_name: Comable::Customer.name, foreign_key: Comable::Customer.table_name.singularize.foreign_key, autosave: false

    enumerize :assign_key, in: {
      nothing: nil,
      bill: 1,
      ship: 2
    }, scope: true
  end
end
