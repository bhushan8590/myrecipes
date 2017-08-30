require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname:"bhushan", email:"bhushan@example.com", password:"password", password_confirmation:"password")
    @recipe = Recipe.create(name:"Vegitable saute", description:"this is a greate saute", chef:@chef)
    @recipe2 = @chef.recipes.build(name:"chicken saute", description:"this dish test good")
    @recipe2.save
  end

  test " should get chef show" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text:@recipe.name
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
  end
end
