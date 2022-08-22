class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    @friendship = Friendship.create(user: current_user, friend: friend)
    flash[:notice] = "#{friend.full_name} was successfully added to your friends"
    redirect_to my_friends_path
  end

  def destroy
    friend = User.find(params[:id])
    friendship = Friendship.where(user_id: current_user.id, friend_id: friend.id).first
    friendship.destroy
    flash[:notice] = "#{friend.full_name} was successfully removed from friends"
    redirect_to my_friends_path
  end
end
