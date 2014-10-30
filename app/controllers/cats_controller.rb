class CatsController < ApplicationController
  before_action :require_logged_in
  before_action :require_cat_owner, only: [:edit, :update]
  
  def index
    @cats = Cat.all
    render :index
  end
  
  def show
    @cat = Cat.find(params[:id])
    render :show
  end
  
  def new
    @cat = Cat.new
    render :new
  end
  
  def create
    @cat = current_user.cats.new(cat_params)
    # @cat = Cat.new(cat_params)
    # @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end
  
  def update
    @cat = current_user.cats.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end
  
  def edit
    @cat = current_user.cats.find(params[:id])
    render :edit
  end
  
  private
    def cat_params
      params.require(:cat)
            .permit([:name, :birth_date, :sex, :description, :color])
    end
end
