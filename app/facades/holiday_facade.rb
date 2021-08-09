class HolidayFacade

  def self.find_upcoming_holidays
    holiday_info = HolidayService.call_nager_db("/api/v3/NextPublicHolidays/US")  
    holiday_info.map { |info| HolidayInfo.new(info) }.first(3)
  end
end