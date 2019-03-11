class LikesController < ApplicationController

  def create
    Like.create(user_id: current_user.id, dog_id: params[:dog_id]);
    redirect_to dog_url(params[:dog_id])
  end

  def destroy
    like = Like.find_by(id: params[:id]);
    like.destroy
    redirect_to dog_url(params[:dog_id])
  end

end