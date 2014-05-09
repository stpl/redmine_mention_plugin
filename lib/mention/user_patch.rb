require_dependency 'user'

module Mention
  module UserPatch
    def self.included(base)
      base.class_eval do
        unloadable

        scope :with_name,->(name) { where('LCASE(CONCAT(firstname," ",lastname)) like ?', "#{name.downcase}%")}
      end
    end
  end
end
