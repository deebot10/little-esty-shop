class Merchant::BulkDiscountsController < ApplicationController 
  def index
    @discounts = BulkDiscount.all
    @holidays = HolidayFacade.find_upcoming_holidays
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new;end

  def create
    
  end
end