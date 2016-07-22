require File.expand_path('../../test_helper', __FILE__)

class PivottablesControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :queries,
           :projects_trackers

  def setup
    Role.anonymous.add_permission! :view_pivottables
    @project1 = projects(:projects_001)
    @project1.enabled_module_names = %w(pivottables issue_tracking)
    @project2 = projects(:projects_002)
    @project2.enabled_module_names = %w(pivottables issue_tracking)
  end

  def test_module_enabled
    assert @project1.enabled_module_names.find(:pivottables)
    assert @project1.enabled_module_names.find(:issue_tracking)
  end

  def test_index_anonymous
    role = Role.anonymous
    role.add_permission! :view_pivottables

    get :index, :project_id => 1
    assert_response :success


    role.remove_permission! :view_pivottables

    get :index, :project_id => 1
    assert_response 302
  end


  def test_index_user
    role = Role.find(1)
    role.add_permission! :view_pivottables

    get :index, :project_id => 1
    assert_response :success


    role.remove_permission! :view_pivottables
    @request.session[:user_id] = 2

    get :index, :project_id => 1
    assert_response 403
  end

  def test_issues
    get :index, :project_id => 1

    assert assigns(:issues)
    assert_equal 4, assigns(:issues).length
  end

  def test_new
    get :new, :project_id => 1
    assert_response :success

    assert assigns[:query][:options][:pivot_config]
  end

  def test_save
    assert_difference 'Query.count' do
      post :save, :project_id => 1, :query => {:name => "BarChart", :options => {
         :pivot_config => { "table"=>"", "rows"=>"Target version,Assignee", "cols"=>"Status", "rendererName"=>"Bar Chart", "aggregatorName"=>"Count", "attrdropdown"=>"" }}}

      q = Query.find_by_name('BarChart')
      assert_redirected_to :controller => 'pivottables', :action => 'index', :project_id => 'ecookbook', :query_id => assigns(:query).id
    end
  end

end
