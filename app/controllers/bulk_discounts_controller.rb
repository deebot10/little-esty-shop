class BulkDiscountsController < ApplicationController 
  def index
    @discounts = BulkDiscount.all
    @holidays = HolidayFacade.find_upcoming_holidays
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end
end