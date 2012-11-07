class LawyerCasesPermission
  attr_reader :target

  def initialize(lawyer, access)
    @target = lawyer
    @access = access
  end
end
