//= require jquery3
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require adminlte/adminlte
//= require bootstrap-datetimepicker

$(document).ready(function(){
  $('.datetimepicker-delivery-time-at').datetimepicker( {
    format: 'yyyy-mm-dd hh:00',
    minView: 'day',
    maxView: 'year',
    autoclose: true,
    clearBtn: true,
    fontAwesome: true

  })
});


function prepare_search_params()
{
  var url = $('#exportBtn').attr( 'href');
  var query = $("#game_result_search").serialize();
  $('#exportBtn').attr( 'href', url+'?'+query);
}
