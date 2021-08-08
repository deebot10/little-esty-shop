class Merchant::BulkDiscountsController < ApplicationController 
  def index
    @discounts = BulkDiscount.all
    @holidays = HolidayFacade.find_upcoming_holidays
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.new(discount_params)
    if discount.save
      redirect_to merchant_bulk_discounts_path(merchant)
    flash[:notice] = 'New Discount Created'
  #   else
  #     render :new
  #     flash[:notice] = 'Discount not created: Required info missing'
    end  
  end

  private

  def discount_params
    params.permit(:discount, :quantity_threshold)
  end
end