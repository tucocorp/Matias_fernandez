app.views.MeetingFormView = Backbone.View.extend({

  initialize: function(){
    this.REGEX_EMAIL = '([a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@' + 
                       '(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)';
  },

  render: function(){
    $('.new-meeting-submit-btn').on('click', function(){
      $('.new-meeting-submit-btn').popover('destroy'); 
      var errors = [];
      
      if($('.meeting-name').val().length == 0){
        errors.push("Debe ingresar el título de la reunión");
      }

      if(!$('.meeting-form .attendee-ids').val()){
        errors.push("Debe agregar participantes a la reunión");
      }

      if(!$('.meeting-form .date.start').val()){
        errors.push("Debe definir fecha de início de la reunión");
      }

      if(!$('.meeting-form .time.start').val()){
        errors.push("Debe definir hora de início de la reunión");
      }

      if(!$('.meeting-form .date.end').val()){
        errors.push("Debe definir fecha de início de la reunión");
      }

      if(!$('.meeting-form .time.end').val()){
        errors.push("Debe definir hora de início de la reunión");
      }

      if($('.meeting-form .topic-name').val().length == 0){
        errors.push("Debe definir el título del tema");
      }
      
      if($('.meeting-form .topic-duration').val().length == 0){
        errors.push("Debe definir el tiempo que durará la reunión");
      }

      if(errors.length > 0){
        var html = '<ul>';

        _.each(errors, function(msg){
          html += '<li>'+ msg +'</li>'
        });

        html += '</ul>';

        $(".new-meeting-submit-btn").popover({
          html : true, 
          content: html,
          trigger: 'manual',
          placement: 'top',
          title: 'No se puede editar la fase',
        });

        $('.new-meeting-submit-btn').popover('show'); 
        return false;
      }else{
        return true;
      }
    });

    $('.new-meeting-submit-btn').on('blur', function(){  
      $('.new-meeting-submit-btn').popover('destroy'); 
    });  


    $('.when .time').timepicker({
      'showDuration': true,
      'timeFormat': 'g:ia'
    });

    $('.when .date').datepicker({
      'format': 'dd/mm/yyyy',
      'autoclose': true
    });

    $('.when').datepair();

    $('.location')
      .geocomplete({ map: '.map_canvas' })
      .bind('geocode:result', function(event, result){
        $('.map_canvas').animate({ height: '200px' });
      });
    
    this.$('.meeting-form .attendee-ids').selectize({
      persist: false,
      maxItems: null,
      valueField: 'id',
      labelField: 'full_name',
      searchField: ['full_name', 'email'],
      options: window.projectMembers,
      render: {
        item: function(item, escape) {
          return '<div>' +
              (item.full_name ? '<span class="name">' + escape(item.full_name) + '</span>' : '') +
              (item.email ? '<span class="email">' + escape(item.email) + '</span>' : '') +
          '</div>';
        },
        option: function(item, escape) {
          var label = item.full_name || item.email;
          var caption = item.full_name ? item.email : null;
          
          return '<div>' +
                 '<span class="inpt-label">' + escape(label) + '</span>' +
                 (caption ? '<span class="caption">' + escape(caption) + '</span>' : '') +
                 '</div>';
        }
      }
    });

    this.$('.meeting-form .attendee-ids')[0].selectize.setValue( _.pluck(window.selectedMembers, 'id') );
  }
});
