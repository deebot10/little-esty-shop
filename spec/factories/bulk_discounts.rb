FactoryBot.define do
  factory :bulk_discount do
    merchant 
    discount { [0.1, 0.25, 0.5].sample }
    quantity_threshold { 5 }
  end
end
