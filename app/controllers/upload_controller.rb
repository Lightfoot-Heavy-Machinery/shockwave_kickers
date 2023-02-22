class UploadController < ApplicationController
    before_action :authenticate_user!
    def index
    end
  
    def parse
      require 'zip'
      require 'csv'
      require 'securerandom'
  
      images = []
      csv = []
  
      #when a zip file is uploaded, unzip it
      Zip::File.open(params[:file]) do |zip_file|
        #if the zip file contains a csv file, parse it
        
        images_paths = []
        zip_file.each do |entry|

          if (entry.name.include? ".htm")
            #parse html doc for correct order of pictures, csv and images zip is mismatched but the html gets the order correct
            html_doc = Nokogiri::HTML(entry.get_input_stream.read)
            images_paths = html_doc.search('img/@src').map{ |s| s.text.strip }
            

          elsif (entry.name.include? ".csv")
            #parse
            csv = CSV.parse(entry.get_input_stream.read, headers: true) 
            Rails.logger.info "Collected all student courses #{csv.inspect}"
            #if the csv file contains empty rows, remove the offensive row
            csv.delete_if {|row| row.to_hash.values.all?(&:nil?)}
          end 

        end

        images_paths.each do |path|
          images.push(zip_file.find_entry(path))
        end



      end
      
      #if the number of rows in the csv file is equal to the number of images in the zip file, then proceed. Otherwise, throw an error
      if ((csv.length != 0) && (csv.length == images.length))
        #create course entry
        @course = Course.find_or_create_by(course_name: params[:course_temp], teacher: current_user.email, section: params[:section_temp], semester: params[:semester_temp])
        StudentCourse.where(course_id: @course.id).destroy_all

        csv.zip(images).each do |row, image|
          uuid = SecureRandom.uuid
  
          #if the columns are not null, then proceed
          Rails.logger.info "Collected student #{row.inspect}"
          if (row["FIRST NAME"] && row["LAST NAME"] && row["UIN"] && row["EMAIL"] && row["CLASSIFICATION"] && row["MAJOR"])
            @student = Student.where(uin: row["UIN"].strip(), teacher: current_user.email).first
            if !@student
              @student = Student.new(
                  firstname:row["FIRST NAME"].strip(),
                  lastname:row["LAST NAME"].strip(),
                  uin: row["UIN"].strip(),
                  email: row["EMAIL"].strip(),
                  classification: row["CLASSIFICATION"].strip(),
                  major: row["MAJOR"].strip(),
                  teacher: current_user.email,
                  last_practice_at: Time.now - 121.minutes,
                  curr_practice_interval: 120
              )
              @student.save
            else
              @student.update(
                  firstname:row["FIRST NAME"].strip(),
                  lastname:row["LAST NAME"].strip(),
                  uin: row["UIN"].strip(),
                  email: row["EMAIL"].strip(),
                  classification: row["CLASSIFICATION"].strip(),
                  major: row["MAJOR"].strip(),
                  teacher: current_user.email
              )
            end
            StudentCourse.find_or_create_by(course_id: @course.id, student_id:@student.id, final_grade:row["FINALGRADE"])
    
            Tempfile.open([uuid, ".jpg"]) do |tmp|
                image.extract(tmp.path) {true}
                @student.image.attach(io: File.open(tmp), filename: uuid)
            end
          else
            redirect_to upload_index_path, notice: "CSV column contents are different than expected. Please check the format of your CSV file."
            return
          end
        end
        redirect_to courses_url, notice: "Upload successful!"
      else
        redirect_to upload_index_path, notice: "Number of images does not match number of students"
      end
    end
end