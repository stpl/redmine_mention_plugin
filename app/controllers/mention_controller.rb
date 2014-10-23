class MentionController < ApplicationController
  def search
    issue_id = params[:issue_id]
    project_id = params[:project_id]
    users = []
    if project_id
      users = User.with_name(params[:search_tag]).includes(:members).where('members.project_id = ?', project_id)
    elsif issue_id
      users = User.with_name(params[:search_tag]).includes(members: {project: :issues}).where('issues.id = ?', issue_id)
    end
    result = users.each.inject([]) do |data, user|
      data << {id: user.id, username: user.login, full_name: user.name, email: user.mail} unless user.locked?
      data
    end
    render json: {users: result}
  end
end
