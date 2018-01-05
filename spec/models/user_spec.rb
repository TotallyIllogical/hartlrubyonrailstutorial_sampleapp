require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:user,:admin)
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it "has valid userdata" do
    expect(@user).to be_valid
  end

  it 'name should be present' do
    @user.name = '  '
    expect(@user).to_not be_valid
  end

  it 'name should not be too long' do
    @user.name = "a" * 60
    expect(@user).to_not be_valid
  end

  it 'email should be present' do
    @user.email = '  '
    expect(@user).to_not be_valid
  end

  it 'email should not be too long' do
    @user.email = 'a' * 255 + '@example.com'
    expect(@user).to_not be_valid
  end

  it 'email validation should accept valid email addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+wonderland@bas.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      expect(valid_address).to be_valid
    end
  end



end
