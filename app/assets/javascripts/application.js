// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require growlyflash
//= require data-confirm-modal
//= require nested_form_fields
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
  //Activate the layout maker
  $.AdminLTE.layout.activate();
  sidebar("show")
  init_assignee_filter()
  $(".overlay-loader").hide();
});

$(document).on('turbolinks:request-start', function(){ $(".overlay-loader").show(); });

$(document).on("click", ".sidebar-toggle", function(){ sidebar("toggle"); });

// Growl setup
jQuery(function() {
  $(document).on('click.alert.data-api', '[data-dismiss="alert"]', function(e) {
    return e.stopPropagation();
  });
  return $(document).on('touchstart click', ".bootstrap-growl", function(e) {
    e.stopPropagation();
    $('[data-dismiss="alert"]', this).click();
    return false;
  });
});

Growlyflash.KEY_MAPPING = $.extend(true, {}, Growlyflash.KEY_MAPPING, 
  {
    warning:   'warning',
    error:   'danger',
    notice:  'info',
    success: 'success'
});

function sidebar(action){
  if(action === "toggle"){
    sidebar($(".sidebar").is(":visible") ? "hide" : "show");
  }else if(action === "show"){
    $(".sidebar").show();
    if ($(".sidebar-form").length) {
      $(".content-wrapper").css("margin-left", "230px");
    }else{
      $('a.sidebar-toggle').hide()
    }
  }else if(action === "hide"){
    $('a.sidebar-toggle').show()
    $(".sidebar").hide();
    $(".content-wrapper").css("margin-left", "0px");
  }
}

function init_assignee_filter(){
  $(".assignee-filter").change(function(){
    $("#params-for-submit input[type='hidden']").each(function(){ $(this).remove(); });
    if($(this).val() !== ''){
      var hidden = "<input type='hidden' value='"+$(this).val()+"' name='assignee_id'>";
      $("#params-for-submit").append(hidden);
    }
    $(".sidebar-form").submit();
  });
}
