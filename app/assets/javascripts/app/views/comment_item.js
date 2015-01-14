app.views.CommentItem = Backbone.View.extend({
  className: 'comment-item',

  events: {
    'click .destroy-btn': 'destroyComment'
  },

  initialize: function(){
    this.template = JST['comment_item'];

    this.listenTo(this.model, 'remove', this.animateExit);
  },

  render: function(){
    this.$el.html(this.template({
      comment: this.model.toJSON()
    }));

    this.$('.destroy-btn').tooltip();
    return this;
  },

  destroyComment: function(e){
    e.preventDefault();
    this.$('.destroy-btn').tooltip('destroy');
    this.model.destroy();
  },

  animateEntrance: function(){
    this.$el.css({ display: 'none', background: '#FFFDE1' });

    this.$el.slideDown(100).delay(300).animate({
      "backgroundColor": "transparent"
    }, 50, function(a){
      $(this).css('background', '');
    });
  },

  animateExit: function(){
    this.$el.css({ background: '#FFFDE1' });

    this.$el.slideUp(100).delay(300).animate({
      "backgroundColor": "transparent"
    }, 50, function(a){
      this.remove();
    });
  },
});
