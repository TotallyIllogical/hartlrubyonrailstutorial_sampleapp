require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :jaffagoauld -> test/fixtures/users.yml
    @admin_user = users(:jaffagoauld1)
    @simple_user = users(:jaffagoauld2)

    @micropost = microposts(:micropostone)
    @micropost2 = microposts(:microposttwo)
    @micropost3 = microposts(:micropostthree)
    @micropost4 = microposts(:micropostfour)
    @micropost5 = microposts(:micropostfive)
  end

  test 'should redirect create when not logged in' do
    # Check so that microposts
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: 'Kel shak?' } }
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy micropost for wrong user' do
    log_in_as(@simple_user)
    micropost = microposts(:micropostone)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end

end
