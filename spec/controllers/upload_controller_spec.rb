require 'rails_helper'

RSpec.describe UploadController, type: :controller do
  describe "#parse" do
    before(:each) do
      @user = User.create(email: "test@example.com", password: "password", confirmed_at: Time.now)
      sign_in @user
      @course = Course.create(course_name: "test course", teacher: @user.email, section: "999", semester: "Fall 2000")
    end
  
    context "with valid file and contents" do
      it "creates a new course and student entries" do
        file = fixture_file_upload('ProfRitchey_Template.zip', 'application/zip')
        params = { file: file, course_temp: @course.course_name, section_temp: @course.section, semester_temp: @course.semester }
        expect { post :parse, params: params }.to change(Course, :count).by(0)
        kunal = Student.find_by firstname: 'Kunal'
        expect(kunal.firstname).to eq('Kunal')
        expect(flash[:notice]).to eq("Upload successful!")
      end
    end
  
  end
end