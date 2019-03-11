class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    # @dogs = Dog.all

    @dogs = Dog.joins("LEFT OUTER JOIN likes ON likes.dog_id = dogs.id AND likes.created_at >= datetime('now', '-1 Hour')")
      .group("id")
      .order("COUNT(likes.id) DESC")
      .paginate(page: params[:page], per_page: 5)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
    @dog = Dog.find(params[:id])
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.user = current_user
    params[:dog][:images].each do |image|
      @dog.images.attach(image) 
    end
    respond_to do |format|
      if @dog.save
        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update    
    respond_to do |format|
      if @dog.user_id == current_user.id 
        if @dog.update(dog_params)
        
          @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?
          
          format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
          format.json { render :show, status: :ok, location: @dog }
        else
          
          format.html { render :edit }
          format.json { render json: @dog.errors, status: :unprocessable_entity }
        end

      else
        format.html { redirect_to @dog, notice: 'Cannot Edit a Dog that you do not own!' }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description)
    end
end
