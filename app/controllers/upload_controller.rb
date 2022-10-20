class UploadController < ApplicationController
    def new

    end

    def index
        require 'csv'
        require 'json'

        data = File.open('/Users/rahulshah/Documents/Fall 2022/CSCE 606/shockwave_kickers/app/views/upload/test_data.csv').read()
        json = CSV.parse(data).to_a
        CSV.foreach('/Users/rahulshah/Documents/Fall 2022/CSCE 606/shockwave_kickers/app/views/upload/test_data.csv', :headers => true) do |record|

            @course = Course.find_or_create_by(course_name: record["Course"], teacher: "testUser", section: record["Section"], semester: record["Semester"])
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
