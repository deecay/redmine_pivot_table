class PivottablesController < ApplicationController
  unloadable
  before_filter :find_project, :authorize, :only => :index

  helper :queries
  include QueriesHelper
  helper :repositories
  include RepositoriesHelper
  helper :sort
  include SortHelper
  include IssuesHelper

  def pivottables
  end

  def index
    @project = Project.find(params[:project_id])
    @language = current_language
    @language_js = "pivot." + current_language.to_s + ".js"
    @statuses = IssueStatus.sorted.collect{|s| [s.name] }

    @rows = params[:rows] ? params[:rows].split(",") : nil
    @cols = params[:cols] ? params[:cols].split(",") : nil
    @aggregatorName = params[:aggregatorName]
    @vals = params[:vals] ? params[:vals].split(",") : nil
    @rendererName = params[:rendererName]

    @table = params[:table]

    if (@table == "activity")
      @days = Setting.activity_days_default.to_i
      @with_subprojects = Setting.display_subprojects_issues?
      @activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                               :with_subprojects => @with_subprojects)
      @events = @activity.events(Date.today - @days, Date.today + 1)
    else
      retrieve_query
      @query.project = @project

      # Exclude description
      @query.available_columns.delete_if { |querycolumn| querycolumn.name == :description }

      if (params[:closed] == "1")
          @query.add_filter("status_id", "*", [''])
      end

      @issues = @query.issues(:include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
                              :offset => 0,
                              :limit => 1000)
    end
  end

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end

end
