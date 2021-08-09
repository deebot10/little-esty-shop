class HolidayService
  class << self
    def call_nager_db(path, params = {})
      response = connection.get(path) do |req|
        req.params = params
      end
      parse_data(response)
    end
    
    private

    def connection
      Faraday.new("https://date.nager.at")  
    end

    def parse_data(data)
      JSON.parse(data.body, symbolize_names: true)
    end
  end
end