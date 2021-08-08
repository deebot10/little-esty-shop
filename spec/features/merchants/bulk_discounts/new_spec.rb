require 'rails_helper'

RSpec.describe 'BulkDiscount New' do
  before(:each) do
    @merchant = create(:merchant)

    visit new_merchant_bulk_discount_path(@merchant)
  end

  describe 'Merchant Bulk Discount Create' do
    it 'can create a new merchant' do
      fill_in :discount, with: 0.5
      fill_in :quantity_threshold, with: 20
  
      click_on 'Submit'
      
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      
      expect(page).to have_content(0.5)
      expect(page).to have_content(20)
    end

    xit 'can send back flash messafes for incomplete' do
      fill_in :discount, with: 0.5

      click_on 'Submit'

      expect(page).to have_content('Discount not created: Required info missing')
    end
  end
end