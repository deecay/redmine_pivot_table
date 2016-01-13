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
           :projects_trackers

  def setup
    @project2 = projects(:projects_002)
    @project2.enabled_module_names = %w(pivottable issue_tracking)
    @project = projects(:projects_001)
    @project.enabled_module_names = %w(pivottable issue_tracking)
  end

  def test_module_enabled
    assert @project.enabled_module_names.find(:pivottable)
    assert @project.enabled_module_names.find(:issue_tracking)
  end

  def test_index
    get :index, :project_id => 1
    assert_response :success
  end

  def test_instance_variables_default
    get :index, :project_id => 1
    assert_equal :ja, assigns(:language)
    assert_equal "pivot.ja.js", assigns(:language_js)
    assert_nil assigns(:rows)
    assert_nil assigns(:cols)
    assert_nil assigns(:aggregatorName)
    assert_nil assigns(:vals)
    assert_nil assigns(:rendererName)
  end

  def test_params
    get :index, {:project_id => 1,
                 :rows => "Author,Tracker",
                 :cols => "Status,Category",
                 :vals => "Estimated time,Spent time",
                 :aggregatorName => "Sum over Sum",
                 :rendererName => "Table"}
    assert_equal %w(Author Tracker), assigns(:rows)
    assert_equal %w(Status Category), assigns(:cols)
    assert_equal ["Estimated time", "Spent time"], assigns(:vals)
    assert_equal "Sum over Sum", assigns(:aggregatorName)
    assert_equal "Table", assigns(:rendererName)
  end

  def test_activity
    get :index, {:project_id => 1, :table => "activity"}
    assert_equal 5, assigns(:events).count
  end

  def test_activity_different_user
    @request.session[:user_id] = 2

    get :index, {:project_id => 1, :table => "activity"}
    assert_equal 5, assigns(:events).count
  end

  def test_activity_public_project_anonymous
    @request.session[:user_id] = 6

    get :index, {:project_id => 1, :table => "activity"}
    assert_equal 5, assigns(:events).count
  end

  def test_activity_private_project_anonymous
    @request.session[:user_id] = 6

    get :index, {:project_id => 2, :table => "activity"}
    assert_equal 0, assigns(:events).count
  end

  def test_activity_private_project_assigned
    @request.session[:user_id] = 2

    get :index, {:project_id => 2, :table => "activity"}
    assert_equal 1, assigns(:events).count
  end

  def test_activity_private_project_not_assigned
    @request.session[:user_id] = 3

    get :index, {:project_id => 2, :table => "activity"}
    assert_equal 0, assigns(:events).count
  end

  def test_query
    get :index, {:project_id => 1, :closed => 0}
    assert_not %w(description).include?(assigns(:query).available_columns)
    assert_equal 1, assigns(:query).project.id
  end

  def test_issues_open_closed
    get :index, {:project_id => 1, :closed => 1}
    assert_equal 7, assigns(:issues).count

    get :index, {:project_id => 1, :closed => 0}
    assert_equal 4, assigns(:issues).count
  end

  def test_issues_different_project_public_private
    @request.session[:user_id] = 6
    get :index, {:project_id => 2, :closed => 0}
    assert_equal 0, assigns(:issues).count

    @request.session[:user_id] = 2
    get :index, {:project_id => 2, :closed => 0}
    assert_equal 1, assigns(:issues).count
  end

end
