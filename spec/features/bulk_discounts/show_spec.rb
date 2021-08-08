require 'rails_helper'

RSpec.describe 'BulkDiscount Show Page' do
  before(:each) do
    @merchant = create(:merchant)
    @bd_50 = create(:bulk_discount, discount: 0.5 ,quantity_threshold: 10, merchant_id: @merchant.id)

    visit bulk_discount_path(@bd_50)
  end

  describe 'Story5' do
    it 'displays the discount and attributes' do
      expect(page).to have_content(@bd_50.discount)
      expect(page).to have_content(@bd_50.quantity_threshold)
    end
  end
end