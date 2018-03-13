// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require rails-ujs
//= require jquery
//= require turbolinks
//= require materialize-sprockets
//= require_tree .

$( document ).on('turbolinks:load', function() {
  $('select').material_select();
  $(".button-collapse").sideNav();
  $(".dropdown-button").dropdown({
    belowOrigin: true,
    alignment: 'left',
    inDuration: 200,
    outDuration: 150,
    constrain_width: true,
    hover: false,
    gutter: 1
  });
  $('ul.tabs').tabs();

  setTimeout(function(){
    $('.alert').parent().fadeOut();
  }, 5000);

  $('#accept-cookie').on('click', function() {
    document.cookie = 'eat_cookie=gnam';
    $('.toast-cookie-banner').fadeOut();
  });
});

$(document).on('turbolinks:load', function(){
    $('a#delete').click(function(event){
      event.preventDefault();
      $('div#confirm').show();
      $(this).hide();
    });

    $('a#cancel').click(function(event){
      event.preventDefault();
      $('div#confirm').hide();
      $('a#delete').show();
    });
});
