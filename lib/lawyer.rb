class Lawyer
  attr_reader :name, :own_cases, :law_firm, :permissions

  def initialize(name, law_firm)
    @name = name
    @law_firm = law_firm
    @permissions = Hash.new([])
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

    permission = CasePermission.new(law_case, access)
    lawyer.take_permission(:case, permission)
  end

  protected
  
  def take_permission(key, permission)
    existing_permission = @permissions[key].select { |p| p.target == permission.target }.first
    if existing_permission
      existing_permission = permission
    else
      @permissions[key] << permission
    end
  end

  private

  def already_have_case?(law_case)
    @own_cases.include?(law_case)
  end
end
