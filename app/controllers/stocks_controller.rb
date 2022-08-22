class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock].upcase)
      if @stock
        respond_to do |format|
          format.js { render partial: 'users/result' }
        end
      else
        alert_invalid_search
      end
    else
      alert_invalid_search
    end
  end

  private

  def alert_invalid_search
    respond_to do |format|
      flash.now[:alert] = 'Please enter a valid symbol to search'
      format.js { render partial: 'users/result' }
    end
  end

end
