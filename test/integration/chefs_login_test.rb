require 'test_helper'

class ChefsLoginTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname:"bhushan", email:"bhushan@example.com", password:"password", password_confirmation:"password")
  end

  test " should reject invalid login" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params:{session: {email:"", password:""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count:0
    get root_path
    assert flash.empty?
  end

  test " valid credentials accepted and begin session" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params:{session: {email:"bhushan@example.com", password:"password"}}
    assert_redirected_to @chef
    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
    assert_select 'a[href=?]', login_path, count:0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', chef_path(@chef)
    assert_select 'a[href=?]', edit_chef_path(@chef)
  end
end
