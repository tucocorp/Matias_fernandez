class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :name, 
             :last_name, :address

  def initialize(*args)
    @options = args.last || {}
    super
  end

  def filter(keys)
    if @options.key?(:project)
      keys + [:project_member]
    else
      keys
    end
  end

  def project_member
    @project = @options[:project]
    project_member = @project.project_members.where(user_id: scope.id).first
    ProjectMemberSerializer.new(project_member)
  end
end
