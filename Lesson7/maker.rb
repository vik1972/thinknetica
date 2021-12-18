module Company
 def input_company(name)
    self.company = name
  end

  def print_company
    self.company
  end

  protected
  attr_accessor :company
end