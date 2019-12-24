require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              password: 'foo',
                                              password_confirmation: 'foo2',
                                              email: 'example@invalid' } }
    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors'
  end


  test 'successful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'GoodName'
    email = 'good@valid.com'
    patch user_path(@user), params: { user: { name: name,
                                              password: 'GoodPassword',
                                              password_confirmation: 'GoodPassword',
                                              email: email } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end


  test 'successful edit with friendly forwarding' do 
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = 'GoodName'
    email = 'good@valid.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: 'GoodPassword',
                                              password_confirmation: 'GoodPassword' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
