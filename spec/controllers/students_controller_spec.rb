require 'rails_helper'

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