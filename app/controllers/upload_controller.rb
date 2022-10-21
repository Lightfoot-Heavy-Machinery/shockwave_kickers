class UploadController < ApplicationController
    before_action :authenticate_user!
    def index
        require 'csv'
        require 'json'

        CSV.foreach('./app/views/upload/test_data.csv', :headers => true) do |record|

            @course = Course.find_or_create_by(course_name: record["Course"], teacher: current_user.email, section: record["Section"], semester: record["Semester"])
            @student = Student.find_or_create_by(
                        firstname:record["FirstName"],
                        lastname:record["LastName"],
                        uin: record["UIN"],
                        email: record["Email"],
                        classification: record["Classification"],
                        major: record["Major"],
                        notes: record["Notes"],
                        course_id: @course.id)

            if !@student.save
                puts("failed to save student")
            end
        end
    end
end
