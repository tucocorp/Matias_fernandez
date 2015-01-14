//= require_self
//= require_tree ./../../templates

//= require ./router

//= require_tree ./lib
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views/concerns
//= require_tree ./views

var app = {
  helpers: {},
  models: {},
  collections: {},
  views: {},

  initialize: function(){
    app.router = new app.Router();

    Backbone.history.start({
      pushState: Modernizr.history, 
      hashChange: false, root: ''
    });

    app.csrfToken = $('head').find('meta[name="csrf-token"]').attr('content');
  }
};

_.mixin(_.str.exports());

$.ajaxSetup({ cache: false });

$.fn.datepicker.defaults.format    = "dd/mm/yyyy";
$.fn.datepicker.defaults.language  = 'es';
$.fn.datepicker.defaults.weekStart = 1;
$.fn.datepicker.defaults.autoclose = true;

$(function(){
  app.initialize();

  $('.with-selectize').selectize();

  $('.with-autosize').autosize();

  $('.with-tooltip').tooltip({
    animation: false,
    container: 'body'
  });
});
