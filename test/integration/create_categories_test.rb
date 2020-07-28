require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "new", email: "new@example.com", password: "password", admin: true)
  end

  test "get new category form and create category" do
    sign_in_as(@user, "password")
    get new_category_path
    assert_template 'categories/new'
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: 'sports' } }
      follow_redirect!
    end
    assert_template 'categories/index'
    assert_match 'sports', response.body
  end

  test "invalid category submission result in failure" do
    sign_in_as(@user, "password")
    get new_category_path
    assert_template 'categories/new'
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: ' ' } }
    end
    assert_template 'categories/new'
    assert_select 'h2.panel-title' # look for the existence of the panel-title class from views/shared/_error.html.erb
    assert_select 'div.panel-body'
  end
end
