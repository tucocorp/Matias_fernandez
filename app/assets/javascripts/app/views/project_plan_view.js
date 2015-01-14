app.views.ProjectPlanView = Backbone.View.extend({

  events: {
    'click .edit-list-btn': 'editList',
    'click .new-milestone-btn': 'newMilestone',
    'click .edit-milestone-btn': 'editMilestone',
    'click .new-list-btn': 'newList',
    
  },

  initialize: function(e){
    $('.new-list-btn').on("click", this.newList);

    $('#edit-milestone-form').on('hidden.bs.modal', function (e) {
      $('#edit-milestone-form .end-date').datepicker('remove');
    });

    $('#edit-activity-form').on('hidden.bs.modal', function (e) {
      $('#edit-activity-form .start-date').datepicker('remove');
      $('#edit-activity-form .end-date').datepicker('remove');
    });
  },

  render: function(){ },

  editList: function(e){
    e.preventDefault();
    var list_id = $(e.currentTarget).attr('list-id');
    var list = new app.models.List({id: list_id });

    
    $('.edit-list-submit-btn').on('click', function(){
      $('.edit-list-submit-btn').popover('destroy'); 
      var errors = [];
      
      if($('.edit-list-name').val().length == 0){
        errors.push("Debe ingresar el nombre de la fase");
      }

      if(errors.length > 0){
        var html = '<ul>';

        _.each(errors, function(msg){
          html += '<li>'+ msg +'</li>'
        });

        html += '</ul>';

        $(".edit-list-submit-btn").popover({
          html : true, 
          content: html,
          trigger: 'manual',
          placement: 'top',
          title: 'No se puede editar la fase',
        });

        $('.edit-list-submit-btn').popover('show'); 
        return false;
      }else{
        return true;
      }
    });

    $('.edit-list-submit-btn').on('blur', function(){  
      $('.edit-list-submit-btn').popover('destroy'); 
    });  


    list.fetch({
      success: function(){
        $('#edit-list-form #list_name').val( list.get('name') );
        $('#edit-list-form #list_description').val( list.get('description') );
        $('#edit-list-form form').attr('action', '/lists/' + list_id);
        $('#edit-list-form .destroy-list-btn').attr('href', '/lists/' + list_id);
        $('#edit-list-form').modal('show');
      }
    });
  },


  newList: function(e){
    e.preventDefault();
    
    $('#new-list-form').modal('show');
    
    $('#new-list-form .milestone-end-date').datepicker({
      language:"es",
      format: "dd/mm/yyyy"
    });

    $('.new-list-submit-btn').on('blur', function(){  
      $('.new-list-submit-btn').popover('destroy'); 
    });  

    $('.new-list-submit-btn').on('click', function(){
      $('.new-list-submit-btn').popover('destroy'); 
      var errors = [];
      
      if($('#new-list-form .list-name').val().length == 0){
        errors.push("Debe ingresar el nombre de la fase");
      }

      if($('.milestone-end-date').val().length == 0){
        errors.push("Debe ingresar la fecha de termino de la fase");
      }

      if($('.milestone-name').val().length == 0){
        errors.push("Debe ingresar el entregable de la fase");
      }

      if(errors.length > 0){
        var html = '<ul>';

        _.each(errors, function(msg){
          html += '<li>'+ msg +'</li>'
        });

        html += '</ul>';

        $(".new-list-submit-btn").popover({
          html : true, 
          content: html,
          trigger: 'manual',
          placement: 'top',
          title: 'No se puede crear la fase',
        });

        $('.new-list-submit-btn').popover('show'); 
        return false;
      }else{
        return true;
      }      
    });

    
  },

  newMilestone: function(e){
    e.preventDefault();
    var list_name = $(e.currentTarget).parents('.list-heading').find('.list-name a').text();
    var end_date = $(e.currentTarget).attr('end-date');

    var list_id = $(e.currentTarget).attr('list-id');
    var phase_end_date = $(e.currentTarget).attr('end-date');

    $('#new-milestone-form .list-name').text(list_name + ' (' + end_date + ')');
    $('#new-milestone-form .list-id').val(list_id);
    $('#new-milestone-form').modal('show');
    
    $('.edit-milestone-end-date').datepicker({
      language:"es",
      format: "dd/mm/yyyy"
    });

    $('.new-milestone-end-date').datepicker('setEndDate', phase_end_date);

    $('.new-milestone-submit-btn').on('click', function(){
      $('.new-milestone-submit-btn').popover('destroy'); 
      var errors = [];
      
      if($('.new-milestone-name').val().length == 0){
        errors.push("Debe ingresar el entregable del hito");
      }
      if($('.new-milestone-end-date').val().length == 0){
        errors.push("Debe ingresar la fecha del hito");
      }

      if(errors.length > 0){
        var html = '<ul>';

        _.each(errors, function(msg){
          html += '<li>'+ msg +'</li>'
        });

        html += '</ul>';

        $(".new-milestone-submit-btn").popover({
          html : true, 
          content: html,
          trigger: 'manual',
          placement: 'top',
          title: 'No se puede guardar crear el hito',
        });

        $('.new-milestone-submit-btn').popover('show'); 
        return false;
      }else{
        return true;
      }
    });

    $('.new-milestone-submit-btn').on('blur', function(){  
      $('.new-milestone-submit-btn').popover('destroy'); 
    });  
  },

  editMilestone: function(e){
    e.preventDefault();

    var milestone_id = $(e.currentTarget).attr('milestone-id');
    var milestone = new app.models.Milestone({ id: milestone_id });


    $('.edit-milestone-submit-btn').on('click',function(){
      $('.edit-milestone-submit-btn').popover('destroy');
      var errors = [];
      
      if($('.edit-milestone-name').val().length == 0){
        errors.push("Debe ingresar el entregable del hito");
      }
      if($('.edit-milestone-end-date').val().length == 0){
        errors.push("Debe ingresar la fecha del hito");
      }

      if(errors.length > 0){
        var html = '<ul>';

        _.each(errors, function(msg){
          html += '<li>'+ msg +'</li>'
        });

        html += '</ul>';

        $(".edit-milestone-submit-btn").popover({
          html : true, 
          content: html,
          trigger: 'manual',
          placement: 'top',
          title: 'No se puede editar el hito',
        });

        $('.edit-milestone-submit-btn').popover('show'); 
        return false;
      }else{
        return true;
      }

    });

    $('.edit-milestone-submit-btn').on('blur', function(){  
      $('.edit-milestone-submit-btn').popover('destroy'); 
    });  
    
    milestone.fetch({
      success: function(){
        $('#edit-milestone-form .end-date').datepicker({
          language: 'es',
          format: 'dd/mm/yyyy'
        });

        $('#edit-milestone-form .list-name').text(milestone.get('list').name);
        $('.edit-milestone-end-date').datepicker('setDate', moment(milestone.get('end_date')).format('DD/M/YYYY') );

        $('#edit-milestone-form #milestone_name').val(milestone.get('name'));
        $('#edit-milestone-form .with-selectize')[0].selectize.setValue(milestone.get('assigned_id'));

        $('#edit-milestone-form form').attr('action', '/milestones/' + milestone_id);
        
        if( milestone.get('latest') == false ){
          $('#edit-milestone-form .destroy-milestone-btn').attr('href', '/milestones/' + milestone_id);
          $('#edit-milestone-form .destroy-milestone-btn').removeClass('hidden');
        }else{
          $('#edit-milestone-form .destroy-milestone-btn').addClass('hidden');
        }

        if( milestone.get('latest') == false ){
          $('#edit-milestone-form .end-date').datepicker('setEndDate', moment(milestone.get('list').end_date).format('D/M/YYYY'));
        }

        $('#edit-milestone-form').modal('show');
      }
    });
  },

});
