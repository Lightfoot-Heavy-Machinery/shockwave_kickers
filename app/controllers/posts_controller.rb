class PostsController < ApplicationController
  before_action :authenticate_user!

  #QUESTION ON LINE 101ish
  #why doesn't it push kunal? (It does not matter where he is in the array)

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  #THIS IS ALL DONE IN UPLOAD_CONTROLLER, I JUST NEED TO COPY AND CALL IT
  def parse
    require 'zip'
    require 'csv'
    require 'securerandom'

    course_ids = Course.where("course_name like ?", "%#{"CSCE 606"}%").pluck(:id)
    @students = Student.where(course_id: course_ids)
    images = []
    csv = []

    @students.each do |s|
        s.image.purge_later
        s.destroy
    end

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

          #move the last element in the image array to the front
        end 
      end
    end

    images.unshift(images.pop)
    puts images[0]

    #if the number of rows in the csv file is equal to the number of images in the zip file, then proceed. Otherwise, throw an error
    if ((csv.length != 0) && (csv.length == images.length))
      csv.zip(images).each do |row, image|
        uuid = SecureRandom.uuid
      #for each image in the zip file, if the image name contains a number, rename it to firstname_lastname.jpeg in the current row
      #images.each do |image|
        #get the first name and last name from the current row
        #first_name = csv[images.index(image)]['FirstName']
        #last_name = csv[images.index(image)]['LastName']
        #ASK KUNAL WHY THIS COMPLAINS
        #zip_file.rename(image, first_name + "_" + last_name + ".jpeg")
      #end

      #for every row in the sorted csv file, post a new student to the database
      #csv.each do |row|

        #if row contains all the necessary columns, keep going.
        if ((row['FirstName']) && (row['LastName']) && (row['Email']) && (row['UIN']) && (row['Section']) && (row['Course']) && (row['Semester']) && (row['Classification']) && (row['Major']) && (row['Notes']))
          #puts(row)
          #Rails.logger.info "Collected all student courses #{@student.inspect}"
          @course = Course.find_or_create_by(course_name: row["Course"].strip(), teacher: current_user.email, section: row["Section"].strip(), semester: row["Semester"].strip())
          @student = Student.where(uin: row["UIN"].strip(), course_id: row["Course"], teacher: current_user.email).first
          if !@student
            Rails.logger.info "here all student courses #{@student.inspect}"
            @student = Student.new(
                firstname:row["FirstName"].strip(),
                lastname:row["LastName"].strip(),
                uin: row["UIN"].strip(),
                email: row["Email"].strip(),
                classification: row["Classification"].strip(),
                major: row["Major"].strip(),
                notes: row["Notes"].strip(),
                teacher: current_user.email,
                course_id: @course.id
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
                teacher: current_user.email,
                course_id: @course.id
            )
          end
          tempfile = Tempfile.new(File.basename(image.name))
          tempfile.binmode
          tempfile.write(image.get_input_stream.read)
          @student.image.attach(io: File.open(tempfile), filename: uuid)
          tempfile.close
        else
          redirect_to posts_index_path, notice: "CSV column contents are different than expected. Please check the format of your CSV file."
          break
        end
      end
      redirect_to posts_index_path, notice: "Upload successful!"
    elsif (csv.length != images.length)
      redirect_to posts_index_path, notice: "Number of images does not match number of students"
    else
      redirect_to posts_index_path, notice: "Upload unsuccessful- unforeseen error"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:file])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:file)
    end
end