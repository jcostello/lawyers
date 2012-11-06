class Lawyer
  attr_reader :name, :own_cases, :law_firm

  def initialize(name, law_firm)
    @name = name
    @law_firm = law_firm
    @own_cases = []
  end

  def take_case(law_case)
    raise Exceptions::CaseAlreadyTakenException, "You already have taken this case" if already_have_case?(law_case)
    raise Exceptions::CaseAlreadyTakenException, "The case is already taken" if law_case.has_owner?

    @own_cases << law_case
    law_case.owner = self
  end

  def grant_case_permission(lawyer, law_case, access)
    raise Exceptions::GrantPermissionException, "This case doesn't belong to you" unless @own_cases.include?(law_case)
    raise Exceptions::GrantPermissionException, "The lawyer doesn't belong to the same firm as you" unless @law_firm == lawyer.law_firm
  end

  private

  def already_have_case?(law_case)
    @own_cases.include?(law_case)
  end
end
