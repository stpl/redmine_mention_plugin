module Mention
  module WikiHelperPatch
    def self.included(base)
      base.class_eval do
        def textilizable_with_tags(content, field, sections_editable, page)
          content = textilizable content, :text, :attachments => content.page.attachments,:edit_section_links => (sections_editable && {:controller => 'wiki', :action => 'edit', :project_id => page.project, :id => page.title})
          Mention.update_tag(content).html_safe
        end
      end
    end
  end
end