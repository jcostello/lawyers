class Lawyer
  attr_reader :name, :own_cases, :law_firm, :permissions

  def initialize(name, law_firm)
    @permissions = PermissionCollection.new
    @name = name
    @law_firm = law_firm
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

    lawyer.take_case_permission(law_case, access)
  end

  def grant_lawyer_cases_permission(lawyer, access)
    raise Exceptions::GrantPermissionException, "The lawyer doesn't belong to the same firm as you" unless @law_firm == lawyer.law_firm

    lawyer.take_lawyer_cases_permission(self, access)
  end

  def owns_case?(law_case)
    @own_cases.include?(law_case)
  end

  def can_read?(law_case)
    self.owns_case?(law_case) || @permissions.can_read?(law_case)
  end

  def can_write?(law_case)
    self.owns_case?(law_case) || @permissions.can_write?(law_case)
  end

  protected
  
  def take_case_permission(law_case, access)
    @permissions.add_case_permission(law_case, access)
  end

  def take_lawyer_cases_permission(lawyer, access)
    @permissions.add_lawyer_cases_permission(lawyer, access)
  end

  private

  def already_have_case?(law_case)
    @own_cases.include?(law_case)
  end
end
