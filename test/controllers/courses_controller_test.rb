require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:userOne)
    @course = courses(:courseOne)
  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    assert_difference("Course.count") do
      post courses_url, params: { course: { course_name: @course.course_name, section: @course.section, semester: @course.semester} }
    end
    assert_redirected_to course_url(Course.last)
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
  end

  test "should update course" do
    patch course_url(@course), params: { course: { course_name: @course.course_name, section: @course.section, semester: @course.semester } }
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference("Course.count", -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end

  test "should get course index sign in page" do
    sign_out users(:userOne)
    get courses_url
    assert_response :redirect
  end

  test "should get new sign in page" do
    sign_out users(:userOne)
    get new_courses_url
    assert_response :redirect
  end
end
