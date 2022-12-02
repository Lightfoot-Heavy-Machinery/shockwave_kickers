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
            #sort the csv file rows by FirstName and LastName alphabetically
            csv = CSV.parse(entry.get_input_stream.read, headers: true).sort_by { |row| [row['FirstName'], row['LastName']] }
            Rails.logger.info "Collected all student courses #{csv.inspect}"
  
            
          end 
        end
      end
      
      #move the last element in the image array to the front (to make sure that the first image belongs to the first student)
      images.unshift(images.pop)
  
      #if the number of rows in the csv file is equal to the number of images in the zip file, then proceed. Otherwise, throw an error
      if ((csv.length != 0) && (csv.length == images.length))
        csv.zip(images).each do |row, image|
          uuid = SecureRandom.uuid
  
          if ((row['FirstName']) && (row['LastName']) && (row['Email']) && (row['UIN']) && (row['Section']) && (row['Course']) && (row['Semester']) && (row['Classification']) && (row['Major']) && (row['Notes']))
            @course = Course.find_or_create_by(course_name: row["Course"].strip(), teacher: current_user.email, section: row["Section"].strip(), semester: row["Semester"].strip())
            @student = Student.where(uin: row["UIN"].strip(), teacher: current_user.email).first
            if !@student
              @student = Student.new(
                  firstname:row["FirstName"].strip(),
                  lastname:row["LastName"].strip(),
                  uin: row["UIN"].strip(),
                  email: row["Email"].strip(),
                  classification: row["Classification"].strip(),
                  major: row["Major"].strip(),
                  notes: row["Notes"].strip(),
                  teacher: current_user.email
              )
              @student.save
            else
              @student.update(
                  firstname:row["FirstName"].strip(),
                  lastname:row["LastName"].strip(),
                  uin: row["UIN"].strip(),
                  email: row["Email"].strip(),
                  classification: row["Classification"].strip(),
                  major: row["Major"].strip(),
                  notes: row["Notes"].strip(),
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
      elsif (csv.length != images.length)
        redirect_to upload_index_path, notice: "Number of images does not match number of students"
      else
        redirect_to upload_index_path, notice: "Upload unsuccessful- unforeseen error"
      end
    end
end
