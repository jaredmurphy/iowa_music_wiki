$( document ).ready(function() {
    entries = ['albums', 'bands', 'festivals', 'labels', 'record_stores', 'studios', 'venues'];
 
     //this function hides and shows forms on create article page, and hides shows articles on categories page
     function showCategoryForm (category) { 
       $("." + category + "_select").click(function(){
           $('.clicked').fadeOut('slow', function () {});
           $('.clicked').removeClass("clicked");

           function appear(){
              $("." + category + "_entry").fadeIn('slow', function() {});
              $("." + category + "_entry").addClass("clicked");
           }
           setTimeout(appear,500);

           console.log(category + " clicked")                  
     }); // ends click funciton
     } // ends showCategoryForm function
 
    entries.forEach(showCategoryForm);
 }); // ends document.ready function
 
 