class LawCase
  attr_reader :number
  attr_accessor :owner

  def initialize(number)
    @number = number
  end

  def has_owner?
    !self.owner.nil?
  end

end

