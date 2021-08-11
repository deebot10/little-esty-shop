require 'rails_helper'

RSpec.describe InvoiceItem do
  before(:each) do
    @merchant_1 = create(:merchant)

    @customers = []
    @invoices = []
    @items = []
    @transactions = []
    @invoice_items = []

    5.times do
      @customers << create(:customer)
      @invoices << create(:invoice, customer_id: @customers.last.id, created_at: DateTime.new(2020,2,3,4,5,6))
      @items << create(:item, merchant_id: @merchant_1.id, unit_price: 20)
      @transactions << create(:transaction, invoice_id: @invoices.last.id)
      @invoice_items << create(:invoice_item, item_id: @items.last.id, invoice_id: @invoices.last.id, status: 1, quantity: 100, unit_price: @items.last.unit_price)
    end
  end

  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
    it { should have_one(:merchant).through(:item)}
    it { should have_many(:bulk_discounts).through(:merchant)}
  end

  describe 'validations' do
    it { should define_enum_for(:status).with([:pending, :packaged, :shipped]) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:quantity) }
  end

  describe 'class methods' do
    describe '#total_revenue' do
      it 'can calculate the total revenue on an invoice' do
        expect(InvoiceItem.total_revenue).to eq(100.0)
      end
    end
  end

  describe 'instance methods' do
    it 'can return a discount that qualifys' do
      merchant = create(:merchant)
      customer = create(:customer)
      
      bd_50 = create(:bulk_discount, discount: 0.5, quantity_threshold: 10, merchant_id: merchant.id)
      bd_25 = create(:bulk_discount, discount: 0.25, quantity_threshold: 5, merchant_id: merchant.id)

      item_1 = create(:item, merchant_id: merchant.id, unit_price: 5)   
      item_2 = create(:item, merchant_id: merchant.id, unit_price: 8)   

      invoice_1 = create(:invoice, customer_id: customer.id)
      invoice_2 = create(:invoice, customer_id: customer.id)
         
      invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, quantity: 11, unit_price: 500, status: 0)
      invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_1.id, quantity: 6, unit_price: 800, status: 0)
      invoice_item_3 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, quantity: 6, unit_price: 800, status: 0)

      transaction_1 = create(:transaction, invoice_id: invoice_1.id)
      transaction_2 = create(:transaction, invoice_id: invoice_2.id)

      expect(invoice_item_1.discount).to eq(bd_50)
    end
  end
end

