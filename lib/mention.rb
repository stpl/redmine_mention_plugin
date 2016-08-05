require_dependency 'application_helper'
require_dependency 'issue'
require_dependency 'watcher'
require_dependency 'wiki_page'
require_dependency 'user'
require 'mention/journal_patch'
require 'mention/user_patch'
require 'mention/journal_helper_patch'
require 'mention/wiki_helper_patch'
require 'mention/wiki_content_patch'
require 'mention/issue_patch'
require 'mention/application_helper_patch'

module Mention
  
  def self.update_tag(content, watchable=nil, only_path=true)
    mentioned_users = scan_content(content)
    mentioned_users.each do |mentioned_user|
      if user = User.find_by_login(mentioned_user[0])
        if watchable.is_a?(Issue) or watchable.is_a?(WikiPage)
          Watcher.create(:watchable => watchable, :user => user)
        else
          url_for_options = {:controller => 'users', :action => 'show', :id => user.id, :only_path => only_path}
          url_for_options = url_for_options.merge(Mailer.default_url_options) unless only_path
          content = self.update_content_for_username(content, mentioned_user[0], "<a class='user active' href='#{Rails.application.routes.url_helpers.url_for(url_for_options)}'>#{user.name}</a>")
        end
      end
    end
    content
  end
  
  def self.mention_settings_list()
    mention_settings().keys
  end
  
  def self.mention_settings(username="", replacement="")
    {
      '@username' => {
        'search_regex'  => /@([\w.-@]+\w)/,
        'replace_regex' => /@#{username}($|\W(\s|$)|[^\w.+-@])/,
        'replacement'   => "#{replacement}\\1"
      },
      '[~username]' => {
        'search_regex'  => /\[~([\w.-@]+\w)\]/,
        'replace_regex' => /\[~#{username}\]/,
        'replacement'   => replacement
      }
    }
  end
  
  def self.regex_settings(username="", replacement="")
    mention_settings(username, replacement)[Setting.plugin_redmine_mention_plugin['mentions']]
  end
  
  def self.scan_content(content)
    content.scan(regex_settings()['search_regex'])
  end
  
  def self.update_content_for_username(content, username, replacement)
    regexps = regex_settings(username, replacement)
    content.gsub(regexps['replace_regex'], regexps['replacement'])
  end

  def self.mentioned_users(content)
    content.scan(regex_settings()['search_regex']).map do |mentioned_user|
      User.find_by_login(mentioned_user[0])
    end
  end

  def self.apply_patch
    Journal.send(:include, Mention::JournalPatch)
    User.send(:include, Mention::UserPatch)
    Issue.send(:include, Mention::IssuePatch)
    JournalsHelper.send(:include, Mention::JournalHelperPatch)
    WikiHelper.send(:include, Mention::WikiHelperPatch)
    ApplicationHelper.send(:include, Mention::ApplicationHelperPatch)
    WikiContent.send(:include, Mention::WikiContentPatch)
  end
end