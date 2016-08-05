require 'minitest/autorun'

module Kernel
  alias :require_unsafe :require
  def require(path)
    begin
      require_unsafe(path)
    rescue LoadError
    end
  end
  def require_dependency(path)
  end
end

require '../lib/mention'

class Setting
  @@value = "@username"
  def self.plugin_redmine_mention_plugin()
    { 'mentions' => @@value }
  end
  def self.set_new_syntax()
    @@value = "@username"
  end
  def self.set_old_syntax()
    @@value = "[~username]"
  end
end

# Setting.stub :plugin_redmine_mention_plugin['mentions'], "@username"

class TestMention < Minitest::Unit::TestCase
  def test_new_syntax_content_replace()
    Setting.set_new_syntax()
    test_cases = [
      [
        "Some @user.",
        "Some 'USER'."
      ],
      [
        "Some @user. and other @user.name.",
        "Some 'USER'. and other 'USER'."
      ],
      [
        "Here's @dobble.dotted.user. Hi @dobble.dotted.user!",
        "Here's 'USER'. Hi 'USER'!"
      ],
      [
        "Even more users: @user@mail.com, @user@user and @user@",
        "Even more users: 'USER', 'USER' and 'USER'@"
      ]
    ]
    test_cases.each do |test_case, sample|
      mentioned_users = Mention.scan_content(test_case)
      mentioned_users.each do |mentioned_user|
        test_case = Mention.update_content_for_username(test_case, mentioned_user[0], "'USER'")
      end
      assert_equal(sample, test_case)
    end
  end

  def test_old_syntax_content_replace()
    Setting.set_old_syntax()
    test_cases = [
      [
        "Some [~user].",
        "Some 'USER'."
      ],
      [
        "Some [~user]. and other [~user.name].",
        "Some 'USER'. and other 'USER'."
      ],
      [
        "Here's [~dobble.dotted.user]. Hi [~dobble.dotted.user]!",
        "Here's 'USER'. Hi 'USER'!"
      ],
      [
        "Even more users: [~user@mail.com], [~user@user] and [~user]@",
        "Even more users: 'USER', 'USER' and 'USER'@"
      ]
    ]
    test_cases.each do |test_case, sample|
      mentioned_users = Mention.scan_content(test_case)
      mentioned_users.each do |mentioned_user|
        test_case = Mention.update_content_for_username(test_case, mentioned_user[0], "'USER'")
      end
      assert_equal(sample, test_case)
    end
  end
  
end
