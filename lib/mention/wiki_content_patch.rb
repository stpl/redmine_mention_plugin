module Mention
  module WikiContentPatch
    def self.included(base)
      base.send(:after_create) do |wiki_content|
        Mention.update_tag(wiki_content.text, wiki_content.page) if wiki_content.page.is_a?(WikiPage)
        Mailer.wiki_content_added(wiki_content).deliver if Setting.notified_events.include?('wiki_content_added')
      end

      base.send(:after_update) do |wiki_content|
        if wiki_content.text_changed?
          Mention.update_tag(wiki_content.text, wiki_content.page) if wiki_content.page.is_a?(WikiPage)
          Mailer.wiki_content_updated(wiki_content).deliver if Setting.notified_events.include?('wiki_content_updated')
        end
      end
    end
  end
end