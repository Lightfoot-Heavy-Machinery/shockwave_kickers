require 'rails_helper'
# @routes = Rails.application.routes



# RSpec.configure do |config|
#   config.include Devise::Test::ControllerHelpers, type: :controller
# end


# def sign_in(user = double('user'))
#   if user.nil?
#     allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
#     allow(controller).to receive(:current_user).and_return(nil)
#   else
#     allow(request.env['warden']).to receive(:authenticate!).and_return(user)
#     allow(controller).to receive(:current_user).and_return(user)
#   end
# end

RSpec.describe StudentsController, type: :controller do
  describe "#index" do
    before do
      @user = User.create(email:'team_cluck_admin@gmail.com', password:'password', confirmed_at:Time.now)
      sign_in @user
      @course1 = Course.create(course_name:"CSCE 411", teacher:'team_cluck_admin@gmail.com', section:'501', semester:'Spring 2023')
      @course2 = Course.create(course_name:"CSCE 411", teacher:'team_cluck_admin@gmail.com', section:'501', semester:'Fall 2023')
      @course3 = Course.create(course_name:"CSCE 412", teacher:'team_cluck_admin@gmail.com', section:'501', semester:'Spring 2024')
      
      @student = Student.create(firstname:'Zebulun', lastname:'Oliphant', uin:'734826482', email:'zeb@tamu.edu', classification:'U2', major:'CPSC', teacher:'team_cluck_admin@gmail.com')
    end
    
    # around(:each) do |example|
    #   controller.class.skip_before_action :authenticate_user
    #   example.run
    #   controller.class.before_action :authenticate_user
    # end
    

    it "calls index successfully" do
      get :index, params: { id: @student }
      expect(response).to have_http_status(:redirect)
    end

    it "shows successfully" do
        get :show, params: { id: @student.id }
        expect(response).to have_http_status(:redirect)
    end


  end
end