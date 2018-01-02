require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  # Special function that automatically runs before every test
  def setup
    @relationship = Relationship.new(follower_id: users(:jaffagoauld1).id, followed_id: users(:jaffagoauld2).id)
  end

  test 'should be valid' do
    assert @relationship.valid?
  end

  test 'should require a follower_id' do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test 'should require a followed_id' do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

end
