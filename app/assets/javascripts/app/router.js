app.Router = Backbone.Router.extend({

  routes: {
    '': 'userDashboard',
    'projects(/)': 'projectsIndex',
    'projects/:id/plan(/)': 'projectPlan',
    'projects/:id/members(/)': 'projectMembers',
    'projects/:id/last_planner(/)': 'projectLastPlanner',
    'projects/:id/weekly_plan(/)': 'projectWeeklyPlan',

    'lists/:id(/)': 'listShow',

    'milestones/:id(/)': 'milestoneShow',

    'meetings(/)': 'meetingForm',
    'meetings/new(/)': 'meetingForm',
    'meetings/:id/edit(/)': 'meetingForm',
    'meetings/:id(/)': 'meetingShow',
    'meetings/:id/activities(/)': 'meetingActivities',

    'companies/:id/members(/)': 'companyMembers',
    'companies/:id/projects(/)': 'companyProjects'
  },

  initialize: function(){
    app.currentUser = new app.models.User(window.currentUserJSON || {});
  },

  projectsIndex: function(){
    $('.new-project-btn').on('click', function(e){
      e.preventDefault();

      var projectModal = new app.views.NewProjectModal();
      projectModal.render();
      projectModal.open();
    });
  },

  companyProjects: function(id){

    $('.new-project-btn').on('click', function(e){
      e.preventDefault();

      var projectModal = new app.views.NewProjectModal({company_id: id});
      projectModal.render();
      projectModal.open();
    });
  },

  userDashboard: function(){
    var userDashboardView = new app.views.UserDashboardView({
      el: '.content-wrapper'
    });
  },

  companyMembers: function(company_id){
    var companyMembersView = new app.views.CompanyMembersView({
      el: '.content',
      company_id: company_id
    });
  },
  projectMembers: function(project_id){
    var projectMembersView = new app.views.ProjectMembersView({
      el: '.content',
      project_id: project_id
    });

    projectMembersView.render();
  },

  projectPlan: function(project_id){
    var projectPlanView = new app.views.ProjectPlanView({
      el: '.content',
      project_id: project_id
    });
  },

  projectLastPlanner: function(project_id){
    var lastPlannerView = new app.views.LastPlannerView({
      el: '.content',
      project_id: project_id
    });

    lastPlannerView.render();
  },

  projectWeeklyPlan: function(){

    $('.make-ready .activity').each(function() {
      $(this).data('event', {
        title: $(this).children('.name').text(),
        stick: true
      });

      $(this).draggable({
        helper: function(){
                  $copy = $(this).clone();
                  return $copy;
                },
        appendTo: '.weekly-plan-wrapper',
        scroll: false,
        zIndex: 1000000,
        revert: true,
        revertDuration: 0
      });
    });

    $('.calendar').fullCalendar({
      aspectRatio: 2.5,
      defaultView: 'basicWeek',
      header: {
        left: 'prev today next',
        center: 'title',
        right: 'month, basicWeek'
      },
      defaultDate: moment().format('YYYY-MM-DD'),
      editable: true,
      dropAccept: '.activity',
      droppable: true,
      drop: function(e){
        $(this).remove();
      }
    });

    // var view = $('.calendar').fullCalendar('getView');
    // console.log( view );
  },

  listShow: function(project_id){
    var projectPlanView = new app.views.ProjectPlanView({
      el: '.content'
    });
  },

  milestoneShow: function(milestone_id){
    var projectPlanView = new app.views.ProjectPlanView({
      el: '.content'
    });

    var milestoneShowView = new app.views.MilestoneShowView({
      el: '.content'
    });
  },

  meetingForm: function(){
    var meetingForm = new app.views.MeetingFormView({
      el: '.content'
    });

    meetingForm.render();
  },

  meetingShow: function(meeting_id){
    var meetingShowView = new app.views.MeetingShowView({
      el: '.content',
      meeting: new app.models.Meeting(window.currentMeeting)
    });

    meetingShowView.render();
  },

  meetingActivities: function(meeting_id){
    var meetingActivitiesView = new app.views.MeetingActivitiesView({
      el: '.content',
      meeting: new app.models.Meeting(window.currentMeeting)
    });

    meetingActivitiesView.render();
  }
});
