

$( document ).ready(function() {
  	entries = ['albums', 'bands', 'festivals', 'labels', 'record_stores', 'studios', 'venues'];

  	//this function hides and shows forms on create article page, and hides shows articles on categories page
  	function showCategoryForm (category) { 
  		$("." + category + "_select").click(function(){
  			if ($(this).hasClass("clicked")) {
  				$("." + category + "_entry").fadeOut('slow', function() {
  				});
  				$(this).removeClass("clicked");
  			} 
  			else {
	    		$("." + category + "_entry").fadeIn('slow', function() {
	    		});
	    		$(this).addClass('clicked');
	    		console.log(category + " clicked")	    		
	    	} // ends if statement for click funciton	    	
		}); // ends click funciton
  	} // ends showCategoryForm function

  	entries.forEach(showCategoryForm);
}); // ends document.ready function



