/* http://keith-wood.name/maxlength.html
   French initialisation for the jQuery Max Length extension
   Written by Keith Wood (kbwood{at}iinet.com.au) April 2012. */
(function($) { // hide the namespace

$.maxlength.regionalOptions['es'] = {
	feedbackText: 'Quedan {r} caracteres disponibles', /* ({m} maximum)*/
	overflowText: 'se ha sobrepasado en {o} caracteres' /* ({m} maximum)'*/
};
$.maxlength.setDefaults($.maxlength.regionalOptions['es']);

})(jQuery);
