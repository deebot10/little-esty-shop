require 'rails_helper'

describe HolidayFacade do
  context "class methods" do
    it "returns holiday matching selections" do
      selection = HolidayFacade.find_upcoming_holidays

      expect(selection).to be_an Array
      expect(selection.count).to eq(3)
      expect(selection.first.name).to be_a(String)
      expect(selection.first.date).to be_a(String)
    end
  end
end