module Comable
  class Theme < ActiveRecord::Base
    has_one :store, class_name: Comable::Store.name

    validates :name, uniqueness: { scope: :version }
    validates :name, presence: true, length: { maximum: 255 }
    validates :version, presence: true, length: { maximum: 255 }
    validates :display, length: { maximum: 255 }
    validates :description, length: { maximum: 255 }
    validates :homepage, length: { maximum: 255 }
    validates :author, length: { maximum: 255 }

    scope :by_newest, -> { reorder(created_at: :desc) }

    class << self
      def dir
        Rails.root.join('themes')
      end
    end

    def dir
      self.class.dir + name
    end

    def default_version
      '0.1.0'
    end

    def to_param
      name
    end

    def display_name
      display.presence || name
    end
  end
end
