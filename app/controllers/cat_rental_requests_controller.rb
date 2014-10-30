class CatRentalRequestsController < ApplicationController
  before_action :require_cat_owner, only: [:approve, :deny]
    
  def create
    @cat_rental_request = CatRentalRequest.new(rental_params)
    @cat_rental_request.user_id = current_user.id
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :new
    end
  end
  
  def destroy
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.destroy
    redirect_to cats_url
  end
  
  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end
  
  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    redirect_to cat_url(@cat_rental_request.cat)
  end
  
  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    
    @cat_rental_request.deny!
    redirect_to cat_url(@cat_rental_request.cat)
  end
  
  private
    def rental_params
      params.require(:cat_rental_request)
            .permit([:start_date, :end_date, :cat_id])
    end
end