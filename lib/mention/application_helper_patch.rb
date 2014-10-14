module Mention
  module ApplicationHelperPatch
    def self.included(base)
      base.class_eval do
        alias_method :textilizable_redmine, :textilizable
        def textilizable(*args)
          only_path = (args[2].nil? || args[2][:only_path].nil?)
          Mention.update_tag(textilizable_redmine(*args), nil, only_path).html_safe
        end

        alias_method :simple_format_without_paragraph_redmine, :simple_format_without_paragraph
        def simple_format_without_paragraph(text)
          Mention.update_tag(simple_format_without_paragraph_redmine(text)).html_safe
        end

        alias_method :format_activity_description_redmine, :format_activity_description
        def format_activity_description(text)
          Mention.update_tag(format_activity_description_redmine(text)).html_safe
        end
      end
    end
  end
end