// load the first set of posts

// IMPORTANT: Currently, this will insert duplicates 
// if more posts are submitted while scrolling.
// Instead of using page_num, switch to a date based system
// where max_date is increased after each set of posts are inserted
// then query should only go for posts with created_at > max_date


var page_num = 1;

get_posts(1, gon.post_params)

$(window).scroll(function () { 
	// append more posts once the bottom of the page is reached
	if ( $(window).scrollTop() >= ( $(document).height() - $(window).height() - 10 ) ) {
		page_num += 1;
		get_posts( page_num, gon.post_params );
	}
});


function get_posts(page_num, post_params){
	
	post_params['page_num'] = page_num;

	$.ajax({
	    type: 'GET',
	    dataType: 'html',
	    url: '/posts/post_loader',
	    data: post_params,
	    success: function(response_data) {
    		$('#contents').append(response_data);
	    },
	    error: function(XMLHttpRequest, textStatus, errorThrown) {
		    console.log(errorThrown);
		}
	});
}

