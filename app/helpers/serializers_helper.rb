module SerializersHelper
  def activity_lists_as_json(activity_lists)
    return [] if activity_lists.nil?
    ActiveModel::ArraySerializer.new(activity_lists, each_serializer: ActivityListSerializer).to_json
  end

  def user_as_json(user, options = {})
    return [] if user.nil?
    UserSerializer.new(user, **options, scope: current_user).to_json
  end

  def users_as_json(users)
    return [] if users.nil?
    ActiveModel::ArraySerializer.new(users, each_serializer: UserSerializer).to_json
  end

  def project_members_as_json(members)
    return [] if members.nil?
    ActiveModel::ArraySerializer.new(members, each_serializer: ProjectMemberSerializer).to_json
  end

  def project_categories_as_json(categories)
    return [] if categories.nil?
    ActiveModel::ArraySerializer.new(categories, each_serializer: ProjectCategorySerializer).to_json
  end

  def companies_as_json(companies)
    return [] if companies.nil?
    ActiveModel::ArraySerializer.new(companies, each_serializer: CompanySerializer).to_json
  end

  def milestones_activities_as_json(milestones)
    return [] if milestones.nil?
    list = ActiveModel::ArraySerializer.new(milestones, each_serializer: MilestonesWithActivitiesSerializer, scope: current_user).to_json
  end

  def meeting_as_json(meeting)
    return [] if meeting.nil?
    MeetingSerializer.new(meeting, scope: current_user).to_json
  end

  def meeting_comments_as_json(comments)
    return [] if comments.nil?
    ActiveModel::ArraySerializer.new(comments, each_serializer: CommentSerializer).to_json
  end
end
