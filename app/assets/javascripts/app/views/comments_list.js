app.views.CommentsList = Backbone.View.extend({
  className: 'comments-list',

  initialize: function(){
    this.listenTo(this.collection, 'add', this.addComment);
    this.listenTo(this.collection, 'remove', this.showEmptyMessage);
  },

  render: function(){
    var container = document.createDocumentFragment();
    this.$el.empty();

    if( this.collection.length == 0 ){
      this.$el.html('<div class="empty">Sin comentarios</div>');
    }else{
      this.collection.each(function(model, index){
        var commentItem = new app.views.CommentItem({ model: model });
        container.appendChild( commentItem.render().el );
      }, this);

      this.$el.append(container);
    }

    return this;
  },

  addComment: function(model){
    var commentItem = new app.views.CommentItem({
      model: model
    });

    if(this.collection.length > 0){
      this.$('.empty').remove();
    }

    this.$el.append(commentItem.render().el);
    commentItem.animateEntrance();
  },

  showEmptyMessage: function(){
    if(this.collection.length == 0){
      this.$el.html('<div class="empty">Sin comentarios</div>');
    }
  },
});
