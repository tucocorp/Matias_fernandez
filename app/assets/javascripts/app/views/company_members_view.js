app.views.CompanyMembersView = Backbone.View.extend({

  events: {
    'change select[name="user_role"]': 'change_role'  
  },

  initialize: function(options){
    $("#invite-users .search-user-btn").on('click', this.searchUser);
    this.company_id = options.company_id;
  },

  change_role: function(e){
    var id = $(e.target).attr('member-id');
    var role = $(e.target).val();

    var member = new app.models.CompanyMember({
      id: id,
      role: role,
      project_id: this.project_id
    });

    member
      .save(null, { url: '/company_members/' + member.get('id') + '?company_id=' + this.company_id })
      .success(function(data){
        toastr.success('Se ha cambiado el rol del usuario exitosamente');
      });
  },

  searchUser: function(e){
    e.preventDefault();
    var email = $('#invite-users #email').val()
    var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    var company_id = $('#invite-users .hidden-company-id').val()
    
    if(filter.test(email)){
      $('#invite-users .search').addClass('has-success');
      $('#invite-users .error-message').addClass('hidden');
      $('#invite-users .search').removeClass('has-error');
      $('#invite-users .search-user-btn').removeClass('btn-danger');
      $('#invite-users .user-name' ).addClass('hidden');


      var user = new app.models.User({email: email });
      
      user.fetch({
        data: {email: email, company_id: company_id},
        success: function(){
          if(user.get('id') == undefined){
            $('#invite-users .user-no-found').removeClass('hidden');
            $('#invite-users .user-found').addClass('hidden');
            $('#invite-users .hidden-email').val(email);

          }else{
            if (user.meta.in_company == true){
              $('#invite-users .user-name' ).html(user.get('full_name')+" ("+user.get('email')+") ya es miembro esta compañia.");
              $('#invite-users .add-user-botton' ).addClass('hidden');
              
            }else{
              $('#invite-users .add-user-botton' ).removeClass('hidden');
              $('#invite-users .user-name' ).html(user.get('full_name')+" ("+user.get('email')+")");
              $('#invite-users .add-user-form').attr('action', '/users/' + user.get('id')+ '/add_to_company');
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