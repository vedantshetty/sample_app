require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @other_user = users(:BigTuna)
  end



  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test'should not allow the admin attribute to be edited via the web' do 
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: {  password: 'password',
                                                     password_confirmation: 'password',
                                                     email: 'new@blue.com',
                                                     admin: true } }
    assert_not @other_user.reload.admin?
  end
  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@admin)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@admin), params: { user: { name: @admin.name,
                                              email: @admin.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@admin)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@admin), params: { user: { name: @other_user.name,
                                               email: @other_user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end

    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to root_url
  end
end
