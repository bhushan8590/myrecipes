require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname:"bhushan", email:"bhushan@example.com", password:"password", password_confirmation:"password")
    @recipe = Recipe.create(name:"Vegitable saute", description:"this is a greate saute", chef:@chef)
    @recipe2 = @chef.recipes.build(name:"chicken saute", description:"this dish test good")
    @recipe2.save
  end

  test " should get recipes index " do
    get recipes_path
    assert_response :success
  end

  test " should get recipes listing " do
    get recipes_path
    assert_template "recipes/index"
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

  test " should get recipe show " do
    sign_in_as(@chef,"password")
    get recipe_path(@recipe)
    assert_template "recipes/show"
    assert_match @recipe.name.titleize, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
    assert_select "a[href=?]", recipes_path, text: "Back"
    assert_select "a[href=?]", edit_recipe_path(@recipe), text: "Edit Recipe"
    assert_select "a[href=?]", recipe_path(@recipe), text: "Delete Recipe"
  end

  test " create new valid recipe" do
    sign_in_as(@chef,"password")
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = 'chicken saute'
    description_of_recipe = 'add chiken and vegetables, cooked for 20 minutes'
    assert_difference 'Recipe.count',1 do
      post recipes_path params:{ recipe: {name:name_of_recipe, description:description_of_recipe}}
    end
    follow_redirect!
    assert_match name_of_recipe.titleize, response.body
    assert_match description_of_recipe, response.body
  end

  test " reject invalid recipe submission" do
    sign_in_as(@chef,"password")
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: {name:"", description:""} }
    end
    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
