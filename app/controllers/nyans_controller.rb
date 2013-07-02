class NyansController < ApplicationController

	def index
		@zip = params[:zip]

		respond_to do |format|
			format.html
			format.json { render json: {zip: @zip} }
		end
	end

end