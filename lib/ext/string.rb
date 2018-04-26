class String
  def filter_patterns(patterns)
    patterns.select { |pattern| self =~ pattern }
  end
end
