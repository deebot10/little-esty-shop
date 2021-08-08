require 'rails_helper'

RSpec.describe 'BulkDiscount Index Page' do
  before(:each) do
    @merchant = create(:merchant)

    @bd_10 = create(:bulk_discount, discount: 0.1, quantity_threshold:  5, merchant_id: @merchant.id)
    @bd_25 = create(:bulk_discount, discount: 0.25, quantity_threshold: 10, merchant_id: @merchant.id)
    @bd_50 = create(:bulk_discount, discount: 0.5 ,quantity_threshold: 10, merchant_id: @merchant.id)
    
    visit bulk_discounts_path
  end  

  describe 'Merchant Bulk Discounts Index' do
    #     Merchant Bulk Discounts Index

    # As a merchant
    # When I visit my merchant dashboard
    # Then I see a link to view all my discounts
    # When I click this link
    # Then I am taken to my bulk discounts index page
    # Where I see all of my bulk discounts including their
    # percentage discount and quantity thresholds
    # And each bulk discount listed includes a link to its show page
    it 'displays each bulk discount as well as ther percentage' do
      within("#discount-#{@bd_10.id}") do
        expect(page).to have_content(@bd_10.discount)
        expect(page).to have_content(@bd_10.quantity_threshold)
      end

      within("#discount-#{@bd_25.id}") do
        expect(page).to have_content(@bd_25.discount)
        expect(page).to have_content(@bd_25.quantity_threshold)
      end

      within("#discount-#{@bd_50.id}") do
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
end