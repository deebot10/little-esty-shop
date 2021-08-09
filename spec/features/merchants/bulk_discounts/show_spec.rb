require 'rails_helper'

RSpec.describe 'BulkDiscount Show Page' do
  before(:each) do
    @merchant = create(:merchant)
    @bd_50 = create(:bulk_discount, discount: 0.5 ,quantity_threshold: 10, merchant_id: @merchant.id)

    visit merchant_bulk_discount_path(@merchant, @bd_50)
  end

  describe 'Merchant Bulk Discount Show' do
    it 'displays the discount and attributes' do
      expect(page).to have_content(@bd_50.discount)
      expect(page).to have_content(@bd_50.quantity_threshold)
    end
  end

  describe 'Merchant Bulk Discount Edit' do
    #     As a merchant
    # When I visit my bulk discount show page
    # Then I see a link to edit the bulk discount
    # When I click this link
    # Then I am taken to a new page with a form to edit the discount
    # And I see that the discounts current attributes are pre-poluated in the form
    # When I change any/all of the information and click submit
    # Then I am redirected to the bulk discount's show page
    # And I see that the discount's attributes have been updated
    it 'Can edit a Discount' do
      expect(page).to have_button('Edit')
      
      click_button 'Edit'
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @bd_50))

      fill_in :discount, with: 0.2
      fill_in :quantity_threshold, with: 20
  
      click_on 'Submit'
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bd_50))

      expect(page).to have_content("Discount: 0.2")
      expect(page).to have_content("Quantity Threshold: 20")
    end
  end
end