class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  validates :unit_price, presence: true
  validates :quantity, presence: true

  enum status: {pending: 0, packaged: 1, shipped: 2}

  def self.total_revenue
    (sum("invoice_items.unit_price * invoice_items.quantity").to_f)/100
  end

  def discount
    bulk_discounts.where('bulk_discounts.quantity_threshold <= ?', quantity)
                  .size >= 1
                  # .order(discount: :desc).first  
  end

  def find_discount
    bulk_discounts.where('bulk_discounts.quantity_threshold <= ?', quantity)
                  .order(discount: :desc).first  
  end
end
