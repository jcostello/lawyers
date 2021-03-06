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

  def remove_case_permission(lawyer, law_case)
    raise Exceptions::RemovePermissionException, "This case doesn't belong to you" unless @own_cases.include?(law_case)
    lawyer.return_case_permission(law_case)
  end

  def remove_lawyer_cases_permission(lawyer)
    raise Exceptions::RemovePermissionException, "The lawyer doesn't belong to the same firm as you" unless @law_firm == lawyer.law_firm
    lawyer.return_lawyer_cases_permission(self)
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

  def write(law_case)
    raise Exceptions::NoPermissionException, "You dont have permission to write this case ##{law_case.number}" unless can_write?(law_case)
    
    puts "you wrote the case number #{law_case.number}"
  end

  def read(law_case)
    raise Exceptions::NoPermissionException, "You dont have permission to read this case ##{law_case.number}" unless can_read?(law_case)
    
    puts "you readed the case number #{law_case.number}"
  end

  def all_redeable_cases
    @permissions.all_redeable_cases
  end

  protected

  def return_case_permission(law_case)
    @permissions.remove_case_permission(law_case)
  end
  
  def return_lawyer_cases_permission(lawyer)
    @permissions.remove_lawyer_cases_permission(lawyer)
  end

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
