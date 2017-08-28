require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname:"bhushan", email:"bhushan@example.com")
    @recipe = Recipe.create(name:"Vegitable saute", description:"this is a greate saute", chef:@chef)
  end

  test "reject invalid recipe update" do
    get edit_recipe_path(@recipe)
    assert_template "recipes/edit"
    patch recipe_path(@recipe), params:{ recipe: {name:"", description:"description of recipe"}}
    assert_template "recipes/edit"
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "Successfully edit recipe" do
    get edit_recipe_path(@recipe)
    assert_template "recipes/edit"
    updated_name = "Name of recipe"
    updated_description = "description of recipe"
    patch recipe_path(@recipe), params:{ recipe: {name:updated_name , description:updated_description}}
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end
end
