require "test_helper"

class UploadControllerTest < ActionDispatch::IntegrationTest

    setup do
      sign_in users(:userOne)
      @current_user = users(:userOne)
      require 'csv'
      require 'json'
    end

  test "should parse csv" do
        get "/upload/index#"
        assert_response :success
    end

  test "should get students" do
    CSV.foreach('./app/views/upload/test_data.csv', :headers => true) do |record|
        assert Student.find_by(firstname:record["FirstName"],
        lastname:record["LastName"],
        uin: record["UIN"],
        email: record["Email"],
        classification: record["Classification"],
        major: record["Major"],
        notes: record["Notes"],
        teacher: @current_user.email).nil?
        end
    end

  test "should get courses" do
      CSV.foreach('./app/views/upload/test_data.csv', :headers => true) do |record|
        assert Course.find_by(course_name: record["Course"], teacher: @current_user.email, section: record["Section"], semester: record["Semester"]).nil?
        end
    end
end
