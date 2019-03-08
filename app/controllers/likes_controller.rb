class LikesController < ApplicationController

  def create
    Like.create(user_id: current_user.id, dog_id: params[:dog_id]);
    redirect_to dogs_url
  end

  def destroy
    like = Like.find_by(id: params[:id]);
    like.destroy
    redirect_to dogs_url
  end

end