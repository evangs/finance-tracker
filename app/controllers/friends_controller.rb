class FriendsController < ApplicationController
  def search
    if params[:friend].present?
      @users = current_user.search(params[:friend])
      if @users.count > 0
        respond_to do |format|
          format.js { render partial: 'friends/result' }
        end
      else
        alert_invalid_search('No matching results found')
      end
    else
      alert_invalid_search('Invalid search, please enter a search term')
    end
  end

  private

  def alert_invalid_search(message)
    respond_to do |format|
      flash.now[:alert] = message
      format.js { render partial: 'friends/result' }
    end
  end
end
