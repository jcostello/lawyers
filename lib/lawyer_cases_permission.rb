class LawyerCasesPermission
  attr_reader :target

  def initialize(lawyer, access)
    @target = lawyer
    @access = access
  end

  def can_read?(law_case)
    @target.owns_case?(law_case) && has_read_access?
  end
  
  def can_write?(law_case)
    @target.owns_case?(law_case) && has_write_access?
  end

  private

  def has_read_access?
    @access == :read_only || @access == :full_access
  end

  def has_write_access?
    @access == :full_access
  end
end
