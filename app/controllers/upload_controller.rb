class UploadController < ApplicationController
    before_action :authenticate_user!
    def index
    end
  
    #THIS IS ALL DONE IN UPLOAD_CONTROLLER, I JUST NEED TO COPY AND CALL IT
    def parse
      require 'zip'
      require 'csv'
      require 'securerandom'
  
      images = []
      csv = []
  
      #when a zip file is uploaded, unzip it
      Zip::File.open(params[:file]) do |zip_file|
        #if the zip file contains a csv file, parse it
        zip_file.each do |entry|
          if ((entry.name.include? ".jpeg") || (entry.name.include? ".jpg") || (entry.name.include? ".png"))
            images.push(entry)
          elsif (entry.name.include? ".csv")
            #sort the csv file rows by FIRST NAME and LAST NAME alphabetically
            csv = CSV.parse(entry.get_input_stream.read, headers: true).sort_by { |row| [row['FIRST NAME'], row['LAST NAME']] }
            Rails.logger.info "Collected all student courses #{csv.inspect}"
            #if the csv file contains empty rows, remove the offensive row
            csv.delete_if {|row| row.to_hash.values.all?(&:nil?)}
          end 
        end
      end
      
      #move the last element in the image array to the front (to make sure that the first image belongs to the first student)
      images.unshift(images.pop)
  
      #if the number of rows in the csv file is equal to the number of images in the zip file, then proceed. Otherwise, throw an error
      if ((csv.length != 0) && (csv.length == images.length))
        csv.zip(images).each do |row, image|
          uuid = SecureRandom.uuid

          @course_temp = Course.where(params[:course_temp], teacher: current_user.email)
          @semester_temp = Course.where(params[:semester_temp], teacher: current_user.email)
          @section_temp = Course.where(params[:section_temp], teacher: current_user.email)
  
          if (row["FIRST NAME"].strip() && row["LAST NAME"].strip() && row["UIN"].strip() && row["EMAIL"].strip() && row["CLASSCODE"].strip() && row["MAJOR"].strip())
            @course = Course.find_or_create_by(course_name: @course_temp, teacher: current_user.email, section: @section_temp, semester: @semester_temp)
            @student = Student.where(uin: row["UIN"].strip(), teacher: current_user.email).first
            if !@student
              @student = Student.new(
                  firstname:row["FIRST NAME"].strip(),
                  lastname:row["LAST NAME"].strip(),
                  uin: row["UIN"].strip(),
                  email: row["EMAIL"].strip(),
                  classification: row["CLASSCODE"].strip(),
                  major: row["MAJOR"].strip(),
                  final_grade: row["FINALGRADE"].strip(),
                  teacher: current_user.email
              )
              @student.save
            else
              @student.update(
                  firstname:row["FIRST NAME"].strip(),
                  lastname:row["LAST NAME"].strip(),
                  uin: row["UIN"].strip(),
                  email: row["EMAIL"].strip(),
                  classification: row["CLASSCODE"].strip(),
                  major: row["MAJOR"].strip(),
                  final_grade: row["FINALGRADE"].strip(),
                  teacher: current_user.email
              )
            end

            StudentCourse.find_or_create_by(course_id: @course.id, student_id:@student.id)
    
            tempfile = Tempfile.new(File.basename(image.name))
            tempfile.binmode
            tempfile.write(image.get_input_stream.read)
            @student.image.attach(io: File.open(tempfile), filename: uuid)
            tempfile.close
          else
            redirect_to upload_index_path, notice: "CSV column contents are different than expected. Please check the format of your CSV file."
            break
          end
        end
        redirect_to courses_url, notice: "Upload successful!"
      else
        redirect_to upload_index_path, notice: "Number of images does not match number of students"
      end
    end
end