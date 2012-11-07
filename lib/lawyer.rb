class Lawyer
  attr_reader :name, :own_cases, :law_firm, :permissions

  def initialize(name, law_firm)
    @name = name
    @law_firm = law_firm
    @permissions = hash = Hash.new{|h, k| h[k] = []}
    @own_cases = []
  end

  def init_case(number)
    law_case = LawCase.new(number, self)
    @own_cases << law_case
    law_case
  end

  def grant_case_permission(lawyer, law_case, access)
    raise Exceptions::GrantPermissionException, "This case doesn't belong to you" unless @own_cases.include?(law_case)
    raise Exceptions::GrantPermissionException, "The lawyer doesn't belong to the same firm as you" unless @law_firm == lawyer.law_firm

    permission = CasePermission.new(law_case, access)
    lawyer.take_permission(:case, permission)
  end

  def grant_lawyer_cases_permission(lawyer, access)
    raise Exceptions::GrantPermissionException, "The lawyer doesn't belong to the same firm as you" unless @law_firm == lawyer.law_firm

    permission = LawyerCasesPermission.new(self, access)
    lawyer.take_permission(:lawyer_cases, permission)
  end

  def owns_case?(law_case)
    @own_cases.include?(law_case)
  end

  def can_read?(law_case)
    return true if @own_cases.include?(law_case)
    return false if have_no_access_permission?(law_case)
    have_case_read_permission?(law_case) || have_lawyer_read_permission?(law_case)
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
  protected
  
  def take_permission(key, permission)
    existing_permission = @permissions[key].select { |p| p.target == permission.target }.first
    if existing_permission.nil?
      @permissions[key] << permission
    else
      existing_permission = permission
    end
  end

  private

  def already_have_case?(law_case)
    @own_cases.include?(law_case)
  end
end
