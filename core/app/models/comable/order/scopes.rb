module Comable
  class Order < ActiveRecord::Base
    module Scopes
      extend ActiveSupport::Concern

      included do
        scope :complete, -> { where.not(completed_at: nil) }
        scope :incomplete, -> { where(completed_at: nil).where(draft: false) }
        scope :by_user, -> (user) { where(user_id: user) }
        scope :draft, -> { where(draft: true) }
        scope :this_month, -> { where(completed_at: Time.now.beginning_of_month..Time.now.end_of_month) }
        scope :this_week, -> { where(completed_at: Time.now.beginning_of_week..Time.now.end_of_week) }
        scope :last_week, -> { where(completed_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week) }
        scope :recent, -> { order('completed_at DESC, created_at DESC, id DESC') }
      end
    end
  end
end
