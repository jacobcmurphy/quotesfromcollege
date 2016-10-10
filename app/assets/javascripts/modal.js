$(document).ready(function(){
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
