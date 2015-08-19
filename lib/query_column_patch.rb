# For Redmine <2.6 Compatibility
require_dependency 'query'

module RedminePivotTable
  module QueryColumnPatch
    def value_object(issue)
      return value(issue)
    end
  end
end
