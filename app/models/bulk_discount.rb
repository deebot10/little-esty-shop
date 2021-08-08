class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :quantity_threshold, presence: true
  validates :discount, presence: true
end
