// load the first set of posts
var infiniteScroller = {
  addScrollWatcher: function() {
    var scroller = this;
    $(window).scroll(function () { 
      if ( $(window).scrollTop() >= ( $(document).height() - $(window).height() - 10 ) ) {
        scroller.getPosts();
      }
    });
  },

  getPosts: function() {
    $.ajax({
        type: 'GET',
        dataType: 'html',
        url: '/posts/post_loader',
        success: function(response_data) {
          $('#contents').append(response_data);
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          console.log(errorThrown);
      }
    });
  }
}
