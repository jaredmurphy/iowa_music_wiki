

$( document ).ready(function() {

  	// hides/shows forms on create article page, and hides/shows articles on categories page
    function showCategoryForm (category) { 
  		$("." + category + "_select").click(function(){
  			if ($(this).hasClass("clicked")) {
  				$("." + category + "_entry").fadeOut('slow', function() {
  				});
  				$(this).removeClass("clicked");
  			} 
  			else {
	    		$("." + category + "_entry").fadeIn('slow', function() {
	    		}).siblings("form").hide();
          $('.clicked').removeClass('clicked')
	    		$(this).addClass('clicked'); 

	    	} // ends if statement for click funciton	    	
		}); // ends click funciton
  	} // ends showCategoryForm function
    entries = ['albums', 'bands', 'festivals', 'labels', 'record_stores', 'studios', 'venues'];
  	entries.forEach(showCategoryForm);
}); // ends document.ready function



