require 'rails_helper'

RSpec.describe 'BulkDiscount Index Page' do
  before(:each) do
    @merchant = create(:merchant)

    @bd_10 = create(:bulk_discount, discount: 0.1, quantity_threshold:  5, merchant_id: @merchant.id)
    @bd_25 = create(:bulk_discount, discount: 0.25, quantity_threshold: 10, merchant_id: @merchant.id)
    @bd_50 = create(:bulk_discount, discount: 0.5 ,quantity_threshold: 10, merchant_id: @merchant.id)
    
    visit merchant_bulk_discounts_path(@merchant)
  end  

  describe 'Merchant Bulk Discounts Index' do
    it 'displays each bulk discount as well as ther percentage' do
      within("#discount-#{@bd_10.id}") do
        expect(page).to have_link(@bd_10.id)
        expect(page).to have_content(@bd_10.discount)
        expect(page).to have_content(@bd_10.quantity_threshold)
      end

      within("#discount-#{@bd_25.id}") do
        expect(page).to have_link(@bd_25.id)
        expect(page).to have_content(@bd_25.discount)
        expect(page).to have_content(@bd_25.quantity_threshold)
      end

      within("#discount-#{@bd_50.id}") do
        expect(page).to have_link(@bd_50.id)
        expect(page).to have_content(@bd_50.discount)
        expect(page).to have_content(@bd_50.quantity_threshold)
      end
    end
  end

  describe 'Upcoming Holidays' do
    it 'I see a section with a header of Upcoming Holidays' do
      expect(page).to have_content('Upcoming Holidays')

      within('#holidays') do 

        expect(page).to have_content('Holiday Name: Labour Day')
        expect(page).to have_content('Date: 2021-09-06')
        expect(page).to have_content('Holiday Name: Columbus Day')
        expect(page).to have_content('Date: 2021-10-11')
        expect(page).to have_content('Holiday Name: Veterans Day')
        expect(page).to have_content('Date: 2021-11-11')
      end
    end
  end

  describe 'Merchant Bulk Discount Create' do
    it 'can create a new discount' do
      expect(page).to have_link('Create a Discount')

      click_link 'Create a Discount'

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
    end
  end

  describe 'Merchant Bulk Discount Delete' do
    it 'can delete a bulk discount' do
      within("#discount-#{@bd_25.id}") do
       expect(page).to have_button("Delete #{@bd_25.id}")
       click_button "Delete #{@bd_25.id}"
      end  

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      expect(page).to_not have_content(@bd_25.id)
    end
  end
end