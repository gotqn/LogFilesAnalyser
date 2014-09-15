class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new

    # if current user is administrator
    if user.is_admin?
      can :manage, :all
      cannot :destroy, User, is_admin: true
    else

      # if current user is guest
      if user.id.nil?
        can [:read, :index], LogFile, access_type_id: AccessType.find_by_name('public').id

      # if current user is regular user
      else
        can [:read, :create, :index], LogFile
        cannot :index,  LogFile, access_type_id: AccessType.find_by_name('private').id
        can [:update, :destroy], LogFile, user_id: user.id
        can :index,  LogFile, user_id: user.id
        can :read, User, id: user.id
      end

    end

  end
end
