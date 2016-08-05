require 'redmine'
require 'mention'

Rails.application.config.to_prepare do
  Mention.apply_patch
end

Redmine::Plugin.register :redmine_mention_plugin do
  name 'redmine_mention_plugin'
  author 'Systango'
  description 'Add user to watcher list after mentioning him/her (e.g. @john) in issue note and wiki'
  version '0.0.2'
  requires_redmine :version_or_higher => '2.2.4'
  settings :default => {'mentions' => '@username'}, :partial => 'settings/mention'

  require 'redmine_mention_plugin_hook_listener.rb'
end
