$(document).ready(function(){

  $('#post-submit-trigger').on('click', function() {
    $('#submit-modal').css('top', $(window).scrollTop());
    $('#submit-modal').slideDown(function() {
      $('#container').css('opacity', '0.1');
    });
  });

  $('#submit-modal .close-modal').on('click', function() {
    $('#submit-modal').slideUp('fast', function() {
      $('#container').css('opacity', '1');
    });
  });

  $('.school-selector').keyup(function(){
    var $this =  $(this)
    var name = $this.val();
    var $results = $this.parent().find('.school-suggesstion-box')
    if(name.length > 2) {
      $.ajax({
        type: 'GET',
        url: '/colleges/names',
        data: { name: name },
        success: function(data){
          $results.show();
          $results.html(data);
        }
      });
    }
  });

  $('.school-selection').on('click', '.school-name', function () {
    var $this = $(this);
    $('.new_post .btn-success').prop('disabled', false);
    var school = $this.html().trim();
    $this.closest('.school-selection').find('.school-selector').val(school);
    $this.closest('.school-suggesstion-box').slideUp('fast', function(){
      $this.empty();
    })
  })
});
