class UploadController < ApplicationController
    before_action :authenticate_user!
    def index
        require 'csv'
        require 'json'
        require 'securerandom'

        image_path_default = "./app/resources/pictures/test.jpeg"
        image_path = "./app/resources/pictures/"
        image_ext = ".jpeg"

        # course_ids = Course.where("course_name like ?", "%#{"CSCE 606"}%").pluck(:id)
        # @students = Student.where(course_id: course_ids)
        # @students.each do |s|
        #     s.image.purge_later
        #     s.destroy
        # end

        CSV.foreach('./app/resources/test_data.csv', :headers => true) do |record|
            uuid = SecureRandom.uuid

            @course = Course.find_or_create_by(course_name: record["Course"].strip(), teacher: current_user.email, section: record["Section"].strip(), semester: record["Semester"].strip())
            # @student = Student.find_or_create_by(
            #             firstname:record["FirstName"].strip(),
            #             lastname:record["LastName"].strip(),
            #             uin: record["UIN"].strip(),
            #             email: record["Email"].strip(),
            #             classification: record["Classification"].strip(),
            #             major: record["Major"].strip(),
            #             notes: record["Notes"].strip(),
            #             teacher: current_user.email
            #             )

            @student = Student.where(uin: record["UIN"].strip(), teacher: current_user.email).first
            Rails.logger.info "Collected all student courses #{@student.inspect}"
            if !@student
                Rails.logger.info "here all student courses #{@student.inspect}"
                @student = Student.new(
                    firstname:record["FirstName"].strip(),
                    lastname:record["LastName"].strip(),
                    uin: record["UIN"].strip(),
                    email: record["Email"].strip(),
                    classification: record["Classification"].strip(),
                    major: record["Major"].strip(),
                    notes: record["Notes"].strip(),
                    teacher: current_user.email
                )
                @student.save
            else
                @student.update(
                    firstname:record["FirstName"].strip(),
                    lastname:record["LastName"].strip(),
                    uin: record["UIN"].strip(),
                    email: record["Email"].strip(),
                    classification: record["Classification"].strip(),
                    major: record["Major"].strip(),
                    notes: record["Notes"].strip(),
                    teacher: current_user.email
                )
            end

            Rails.logger.info "Collected all student courses11 #{@student.inspect}"
            file_path = image_path + record["FirstName"] + image_ext
            if File.exist?(file_path)
                @student.image.attach(io: File.open(file_path, 'rb'), filename: uuid)
            else
                @student.image.attach(io: File.open(image_path_default, 'rb'), filename: uuid)
            end

            StudentCourse.find_or_create_by(course_id: @course.id, student_id:@student.id)

            if !@student.save
                puts("failed to save student")
            end

        end
    end
end
