class StoreController < ApplicationController
	skip_before_action :authorize
  def index
  	if params[:set_locale]
      redirect_to store_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end
  end


end
