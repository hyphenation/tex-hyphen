class String
  def equal_or_match?(template)
    if template.is_a? Regexp
      self =~ template
    else
      self == template
    end
  end
end

class Array
  def equal_or_match?(template)
    all? do |element|
      element.equal_or_match?(template)
    end
  end
end
