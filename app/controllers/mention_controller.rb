class MentionController < ApplicationController
  def search
    issue_id = params[:issue_id]
    project_identifier = params[:project_identifier]
    users = []
    if project_identifier
      users = User.with_name(params[:search_tag]).includes(members: :project).where('projects.identifier = ?', project_identifier)
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
