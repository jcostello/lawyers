class LawFirm
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def ==(law_firm)
    @name == law_firm.name
  end
end
