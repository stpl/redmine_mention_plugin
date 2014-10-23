module Mention
  module IssueHelperPatch
    def self.included(base)
      base.class_eval do
        alias_method :textilizable_redmine, :textilizable
        def textilizable(*args)
          Mention.update_tag(textilizable_redmine(*args)).html_safe
        end
      end
    end
  end
end
