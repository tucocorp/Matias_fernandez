app.views.CommentFormView = Backbone.View.extend({
  className: 'comment-form',
  tagName: 'form',

  events: {
    'focus .content': 'open',
    'submit': 'saveComment',
    'blur .btn-success': 'hideErrors'
  },

  bindings: {
    '.content': 'content'
  },

  initialize: function(options){
    this.template = JST['comment_form'];
    this.meeting = options.meeting;

    this.setModel();
  },

  open: function(e){
    this.$el.addClass('open');
  },

  setModel: function(){
    this.unstickit();

    this.model = new app.models.Comment({
      commentable_type: 'Meeting',
      commentable_id: this.meeting.get('id')
    });

    this.listenTo(this.model, 'invalid', this.showErrors);
    this.$('.content').focus();

    this.stickit();
    return this;
  },

  render: function(){
    this.$el.html(this.template());
    this.$('.content').autosize();

    this.stickit();
    return this;
  },

  saveComment: function(e){
    e.preventDefault();

    this.model.save({}, {
      success: _.bind(function(r){
        this.collection.add(this.model);
        this.setModel();
      }, this)
    });
  },

  showErrors: function(model){
    var html = '<ul>';

    _.each(model.validationError, function(error){
      html += '<li>'+ error +'</li>';
    });

    html += '</ul>';

    this.$('.btn-success').popover({
      animation: false,
      html: true,
      content: html,
      container: 'body',
      placement: 'auto',
      trigger: 'manual',
      title: 'Error de validación'
    });

    this.$('.btn-success').popover('show').focus();
  },

  hideErrors: function(){
    this.$('.btn-success').popover('destroy');
  }
});
