class CasePermission
  attr_reader :target

  def initialize(law_case, access)
    @target = law_case
    @access = access
  end
end
