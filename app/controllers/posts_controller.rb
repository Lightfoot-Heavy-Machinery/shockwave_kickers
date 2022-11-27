class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

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
    require 'zip'
    require 'csv'
    require 'json'

    @post = Post.new(post_params)
    @post.published_at = Time.zone.now if published?

    respond_to do |format|
      if @post.save
        @post.update(published_at: Time.zone.now) if published?
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    
    # Extract the zip file
    Zip::File.open(@post.file.path) do |zip_file|
      # Handle entries one by one
      zip_file.each do |entry|
        # Extract to file/directory/symlink
        puts "Extracting #{entry.name}"
        entry.extract("app/resources/#{entry.name}")
        #if the file is a csv file, make a list of the names of the students in alphabetical order
        if entry.name.include? ".csv"
            CSV.foreach("app/resources/#{entry.name}", :headers => true) do |record|
                @student_names = Array.new
                @student_names.push(record["FirstName"].strip() + " " + record["LastName"].strip())
            end
            #for every png, jpg, or jpeg file in the zip file, add the student name to the file name
            Dir.glob("app/resources/*.jpeg").each do |file|
                @student_names.each do |name|
                    if file.include? name
                        File.rename(file, file.gsub(name, name.gsub(" ", "_")))
                    end
                end
            end
        end
        #if the file is not a csv or image file, delete it
        if ((!entry.name.include? ".csv") || (!entry.name.include? ".jpeg") || (!entry.name.include? ".jpg") || (!entry.name.include? ".png"))
          File.delete("app/resources/#{entry.name}")
        end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:file)
    end

    def published?
      @post.published?
    end
end