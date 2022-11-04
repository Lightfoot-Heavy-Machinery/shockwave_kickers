class UploadController < ApplicationController
    before_action :authenticate_user!
    def index
        require 'csv'
        require 'json'
        require 'securerandom'

        image_paths = []
        # image_path = "./app/resources/pictures/test.jpeg"
        image_path = "./app/resources/pictures/test"
        image_ext = ".jpeg"
        (0..20).each do |v|
            if v == 0
                image_paths.append(image_path+""+image_ext)
            else
                image_paths.append(image_path+v.to_s+image_ext)
            end
        end

        count = 0

        CSV.foreach('./app/resources/test_data.csv', :headers => true) do |record|
            uuid = SecureRandom.uuid

            @course = Course.find_or_create_by(course_name: record["Course"], teacher: current_user.email, section: record["Section"], semester: record["Semester"])
            @student = Student.find_or_create_by(
                        firstname:record["FirstName"],
                        lastname:record["LastName"],
                        uin: record["UIN"],
                        email: record["Email"],
                        classification: record["Classification"],
                        major: record["Major"],
                        notes: record["Notes"],
                        course_id: @course.id,
                        teacher: current_user.email
                        )
            
            # @student.image.attach(io: File.open(image_path, 'rb'), filename: uuid)
            if count < image_paths.length()
                @student.image.attach(io: File.open(image_paths[count], 'rb'), filename: uuid)
            else
                @student.image.attach(io: File.open(image_paths[0], 'rb'), filename: uuid)
            end
            count = count + 1

            if !@student.save
                puts("failed to save student")
            end

        end
    end
end
