class MentionController < ApplicationController
  def search
  	result = []

  	if params[:search_tag].present?
	  	firstname = params[:search_tag].to_s.split(/\s/)[0]
	  	lastname = params[:search_tag].to_s.split(/\s/)[1]

	    result = User.where("firstname like ? AND lastname like ?", "%#{firstname}%", "%#{lastname}%").each.inject([]) do |data, user|
	      data << {id: user.id, username: user.login, full_name: user.name, email: user.mail} unless user.locked?
	      data
	    end
	  end

    render json: {users: result}
  end
end