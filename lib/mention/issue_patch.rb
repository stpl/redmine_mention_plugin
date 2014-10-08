module Mention
  module IssuePatch
    def self.included(base)
      base.send(:before_create) do |issue|
        if issue.description.present?
          issue.watcher_user_ids += Mention.mentioned_users(issue.description).map do |user|
            user.id rescue nil
          end
        end
      end
    end
  end
end