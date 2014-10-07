module Mention
  module JournalPatch
    def self.included(base)
      base.send(:before_create) do |journal|
        if journal.journalized.is_a?(Issue) && journal.notes.present?
          issue = journal.journalized
          Mention.update_tag(journal.notes, issue)
        end
      end
    end
  end
end
