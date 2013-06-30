// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/*-------------------- Messenger Functions ------------------------------*/
// The following object and code was taken and modified from Jaded 
// Pixel's Shopify system. (http://www.myshopify.com/javascripts/shopify.js)
//
// Messenger is used to manage error messages and notices
//
var Messenger = {
  autohide_error: null,
  autohide_notice: null,
  // When given an error message, wrap it in a list 
  // and show it on the screen.  This message will auto-hide 
  // after a specified amount of miliseconds
  error: function(message) {
    $('flasherrors').update(message);
    new Effect.Appear('flasherrors', {duration: 0.3});
    
    if (this.autohide_error != null) {clearTimeout(this.autohide_error);}
    this.autohide_error = setTimeout(Messenger.fadeError.bind(this), 5000);
  },

  // Notice-level messages.  See Messenger.error for full details.
  notice: function(message) {
    $('flashnotice').update(message);
    new Effect.Appear('flashnotice', {duration: 0.3});

    if (this.autohide_notice != null) {clearTimeout(this.autohide_notice);}
    this.autohide_notice = setTimeout(Messenger.fadeNotice.bind(this), 3000);
  },
  
  // Responsible for fading notices level messages in the dom    
  fadeNotice: function() {
    new Effect.Fade('flashnotice', {duration: 0.3});
    this.autohide_notice = null;
  },
  
  // Responsible for fading error messages in the DOM
  fadeError: function() {
    new Effect.Fade('flasherrors', {duration: 0.3});
    this.autohide_error = null;
  }
}



var Application = {
  
	activate_tab:function(tab_id) {
		$(tab_id).addClassName("current");
	},	

	make_spinner: function(dom_id){
            $(dom_id).update('<img src="/images/spinner.gif" style="padding:0px 2px;margin: 0px; margin-bottom:-2px; margin-top:-2px;"/>');
	},
	
	choose_checks: function(){
	  $('seller_address').show();
	  $('seller_paypal').hide();
	  $('submit_button').disabled=false
	},
	
	choose_paypal: function(){
	  $('seller_paypal').show();
	  $('seller_address').hide();
	  $('submit_button').disabled=false
	},
	
	popup: function(url) {
  	newwindow=window.open(url,'hsa_pop','height=350,width=500');
  	if (window.focus) {newwindow.focus()}
  	return false;
  }
}



/****************************************
 *
 *	Use this to load stuff automatically..
 *
 ****************************************/


 