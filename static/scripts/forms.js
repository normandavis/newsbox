//called in HTML <head> with:
//<script type="text/javascript" src="forms.js"></script> 
function normalize_labels(element,color) {   
   $('label').each(function(){   
      //there might be a better way but these next 5 lines
      //  get the original text for the label from the "for"
      //  attribute, makes it presentable, and then
      //  places it back in the form
      var lab = $(this).attr('for');
      lab = lab.slice(0,1).toUpperCase() + lab.slice(1);
      lab = lab.replace(/_/g, " ");
      $(this).css({'color':'#'+color}); 
      $(this).text(lab);
   });
}

function parse_results(result,form, msgdiv) {
   var success = '';
   var msgArray = result[0].messages;
   $.each(msgArray, function(i,o) {
      for (var p in o) {
         var val = o[p]; //p is the key (id) in this case, and 
                         //  val is the message
         if (p == 'success') {
            //build html for a success message
            success += '<p class="success">' + val + '</p>';
         } else {
            //display errors where labels were
            $($("label[for='"+p+"']")).addClass('error').append(' '+val);
         }
      }
   });//each
   if (success) {            
      $('#'+form).resetForm();//jquery.form.js feature
      $('#'+form).hide("fast"); //hide the form if you want
      $('#'+msgdiv).css('display','block'); //display the success
      $('#'+msgdiv).append(success); //  div and message
   }
}


