require_dependency 'projects_helper'

module RedminePivotTable
  module ProjectsHelperPatch

    def render_project_action_links
      links = []
      if User.current.allowed_to?(:add_project, nil, :global => true)
        links << link_to(l(:label_project_new), new_project_path, :class => 'icon icon-add')
      end
      if User.current.allowed_to?(:view_issues, nil, :global => true)
        if User.current.allowed_to?(:view_pivottables, nil, :global => true)
          pivot_link = link_to(l(:label_pivottables), pivottables_path)
          links << link_to(l(:label_issue_view_all), issues_path) + " (" + pivot_link + ")"
        else
          links << link_to(l(:label_issue_view_all), issues_path)
        end
      end
      if User.current.allowed_to?(:view_time_entries, nil, :global => true)
        links << link_to(l(:label_overall_spent_time), time_entries_path)
      end
      links << link_to(l(:label_overall_activity), activity_path)
      links.join(" | ").html_safe
    end
  end
end

module ProjectsHelper
  prepend RedminePivotTable::ProjectsHelperPatch
end

