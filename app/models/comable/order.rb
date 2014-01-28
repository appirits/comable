module Comable
  class Order < ActiveRecord::Base
    belongs_to Comable::Engine::config.customer_table.to_s.singularize.to_sym

    before_create :generate_code

    private

    def generate_code
      self.code = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.exists?(code: random_token)
      end
    end
  end
end
