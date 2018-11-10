class Ability
  include CanCan::Ability

  def initialize(user)
    if(!user)
      @user =  User.guest
    else
      @user = user
    end


    case @user.role
    
      when "Super User"
        can [:admin, :manage], :all
      
      when "Agency"
        agency_privilages                
      when "Admin"
        admin_privilages
      when "Employee"
        employee_privilages
      when "Care Giver", "Nurse"
        care_giver_privilages  
      else
        guest_privilages
    end
      
  end

  
    def guest_privilages
        can :read, CareHome
        can :read, PostCode
        can :read, StaffingRequest
        can :create, User
    end

    def care_giver_privilages
        guest_privilages
        can :manage, Shift, :user_id=>@user.id
        can :manage, User, :id=>@user.id
        can :manage, UserDoc, :user_id =>@user.id
        can :read, Payment, :user_id =>@user.id
        can :read, Rating, :rated_entity_id =>@user.id, :rated_entity_type=>"User"
        can :create, Rating, :rated_entity_type=>"CareHome"
        can [:read, :manage], Referral, :user_id =>@user.id

    end

    def employee_privilages
        can :read, CareHome
        can :read, PostCode
        can :read, UserDoc
        can :read, Rating
        can :read, CqcRecord
        can :read, Holiday
        can :read, Shift, :care_home_id=>@user.care_home_id         
        can [:read, :create], Referral, :user_id =>@user.id
    end

    def admin_privilages
        employee_privilages
        can :manage, CareHome, :id=>@user.care_home_id
        can :manage, User, :care_home_id=>@user.care_home_id
        can :manage, StaffingRequest, :care_home_id=>@user.care_home_id
        can :read, Shift, :care_home_id=>@user.care_home_id         
        can :manage, Payment, :care_home_id =>@user.care_home_id
        can :manage, Rating, :care_home_id =>@user.care_home_id
    end


    def agency_privilages
        can :manage, CareHome, :agency_care_home_mappings=>{:agency_id => @user.agency_ids}
        can :manage, User, :agency_user_mappings=>{:agency_id => @user.agency_ids}
        can :manage, StaffingRequest, :agency_id=>@user.agency_ids
        can :manage, Shift, :agency_id=>@user.agency_ids
        can :manage, Payment, :agency_id=>@user.agency_ids
        can :manage, Rating, :agency_id=>@user.agency_ids
        can :manage, Rate, :agency_id=>@user.agency_ids
        can :manage, Profile, :agency_id=>@user.agency_ids
        can :manage, Referral, :agency_id=>@user.agency_ids
        can :manage, Stat, :agency_id=>@user.agency_ids
        can :manage, Training, :agency_id=>@user.agency_ids
        can :manage, UserDoc, :agency_id=>@user.agency_ids
    end

end
