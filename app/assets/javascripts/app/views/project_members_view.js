app.views.ProjectMembersView = Backbone.View.extend({

  events: {
    'change select[name="user_role"]': 'change_role'  
  },

  initialize: function(options){
    $("#invite-users .search-user-btn").on('click', this.searchUser);

    this.user_field = $('#add-members .modal-footer form').find('input.user_id').first().clone();
    this.role_field = $('#add-members .modal-footer form').find('input.role').first().clone();

    $('#add-members .modal-footer .btn-success').on('click', _.bind(this.add_members, this));

    this.project_id = options.project_id;
  },


  change_role: function(e){
    var id = $(e.target).attr('member-id');
    var role = $(e.target).val();

    var member = new app.models.ProjectMember({
      id: id,
      role: role,
      project_id: this.project_id
    });

    member
      .save(null, { url: '/project_members/' + member.get('id') + '?project_id=' + this.project_id })
      .success(function(data){
        toastr.success('Se ha cambiado el rol del usuario exitosamente');
      });
  },

  render: function(){
    this.users_list = new List(
      $('#add-members')[0], 
      {
        valueNames: ['id', 'name', 'email'],
        page: 6,
        plugins: [
          ListPagination({ innerWindow: 4, outerWindow: 4 })
        ]
      }
    );
  },

  add_members: function(){
    var selected_users = 
      _(this.users_list.items)
      .chain()
      .map(function(item){
        if( $(item.elm).find('input[type=checkbox]:not(:disabled)').is(':checked') ){
          return {
            id: parseInt($(item.elm).find('input').val()),
            role: $(item.elm).find('select').val()
          }
        }
      })
      .compact()
      .value();

    this.container = document.createDocumentFragment();
    $('#add-members .modal-footer form .user_id').remove();
    $('#add-members .modal-footer form .role').remove();

    _(selected_users).each(function(user){
      this.container.appendChild( this.user_field.clone().val(user.id)[0] );
      this.container.appendChild( this.role_field.clone().val(user.role)[0] );
    }, this);

    $('#add-members .modal-footer form').append(this.container);
    $('#add-members .modal-footer form').submit();
    return this;
  },

  searchUser: function(e){
    e.preventDefault();
    var email = $('#invite-users #email').val();
    var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    var project_id = $('#invite-users .hidden-project-id').val();

    console.log(project_id);

    if(filter.test(email)){
      $('#invite-users .search').addClass('has-success');
      $('#invite-users .error-message').addClass('hidden');
      $('#invite-users .search').removeClass('has-error');
      $('#invite-users .search-user-btn').removeClass('btn-danger');
      $('#invite-users .user-name' ).addClass('hidden');

      var user = new app.models.User({email: email });

      user.fetch({
        data: {email: email, project_id: project_id},
        success: function(){
          if(user.get('id') == undefined){
            $('#invite-users .user-no-found').removeClass('hidden');
            $('#invite-users .user-found').addClass('hidden');
            $('#invite-users .hidden-email').val(email);

          }else{
            if (user.meta.in_project == true){
              $('#invite-users .user-name' ).html(user.get('full_name')+" ("+user.get('email')+") ya es miembro en este proyecto");
              $('#invite-users .add-user-botton' ).addClass('hidden');
            }else{
              $('#invite-users .add-user-botton' ).removeClass('hidden');
              $('#invite-users .user-name' ).html(user.get('full_name')+" ("+user.get('email')+")");
              $('#invite-users .add-user-form').attr('action', '/users/' + user.get('id')+ '/add_to_project');
            } 
            
            $('#invite-users .user-found').removeClass('hidden');
            $('#invite-users .user-no-found').addClass('hidden');
            $('#invite-users .user-name' ).removeClass('hidden');
          }
        }
      });
    }else{
      $('#invite-users .search').addClass('has-error');
      $('#invite-users .search-textbox').attr("placeholder", "Ingrese un correo válido");
      $('#invite-users .error-message').removeClass('hidden');
      $('#invite-users .user-found').addClass('hidden');
      $('#invite-users .user-no-found').addClass('hidden');
      $('#invite-users .search-user-btn').addClass('btn-danger');
    }

  }

});