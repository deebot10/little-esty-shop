class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: { cancelled: 0,  "in progress"  => 1, completed: 2 }

  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not('invoice_items.status = 2')
    .select('invoices.id, invoices.created_at')
    .order(:created_at)
    .distinct
  end

  def total_revenue
    invoice_items.sum('quantity * unit_price').to_f / 100  
  end

  # def total_discount(merchant)
  #   unless merchant.bulk_discounts.empty?
  #     discount = 0
  #     invoice_items.each do |it|
  #       discount += merchant.bulk_discounts
  #       .where('quantity_threshold <= ?', it.quantity)
  #       .order('quantity_threshold desc').first.discount * ((it.quantity * it.unit_price).to_f / 100)
  #     end
  #     total_revenue - discount
  #   else 
  #     total_revenue
  #   end 
  # end

  def total_discount
    x = invoice_items.joins(:bulk_discounts)
          .select("invoice_items.id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.discount / 100.00)) as total_discount")
          .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
          .group("invoice_items.id")
          .order("total_discount desc")
          .sum(&:"total_discount")
    total_revenue - x
  end
end
