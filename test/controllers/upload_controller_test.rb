require "test_helper"

class UploadControllerTest < ActionDispatch::IntegrationTest

    setup do
      sign_in users(:userOne)
      @current_user = users(:userOne)
      require 'csv'
      require 'json'
    end

  test "should call index" do
        get "/upload/index#"
        assert_response :success
    end

  test "should redirect upload" do
        sign_out users(:userOne)
        get "/upload/index#"
        assert_redirected_to '/users/sign_in'
  end

  test "should parse file uploaded" do
    require 'zip'
    Zip::File.open('./app/resources/ProfRitchey_Template.zip') do |zip_file|
        post "/upload/index#", params:  {file: zip_file, course_temp: "CSCE 606", section_temp: "001", semester_temp: "Spring 2020"}
        assert_redirected_to courses_url
    end
  end


  test "should parse file uploaded failed" do
    require 'zip'
    Zip::File.open('./app/resources/Wrong_Cols.zip') do |zip_file|
        post "/upload/index#", params: {file: zip_file, course_temp: "CSCE 606", section_temp: "001", semester_temp: "Spring 2020"}
        assert_redirected_to "/upload/index"
    end
  end
end
