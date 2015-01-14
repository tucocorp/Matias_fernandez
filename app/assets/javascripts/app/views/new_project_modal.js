app.views.NewProjectModal = app.views.BaseModal.extend({
  title: 'Nuevo Proyecto',

  events: {
    'change .projectable-type': 'changeProjectable'
  },

  initialize: function(options){
    options = (options == undefined) ? {} : options;
    this.company_id = options.company_id;
  },

  yield: function(){
    return JST['new_project_modal']({
      companies: window.userCompanies
    });
  },

  afterRender: function(){
    var $select = this.$('.with-selectize').selectize();

    this.$('.submit-project').on('click', _.bind(function(){
      var name = this.$('.project-name').val();
      if(name.length == 0){
        console.log($('.project-name').val().length);
        $('.form-group-name').addClass('has-error');
        return false;
      }else{
        $('.form-group-name').removeClass('has-error');
        return true;
      }
    }, this)); 


    this.$('.submit-project').on('click', _.bind(function(){
      var type = this.$('.projectable-type:checked').length;
      
      if(type == 0){
        this.$('.form-group-type').addClass('has-error');
        return false;
      }else{
        this.$('.form-group-type').removeClass('has-error');

        if(this.$('.project-companies').val().length == 0 && this.$('.projectable-type:checked').val() == 'Company'){
          this.$('.company-list-select').addClass('has-error');
          return false;
        }else{
          this.$('.company-list-select').removeClass('has-error');
          return true;
        }

        return true;
      }
    }, this));

    if(this.company_id != undefined){
      var selectize = $select[0].selectize;
      this.$('.projectable-type[value="Company"]').prop('checked', true);
      this.$('.projectable-type').trigger('change');
      selectize.setValue(this.company_id);
    }
  },

  changeProjectable: function(e){
    var selectize = this.$('.with-selectize')[0].selectize;

    if( $(e.currentTarget).val() == 'Company' ){
      this.$('.company-list-select').removeClass('hidden');
      this.$('.hidden-user-id').attr('disabled', 'disabled');
      selectize.enable();
    }else{
      this.$('.company-list-select').addClass('hidden');
      this.$('.hidden-user-id').removeAttr('disabled');
      selectize.disable();
    }
  }
});
