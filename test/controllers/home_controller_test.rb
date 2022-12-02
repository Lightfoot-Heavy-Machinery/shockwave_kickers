class HomeControllerTest < ActionDispatch::IntegrationTest
    setup do
    end
  
    test "should get home index u1" do
      sign_in users(:userOne)
      get '/home/index'
      assert_response :success
    end

    test "should get home index u2" do
      sign_in users(:userTwo)
      get '/home/index'
      assert_response :success
    end

    test "should get home index u3" do
      sign_in users(:userThree)
      get '/home/index'
      assert_response :success
    end

    test "should get home index u4" do
      sign_in users(:userFour)
      get '/home/index'
      assert_response :success
    end

    test "should get home index u5" do
      sign_in users(:userFive)
      get '/home/index'
      assert_response :success
    end

    test "should get home index u6" do
      sign_in users(:userSix)
      get '/home/index'
      assert_response :success
    end

    test "should get home index u7" do
      sign_in users(:userSeven)
      get '/home/index'
      assert_response :success
    end

    test "should redirect home index" do
      sign_in users(:userOne)
      sign_out users(:userOne)
      get '/home/index'
      assert_redirected_to '/users/sign_in'
    end
end