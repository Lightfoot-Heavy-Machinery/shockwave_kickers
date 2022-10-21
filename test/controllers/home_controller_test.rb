class HomeControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:userOne)
    end
  
    test "should get home index" do
      get '/home/index'
      assert_response :success
    end

    test "should redirect home index" do
        sign_out users(:userOne)
        get '/home/index'
        assert_response :success
    end
end