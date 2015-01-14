Backbone.Stickit.addHandler({

  selector: 'select.with-selectize-stickit',

  initialize: function($el, model, options) {
    var evaluatePath = function(obj, path) {
      var parts = (path || '').split('.');
      var result = _.reduce(parts, function(memo, i) { return memo[i]; }, obj);
      return result == null ? obj : result;
    };

    var path  = options.selectOptions.collection.replace(/^[a-z]*\.(.+)$/, '$1');
    var items = evaluatePath(this, path);

    var selectizeOptions = {
      options: items
    };

    selectizeOptions = _.defaults(selectizeOptions, options.selectizeOptions);
    
    var $select = $el.selectize(selectizeOptions);
    var selectize = $select[0].selectize;

    selectize.on('change', function(){
      model.set(options.observe, $el.val());
    });

    if( !_.isNull(this.model.get(options.observe)) ){
      selectize.setValue(this.model.get(options.observe));
    };

    this.on('close',function(){
      if (selectize) selectize.destroy();
    },this);

    this.listenTo(this.model, 'stickit:unstuck', function(){
      if (selectize) selectize.destroy();
    });
  }
});
