module UsersHelper
  def check_joinus(org_id)
     usr_mapping = UserMapping.where("user_id=? AND join_id=?",current_user.id,org_id)
     if !usr_mapping.blank?
        return true;
     else
        return false;
     end
  end
end
