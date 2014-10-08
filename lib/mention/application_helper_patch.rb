module Mention
  module ApplicationHelperPatch
    def self.included(base)
      base.class_eval do
        alias_method :textilizable_redmine, :textilizable
        def textilizable(*args)
          content = textilizable_redmine(*args)
          content = Mention.update_tag(content) if args[0].is_a?(Issue) and args[1].is_a?(Symbol) and args[1]==:description
          content.html_safe
        end
      end
    end
  end
end