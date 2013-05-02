// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require ideas/popover

//= require jquery.tokeninput
//= require jquery-ui
//= require jquery_purr
//= require best_in_place
//= require bootstrap

//= require jquery.purr

//= require best_in_place
//= require jquery-ui
//= require jquery.tokeninput
//= require jquery_purr
//= require jquery-star-rating
//= require notifications
//= require jquery-star-rating
//= require stream
//= require poller.js



var last_search = "";
var original;
search_type = false;
//searchvalue = "";

$(function() {
  $("#searchdiv input").keyup(function(e){
    e.preventDefault();
      //$.get($("#searchdiv").attr("action"), $("#searchdiv").serialize(),null,"script");
  if(e.which != 13){
    var search = $("#search").val();
    // if(last_search!=search){
      var search_in = $("#searchtype").val();
      last_search = search;
      if($("#search").val()!= ""){
        if(search.length > 2){
        $("#stream_results").html("");
        stream_manipulator(1,"",search,true, search_in);
        }
      }else{
        search_type = false;
        $("#stream_results").html("");
        $("#searchtype").val("false");
        stream_manipulator(1,"","",true, "false");
      }
    }
    // }
  });
});

// $(function() {
//  $("#user-search-button-redirection").click(function remove_search_hander(e){
//   e.preventDefault();
//   var search_value = $("#search-input").val();
//   alert(search);
//   $.ajax({
//     url: '/stream/index?page=' + 1,
//     type: 'get',
//     dataType: 'script',
//     data: { mypage: 1, tag: "", search: search_value, search_user: false},
//     success: function() {
//     }
//   });
//  });
// });

$(document).bind("ajaxError", function(e, xhr){
	if(xhr.status == 401){
		$('#signedout').modal('show');
	}
});


$(document).ready(function() {
	$("#sign").click(function() {
		window.location= "/users/sign_in";
	});
  $("#user-search-button").click(function remove_button_handler(e) {
    e.preventDefault();
    search_type = true;
    $("#searchtype").val("true");
    console.log($("#searchtype").val());
});
  $("#idea-search-button").click(function remove_button_handler(e) {
    e.preventDefault();
    search_type = false;
    $("#searchtype").val("false");
    console.log($("#searchtype").val());
});
  $("a.popup").click(function (e) {
    popupCenter($(this).attr("href"),
                $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
    e.stopPropagation();
    return false;
  });

  $("#twitter_signin_button").tooltip({
    placement: 'bottom',
    trigger: 'click',
    title: 'Trying to sign in using twitter, please interact with the popup!',
    container: 'header'
  });

  // $("#searchdivelse input").keyup(function(e){
  //   if (e.keycode == 13){
  //     $("#searchdivelse").submit();
  //     searchvalue = $("#search").val();
  //     alert(searchvalue);
  //   }
  // });

  // function set_searchtext(searchvalue){
  //   searchtext = searchvalue;
  //   alert(searchtext);
  // }
   $('#searchdiv').submit(function(e) {
     if (in_stream){
      e.preventDefault();
     }
    });
});
function popupCenter(url, width, height, name) {
  var left = (screen.width / 2) - (width / 2);
  var top = (screen.height / 2) - (height / 2);
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width=" + width +
                                ",height=" + height + ",toolbar=no,left=" + left +
                                ",top=" + top);
}

