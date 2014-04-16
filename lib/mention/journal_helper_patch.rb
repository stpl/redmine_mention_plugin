module Mention
  module JournalHelperPatch
    def self.included(base)
      base.class_eval do
        alias_method :render_notes_redmine, :render_notes
        def render_notes(issue, journal, options={})
          Mention.update_tag(render_notes_redmine(issue, journal, options)).html_safe
        end
      end
    end
  end
end