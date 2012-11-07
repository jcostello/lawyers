class LawFirm
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def ==(another_law_firm)
    @name == another_law_firm.name
  end
end
