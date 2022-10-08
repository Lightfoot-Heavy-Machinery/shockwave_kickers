require "test_helper"

class SemestersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @semester = semesters(:one)
    end

    test "should get index" do
      get semesters_url
      assert_response :success
    end

    test "should get new" do
      get new_semester_url
      assert_response :success
    end

    test "should create semester" do
      assert_difference("Semester.count") do
        post semesters_url, params: { semester: { name: @semester.name, courses: @semester.courses}}
      end

    end

    test "should show course" do
      get semester_url(@semester)

    end

    test "should get edit" do
      get edit_semester_url(@semester)
      assert_response :success
    end

    test "should update semester" do
      patch semester_url(@semester), params: { semester: {name: @semester.name, courses: @semester.courses}}
      assert_redirected_to semester_url(@semester)
    end


    test "should destroy semester" do
      assert_difference("Semester.count", -1) do
        delete semester_url(@semester)
      end
    end
  end
