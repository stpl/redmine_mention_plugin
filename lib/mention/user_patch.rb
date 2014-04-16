require_dependency 'user'

module Mention
  module UserPatch
    def self.included(base)
      base.class_eval do
        unloadable

        scope :with_username,->(username) { where('LCASE(login) like ?', "#{username.downcase}%")}
      end
    end
  end
end
