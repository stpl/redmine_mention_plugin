class RedmineMentionPluginHookListener < Redmine::Hook::ViewListener
  render_on :view_layouts_base_html_head, :partial => 'shared/mention_css_js'
end
