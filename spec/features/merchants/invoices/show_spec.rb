require 'rails_helper'

RSpec.describe 'Merchants invoices show page' do
  describe "invoices" do
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
        @invoice_items << create(:invoice_item, item_id: @items.last.id, invoice_id: @invoices.last.id, status: 1, quantity: 10, unit_price: @items.last.unit_price)
      end

      visit "/merchants/#{@merchant_1.id}/invoices/#{@invoices[0].id}"
    end

    it "has path to page" do
      expect(page).to have_content("Invoice ##{@invoices[0].id}")
    end

    it "shows correct date format created at" do
      expect(page).to have_content("Monday February 3, 2020")
    end

    it "has all attributes" do
      expect(page).to have_content("#{@invoices[0].status}")
      expect(page).to have_content("#{@invoices[0].id}")
      expect(page).to have_content("Monday February 3, 2020")
      expect(page).to have_content("#{@customers[0].first_name}")
      expect(page).to have_content("#{@customers[0].last_name}")
    end

    it "can list total revenue" do
      @items << create(:item, merchant_id: @merchant_1.id, unit_price: 1598)
      @invoice_items << create(:invoice_item, item_id: @items.last.id, invoice_id: @invoices[0].id, status: 1, quantity: 10, unit_price: @items.last.unit_price)

      visit "/merchants/#{@merchant_1.id}/invoices/#{@invoices[0].id}"
      expect(page).to have_content("Total Revenue: $161.80")

    end

    it "allows merchant to select invoice status" do
      expect(@invoice_items[0].status).to eq("packaged")

      page.select "shipped", from: 'status'
      click_button "Update Item Status"

      expect(page).to have_content("shipped")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/invoices/#{@invoices[0].id}")
    end
  end

  describe 'Merchant Invoice Show Page: Total Revenue and Discounted Revenue' do
    it 'can dsicount total revenue' do
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

      visit merchant_invoice_path(merchant, invoice_1)

      expect(page).to have_content('Total Revenue: $103.00')
      expect(page).to have_content("Total Discounted Revenue: $63.50")
    end
  end

  describe 'Merchant Invoice Show Page: Link to applied discounts' do
    it 'has a link to the page discount' do
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

      visit merchant_invoice_path(merchant, invoice_1)

      within("#discount-#{invoice_item_1.id}") do
        save_and_open_page
        expect(page).to have_link('Discount')
        click_link 'Discount'
        expect(current_path).to eq(merchant_bulk_discount_path(merchant, bd_50))
      end
    end
  end
end
