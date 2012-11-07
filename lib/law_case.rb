class LawCase
  attr_reader :number
  attr_accessor :owner

  def initialize(number, owner)
    @number = number
    @owner = owner
  end

  def ==(another_law_case)
    @number == another_law_case.number
  end
end
