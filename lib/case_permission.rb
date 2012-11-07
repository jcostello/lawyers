class CasePermission
  attr_reader :target

  def initialize(law_case, access)
    @target = law_case
    @access = access
  end

  def can_read?(law_case)
    @target == law_case && has_read_access?
  end

  def can_write?(law_case)
    @target == law_case && has_write_access?
  end

  def no_access?(law_case)
    @target == law_case && @access == :no_access
  end

  private

  def has_read_access?
    @access == :read_only || @access == :full_access
  end

  def has_write_access?
    @access == :full_access
  end
end
