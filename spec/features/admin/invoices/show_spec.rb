require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do
  before(:each) do
    @customer = create(:customer)

    @invoice = create(:invoice, customer_id: @customer.id)

    @merchant = create(:merchant)

    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)

    @invoice_item1 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice.id, status: 0)
    @invoice_item2 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice.id, status: 0)
    @invoice_item3 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice.id, status: 1)
    @invoice_item4 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice.id, status: 1)
    @invoice_item5 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice.id, status: 2)
    @invoice_item6 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice.id, status: 0)


    @transaction1 = create(:transaction, invoice_id: @invoice.id)
    @transaction2 = create(:transaction, invoice_id: @invoice.id)
    @transaction3 = create(:transaction, invoice_id: @invoice.id)
    @transaction4 = create(:transaction, invoice_id: @invoice.id)
    @transaction5 = create(:transaction, invoice_id: @invoice.id)
    @transaction6 = create(:transaction, invoice_id: @invoice.id)
    @transaction7 = create(:transaction, invoice_id: @invoice.id)

    visit admin_invoice_path(@invoice.id)
  end

  describe 'Admin Invoice Show Page' do
    it 'Displays an Invoice and its attributes' do

      expect(page).to have_content(@invoice.id)
      expect(page).to have_content(@invoice.status)
      expect(page).to have_content(@invoice.created_at.strftime("%A, %B, %d, %Y"))
      expect(page).to have_content("#{@customer.first_name} #{@customer.last_name}")
    end
  end

  describe 'Admin Invoice Show Page: Invoice Item Information' do
    it 'It displays Invoice Item attributes' do

      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@invoice_item1.quantity)
      expect(page).to have_content(@item1.unit_price.to_f / 100)
      expect(page).to have_content(@invoice_item1.status)
    end
  end

  describe 'Admin Invoice Show Page: Total Revenue' do
    it 'displays the total revenue' do

      within('#totalrev') do
        expect(page).to have_content("Total Revenue: $#{(@invoice.total_revenue)}")
      end
    end
  end

  describe 'Admin Invoice Show Page: Update Invoice Status' do
    it 'has a select field to change status' do

      within('#status') do
        expect(page).to have_content('Invoice Status: cancelled')
        expect(page).to have_content('cancelled')
      end

      page.select 'completed', from: "invoice[status]"

      click_on "Submit"
      expect(page).to have_content('Invoice Status: completed')
    end
  end

  describe 'Admin Invoice Show Page: Total Revenue and Discounted Revenue' do
    it 'can show discounted in the admin page' do
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

      visit admin_invoice_path(invoice_1.id)
      
      within('#totalrev') do
        expect(page).to have_content('Total Revenue: $103.00')
        expect(page).to have_content("Total Discounted Revenue: $63.50")
      end
    end
  end
end
