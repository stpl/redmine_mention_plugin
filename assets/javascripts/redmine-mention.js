$(function () {

  $('.controller-issues textarea.wiki-edit, .controller-wiki textarea.wiki-edit').mentionsInput({
    onDataRequest:function (mode, query, callback) {
      var data = [];
      $.ajax({
        url: '/mention/search',
        data: {'search_tag': query},
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