require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar"}}
    end
    assert_response :unprocessable_entity
    # /users/new.html.erb が描画されているかどうかを検証する
    assert_template 'users/new'
    # アクション実行後に描写されるHTML要素内に、キーが存在するかどうかを検証する
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end

  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post users_path, params: {user: { name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password"}}

    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    # assert_not flash.empty?
  end
end
