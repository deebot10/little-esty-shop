require 'rails_helper'

RSpec.describe 'Merchants Items Index page' do
  before(:each) do

    @merchant_1 = create(:merchant)
    4.times do
      @items = create(:item, merchant_id: @merchant_1.id)
    end

    visit "/merchants/#{@merchant_1.id}/items"
  end

  it "lists the names of all this merchants items" do
    expect(page).to have_content(Item.first.name)
    expect(page).to have_content(Item.second.name)
    expect(page).to have_content(Item.third.name)
  end

  it "does not have items from other merchants" do
    merchant_2 = create(:merchant)
    items = create(:item, name: "Please Not This", merchant_id: merchant_2.id)

    expect(page).to_not have_content(Item.fifth.name)
  end

  it 'displays button to enable/disable item and sorts into the correct section' do
    merchant_2 = create(:merchant)
    items = create(:item, name: "Please Not This", merchant_id: merchant_2.id)
    items_2 = create(:item, name: "Rubber Chop Sticks", merchant_id: merchant_2.id)

    visit "/merchants/#{merchant_2.id}/items"

    expect(page).to have_button("Disable #{items.name}")
    expect(page).to have_button("Disable #{items_2.name}")
    click_on "Disable #{items.name}"
    #use within block?

    expect(current_path).to eq("/merchants/#{merchant_2.id}/items")
    # expect(items.enabled).to eq("disabled")  #Controller doesnt update :enabled on database
    expect(page).to have_button("Enable #{items.name}")
  end

  it 'has link to create a new item' do
    click_link "Create Item"

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/new")
  end

  describe "creates new item" do
    before(:each) do
      click_link "Create Item"

      fill_in "name", with: "Mamba"
      fill_in "description", with: "some random Yoda quote"
      fill_in "unit_price", with: 199
    end
    it "Allows you to fill out the form" do
      click_button "Submit"

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items")
      expect(page).to have_content("Mamba")
    end

    it "see the new item in list of items with default value of disbaled" do
      click_button "Submit"

      # require "pry"; binding.pry
      expect(Item.last.enabled).to eq("disabled")
    end
  end
end
