# frozen_string_literal: true

module Company
  def input_company(name)
    self.company = name
  end

  def print_company
    company
  end

  protected

  attr_accessor :company
end
