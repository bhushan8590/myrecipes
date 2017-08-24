require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname:"bhushan", email:"bhushan@example.com")
    @recipe = Recipe.create(name:"Vegitable saute", description:"this is a greate saute", chef:@chef)
    @recipe2 = @chef.recipes.build(name:"chiken saute", description:"this dish test good")
    @recipe2.save
  end

  test " should get recipes index " do
    get recipes_path
    assert_response :success
  end

  test " should get recipes listing " do
    get recipes_path
    assert_template "recipes/index"
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end
end
