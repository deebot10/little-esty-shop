require 'rails_helper'

# RSpec.describe BulkDiscount, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
RSpec.describe BulkDiscount do 
  describe 'relationships' do
    it { should belong_to :merchant}
  end
end