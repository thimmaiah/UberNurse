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
                
      when "Admin"
        admin_privilages
      when "Employee"
        employee_privilages
      when "Care Giver"
        care_giver_privilages  
      else
        guest_privilages
    end
      
  end

  
    def guest_privilages
        can :read, Hospital
        can :read, PostCode
        can :read, StaffingRequest
        can :create, User
    end

    def care_giver_privilages
        guest_privilages
        can :manage, StaffingResponse, :user_id=>@user.id
        can :manage, User, :id=>@user.id
        can :manage, UserDoc
        can :read, Payment, :user_id =>@user.id
    end

    def employee_privilages
        can :read, Hospital
        can :read, PostCode
        can :manage, StaffingRequest, :user_id=>@user.id
        can :read, User, :hospital_id=>@user.hospital_id
        can :read, StaffingRequest, :hospital_id=>@user.hospital_id         
        can :read, StaffingResponse, :hospital_id=>@user.hospital_id         
        can :read, UserDoc
    end

    def admin_privilages
        employee_privilages
        can :manage, Hospital, :id=>@user.hospital_id
        can :manage, User, :hospital_id=>@user.hospital_id
        can :manage, StaffingRequest, :hospital_id=>@user.hospital_id
        can [:read, :update], StaffingResponse, :hospital_id=>@user.hospital_id         
        can :manage, Payment, :hospital_id =>@user.hospital_id
    end
end
