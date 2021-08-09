require 'rails_helper'

RSpec.describe HolidayInfo do
  it 'exists' do
    attrs = {:date=>"2021-09-06", :name=>"Labour Day"}

    holiday = HolidayInfo.new(attrs)
    expect(holiday).to be_a HolidayInfo
    expect(holiday).to have_attributes({:date=>"2021-09-06", :name=>"Labour Day"})
  end
end