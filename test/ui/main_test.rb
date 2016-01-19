require File.expand_path('../../../../../test/ui/base', __FILE__)

class Redmine::UiTest::PivottableTest < Redmine::UiTest::Base
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers

  def take_screenshots( comment = "" )
    method = caller[0][/`.*'/][1..-2]
    comment = "-" + comment.gsub(/[^0-9A-z.\-]/, '_') if comment != ""

    resolutions = [[1280, 768]]

    resolutions.each do |res|
      page.driver.browser.manage.window.resize_to(res[0], res[1])

      page.save_screenshot(
                   "#{Rails.root}/plugins/redmine_pivot_table/" +
                   "test/ui/public/test_screenshots/" +
                   #"#{self.class.name.underscore}/" +
                   #"#{DateTime.now.strftime("%Y%m%dT%H%M%S")}/" +
                   "#{method}#{comment}-#{res[0]}-#{res[1]}-#{SecureRandom.uuid}.png")
    end
  end

  def enable_pivottable
  end

  def test_ui_init
    log_user('admin', 'admin')
    visit '/projects/001/pivottables'

    assert_equal "Activity | Issue Include closed", page.find('span#table-menu').text
    assert_equal "Activity", page.find('span#table-menu').find('a').text

    assert_equal "Show URL", page.find('a#show-url').text
    assert page.find('input#url', visible: false)

    within('form#query_form') do
      assert_not page.find('input#closed')['checked']
    end

    assert_equal "Table", page.find('select.pvtRenderer').value

    assert page.has_selector?('table.pvtTable')

    tbl = page.find('table.pvtTable')
    assert_equal(["2", "2"], [tbl['data-numrows'], tbl['data-numcols']] )

    take_screenshots
  end

  def test_ui_init_project2
    log_user('admin', 'admin')
    visit '/projects/002/pivottables'

    tbl = page.find('table.pvtTable')
    assert_equal(["1", "1"], [tbl['data-numrows'], tbl['data-numcols']] )

    take_screenshots
  end

  def test_ui_issue_closed
    log_user('admin', 'admin')
    visit '/projects/001/pivottables'

    assert_not page.find('input#closed')['checked']

    within('form#query_form') do
      check('closed')
    end

    within('form#query_form') do
      assert page.find('input#closed')['checked']
    end

    tbl = page.find('table.pvtTable')
    assert_equal(["2", "3"], [tbl['data-numrows'], tbl['data-numcols']] )

    take_screenshots
  end

  def test_ui_activities
    log_user('admin', 'admin')
    visit '/projects/001/pivottables?table=activity'

    tbl = page.find('table.pvtTable')
    assert_equal(["2", "5"], [tbl['data-numrows'], tbl['data-numcols']] )

    take_screenshots
  end

  def test_ui_renderers
    log_user('admin', 'admin')
    visit '/projects/001/pivottables'

    assert_equal "Table", page.find('select.pvtRenderer').value
    assert page.find('select.pvtRenderer').find(:option, "Bar Chart").select_option

    assert_not page.has_selector?('table.pvtTable')
    assert     page.has_selector?('div.c3')

    take_screenshots
  end

  def test_ui_aggregators
    log_user('admin', 'admin')
    visit '/projects/001/pivottables?' +
          'aggregatorName=Sum%20over%20Sum&' + 
          'rendererName=Table&' +
          'vals=Spent%20time,Estimated%20time&' +
          'rows=Target%20version,Assignee&' +
          'cols=Status'

    take_screenshots
  end

  def test_ui_clear_attributes
    log_user('admin', 'admin')
    visit '/projects/001/pivottables'

    page.find('#clear-all').click

    tbl = page.find('table.pvtTable')
    assert_equal(["0", "0"], [tbl['data-numrows'], tbl['data-numcols']] )

    take_screenshots
  end

  def test_ui_show_url
    log_user('admin', 'admin')
    visit '/projects/001/pivottables'

    click_on('show-url')

    assert page.has_selector?('input#url')

    take_screenshots
  end

  def test_ui_get_params
    log_user('admin', 'admin')
    visit '/projects/001/pivottables?rows=Author&cols=Status'

    tbl = page.find('table.pvtTable')
    assert_equal(["1", "2"], [tbl['data-numrows'], tbl['data-numcols']] )

    take_screenshots
  end

  def test_ui_i18n
    log_user('admin', 'admin')
    visit '/my/account'

    assert page.find('#user_language').find(:option, "Japanese (日本語)").select_option

    click_on('Save')

    visit '/projects/001/pivottables'
 
    take_screenshots

  end


end
