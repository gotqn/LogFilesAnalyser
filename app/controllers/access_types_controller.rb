class AccessTypesController < ApplicationController
  before_action :set_access_type, only: [:show, :edit, :update, :destroy]

  # GET /access_types
  # GET /access_types.json
  def index
    @access_types = AccessType.all
  end

  # GET /access_types/1
  # GET /access_types/1.json
  def show
  end

  # GET /access_types/new
  def new
    @access_type = AccessType.new
  end

  # GET /access_types/1/edit
  def edit
  end

  # POST /access_types
  # POST /access_types.json
  def create
    @access_type = AccessType.new(access_type_params)

    respond_to do |format|
      if @access_type.save
        format.html { redirect_to @access_type, notice: 'Access type was successfully created.' }
        format.json { render :show, status: :created, location: @access_type }
      else
        format.html { render :new }
        format.json { render json: @access_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /access_types/1
  # PATCH/PUT /access_types/1.json
  def update
    respond_to do |format|
      if @access_type.update(access_type_params)
        format.html { redirect_to @access_type, notice: 'Access type was successfully updated.' }
        format.json { render :show, status: :ok, location: @access_type }
      else
        format.html { render :edit }
        format.json { render json: @access_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /access_types/1
  # DELETE /access_types/1.json
  def destroy
    @access_type.destroy
    respond_to do |format|
      format.html { redirect_to access_types_url, notice: 'Access type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_type
      @access_type = AccessType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def access_type_params
      params.require(:access_type).permit(:name, :description)
    end
end
