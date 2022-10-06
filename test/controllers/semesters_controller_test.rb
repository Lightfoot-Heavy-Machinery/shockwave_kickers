require "test_helper"

class SemestersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get semesters_index_url
    assert_response :success
  end

  test "should get show" do
    get semesters_show_url
    assert_response :success
  end

  test "should get new" do
    get semesters_new_url
    assert_response :success
  end

  test "should get edit" do
    get semesters_edit_url
    assert_response :success
  end
end
