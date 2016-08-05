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

class TestMention < Minitest::Unit::TestCase
  def test_content_replace()
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
      assert_equal(test_case, sample)
    end
  end
end
