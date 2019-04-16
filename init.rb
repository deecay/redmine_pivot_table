require 'redmine'
require 'query_column_patch'
require 'projects_helper_patch'

Rails.configuration.to_prepare do
  if Redmine::VERSION.to_s < "2.6.0"
    Rails.logger.info "redmine_pivot_table: patching QueryColumn for Redmine <2.6.0"
    require_dependency 'query'
    QueryColumn.send(:include, RedminePivotTable::QueryColumnPatch)
  end
end



Redmine::Plugin.register :redmine_pivot_table do
  name 'Redmine Pivot Table plugin'
  author 'Daiju Kito'
  description 'Pivot table plugin for Redmine using pivottable.js'
  version '0.0.7'
  url 'https://github.com/deecay/redmine_pivot_table'

  project_module :pivottables do
    permission :view_pivottables, :pivottables => [:index]
  end

  menu :project_menu, :pivottables, { :controller => 'pivottables', :action => 'index' }, :after => :activity, :param => :project_id

  settings :default => {'pivottable_max' => 1000}, :partial => 'pivottables/setting'
end
