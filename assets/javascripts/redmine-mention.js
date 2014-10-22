$(function () {
  var issue_regex_match = location.href.match(/\/issues\/(.*)\?/);
  var issue_id = issue_regex_match ? issue_regex_match[1] : false;
  var project_regex_match = location.href.match(/\/projects\/(.*)\/issues/) || location.href.match(/\/projects\/(.*)\/wiki/);
  var project_identifier = project_regex_match ? project_regex_match[1] : false;
  $('.controller-issues textarea.wiki-edit, .controller-wiki textarea.wiki-edit').mentionsInput({
    onDataRequest:function (mode, query, callback) {
      var data = [];
      var request_data = {'search_tag': query};
      if (issue_id) {
        request_data['issue_id'] = issue_id;
      }
      if (project_identifier) {
        request_data['project_identifier'] = project_identifier;
      }
      $.ajax({
        url: '/mention/search',
        data: request_data,
        success: function(result) {
          callback.call(this, result['users']);
        }
      });
    },
    minChars      : 1,
    templates     : {
      autocompleteList           : _.template('<div class="mentions-autocomplete-list"></div>'),
      autocompleteListItem       : _.template('<li data-ref-id="<%= id %>" data-display="<%= display %>"><%= name + " - " + email + " (" +content + ")"%></li>'),
      mentionsOverlay            : _.template('<div class="mentions"><div></div></div>'),
      mentionItemSyntax          : _.template('@[<%= value %>](<%= id %>)'),
      mentionItemHighlight       : _.template('<strong><span><%= value %></span></strong>')
    }
  });
});