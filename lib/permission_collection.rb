class PermissionCollection

  def initialize
    @permissions = hash = Hash.new{|h, k| h[k] = []}
  end

  def add_case_permission(law_case, access)
    add_permission(:case, CasePermission.new(law_case, access))
  end

  def add_lawyer_cases_permission(lawyer, access)
    add_permission(:lawyer_cases, LawyerCasesPermission.new(lawyer, access))
  end

  def remove_case_permission(law_case)
    remove_permission(:case, law_case)
  end

  def remove_lawyer_cases_permission(lawyer)
    remove_permission(:lawyer_cases, lawyer)
  end

  def case_permissions
    @permissions[:case]
  end

  def lawyer_cases_permissions
    @permissions[:lawyer_cases]
  end

  def can_read?(law_case)
    return false if have_no_access_permission?(law_case)

    have_case_read_permission?(law_case) || have_lawyer_read_permission?(law_case)
  end

  def can_write?(law_case)
    return false if have_no_access_permission?(law_case)

    have_case_write_permission?(law_case) || have_lawyer_write_permission?(law_case)
  end

  private 

  def have_case_write_permission?(law_case)
    @permissions[:case].each do |permission|
      return true if permission.can_write?(law_case)
    end

    false
  end

  def have_lawyer_write_permission?(law_case)
    @permissions[:lawyer_cases].each do |permission|
      return true if permission.can_write?(law_case)
    end

    false
  end

  def have_case_read_permission?(law_case)
    @permissions[:case].each do |permission|
      return true if permission.can_read?(law_case)
    end

    false
  end

  def have_lawyer_read_permission?(law_case)
    @permissions[:lawyer_cases].each do |permission|
      return true if permission.can_read?(law_case)
    end

    false
  end

  def have_no_access_permission?(law_case)
    @permissions[:case].each do |permission|
      return true if permission.no_access?(law_case)
    end

    false
  end

  def remove_permission(key, target)
    @permissions[key].delete_if {|permission| permission.target == target } 
  end

  def add_permission(key, permission)
    existing_permission = @permissions[key].select { |p| p.target == permission.target }.first
    if existing_permission.nil?
      @permissions[key] << permission
    else
      existing_permission = permission
    end
  end

  def valite_access
    raise Exceptions::InvalidPermissionAccessException, "Allowed access are :full_access, :read_only, :no_access"
  end

end
