Rails.application.routes.draw do
  devise_for :users, skip: [:unlocks], :controllers => { invitations: 'invitations'  }

  resources :users do
    get  'lock'
    get  'unlock'
    post 'add_to_project'
    post 'add_to_company'
    post 'invite_to_project'
    post 'invite_to_company'
  end

  resources :companies, except: [:destroy] do
    member do
      get 'projects'
      get 'members'
    end
  end

  resources :projects do
    member do
      put  'archive'
      put  'activate'
      get  'plan'
      get  'pull'
      get  'members'
      get  'meetings'
      get  'weekly_plan'
      get  'last_planner'
    end
  end

  resources :company_members
  resources :project_members

  resources :milestones do
    member do
      post 'start_evaluation'
    end
  end

  resources :meetings do
    member do
      get  'accept'
      get  'refuse'
      get  'activities'
      post 'start'
      post 'stop'
      post 'resend_invitations'
      post 'resend_minute'
    end
  end

  resources :activities do
    member do
      post 'accept'
      post 'refuse'

      post 'pending'
      post 'completed'
      post 'uncompleted'
    end

    get 'accept_all', on: :collection
  end

  resources :constraints do
    member do
      post 'complete'
      post 'incomplete'
      post 'pending'
    end
  end

  resources :issues
  resources :lists
  resources :tasks
  resources :unit_works
  resources :comments

  resource  :account, only: [:show, :update]
  resource  :calendar
  resource  :dashboard

  root 'dashboards#index'
end
