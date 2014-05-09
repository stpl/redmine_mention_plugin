class MentionController < ApplicationController
	def search
    result = User.with_name(params[:search_tag]).each.inject([]) do |data, user|
    						data << {id: user.id, username: user.login, full_name: user.name, email: user.mail}
						 end
    render json: {users: result}
	end
end