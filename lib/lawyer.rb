class Lawyer
  attr_reader :name, :own_cases

  def initialize(name)
    @name = name
    @own_cases = []
  end

  def take_case(law_case)
    raise Exceptions::CaseAlreadyTakenException, "You already have taken this case" if already_have_case?(law_case)
    raise Exceptions::CaseAlreadyTakenException, "The case is already taken" if law_case.has_owner?

    @own_cases << law_case
    law_case.owner = self
  end

  private

  def already_have_case?(law_case)
    @own_cases.include?(law_case)
  end
end
