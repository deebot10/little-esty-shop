require 'rails_helper'

describe HolidayService do
  context "class methods" do
    it "can make API call to database"  do
      query = HolidayService.call_nager_db("/api/v3/NextPublicHolidays/US").first
    
      expect(query).to be_a Hash
      check_hash_structure(query, :date, String)
      check_hash_structure(query, :name, String) 
    end
  end
end