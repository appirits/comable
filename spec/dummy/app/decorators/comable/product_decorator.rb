Comable::Product.class_eval do
  self.table_name = DummyProduct.table_name
  utusemi!
end
