require 'rails_helper'

# RSpec.describe BulkDiscount, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
RSpec.describe BulkDiscount do 

  describe 'relationships' do
    it { should belong_to :merchant}
  end

  describe 'validations' do
    it { should validate_presence_of :discount}
    it { should validate_presence_of :quantity_threshold}
  end
end