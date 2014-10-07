module Mention
  module IssuePatch
    def self.included(base)
      base.send(:before_create) do |issue|
        if issue.description.present?
          Mention.update_tag(issue.description, issue)
        end
      end
    end
  end
end
