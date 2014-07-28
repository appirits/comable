Comable::Stock.class_eval do
  self.table_name = Stock.table_name
  utusemi!(:stock)
end
