require 'rspec/expectations/differ'

RSpec::Matchers.define :equal_or_match_for_all_values do |expected|
  match do |actual|
    actual.values.equal_or_match? expected
  end

  failure_message_for_should do |actual|
    full = { }
    actual.keys.each do |engine|
      full[engine] = expected
    end
    "Expected result to match #{expected.inspect} for all engines.  Diff:" + diff.diff_as_object(actual, full)
  end
end
