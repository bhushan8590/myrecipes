require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname:"bhushan", email:"bhushan@example.com", password:"password", password_confirmation:"password")
    @chef2 = Chef.create!(chefname:"bhushan1", email:"bhushan1@example.com", password:"password", password_confirmation:"password")
    @admin_chef = Chef.create!(chefname:"bhushan2", email:"bhushan2@example.com", password:"password", password_confirmation:"password", admin: true)
  end

  test "reject invalid edit" do
    sign_in_as(@chef,"password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params:{chef: {chefname: " ", email:"bhushan@example.com"}}
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "accept valid edit" do
    sign_in_as(@chef,"password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params:{chef: {chefname: "bhushanpatil", email:"bhushanp@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "bhushanpatil", @chef.chefname
    assert_match "bhushanp@example.com", @chef.email
  end

  test "accept edit attempt by admin" do
    sign_in_as(@admin_chef,"password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params:{chef: {chefname: "bhushanpatil1", email:"bhushanp1@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "bhushanpatil1", @chef.chefname
    assert_match "bhushanp1@example.com", @chef.email
  end

  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2,"password")
    updated_name = "name"
    updated_email = "name@example.com"
    patch chef_path(@chef), params:{chef: {chefname: updated_name, email:updated_email}}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "bhushan", @chef.chefname
    assert_match "bhushan@example.com", @chef.email
  end
end
