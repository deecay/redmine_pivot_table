module PivottablesHelper
  def pv_caption(colname)
    if @query
      col = @query.available_columns.find(){ |x| x.name == colname }
      unless col.nil? then
        col.caption
      end
    end
  end

  def parse_events(events)

    result_list = Array.new

    events.each{|e|

      if e.kind_of?(TimeEntry) then
        hours = e.hours

      elsif e.kind_of?(Changeset) then
        repository = e.repository

      end

      activity = l("label_#{e.event_type.split(' ').first.singularize.gsub(/-/, '_')}_plural")
      author = link_to_user(e.event_author) if e.respond_to?(:event_author)
      title = link_to(format_activity_title(e.event_title), e.event_url)

      time = e.event_datetime
      zone = User.current.time_zone
      local = zone ? time.in_time_zone(zone) : (time.utc? ? time.localtime : time)

      result_list.push({l("field_activity") => activity,
                        ID:e.id, 
                        l("field_author") => author, 
                        l("field_title") => title,
                        l("field_created_on") => local,
                        l("field_created_on")+"(y)" => local.year,
                        l("field_created_on")+"(m)" => local.month,
                        l("field_created_on")+"(d)" => local.mday,
                        l("field_created_on")+"(U)" => local.strftime("%U"),
                        l("field_created_on")+"(w)" => local.wday,
                        l("field_created_on")+"(h)" => local.hour,
                        })

    }

    result_list

  end

  def parse_issues(issues)
    result_list = Array.new

    issues.each{|i|
      formatted_issue = {}
      @query.available_columns.each{|c|
        if c.name.to_s == "id"
          formatted_issue["ID"] = column_content(c, i)
        elsif column_content(c, i).to_s.include?("<p class=\"percent\">")
          formatted_issue[c.caption] = c.value_object(i).to_s
        elsif c.name.to_s == "subject"
          formatted_issue[c.caption] = strip_tags(column_content(c, i))
	elsif c.name.to_s.end_with?("_date") ||
	      (c.is_a?(QueryCustomFieldColumn) && c.custom_field.field_format == "date")
	  formatted_issue[c.caption] = column_content(c, i)
	  if column_content(c, i).to_s != ""
	    formatted_issue[c.caption+"(U)"] = Date.strptime(column_content(c, i),I18n.t(:"date.formats.default", {:locale => I18n.locale })).strftime("%Y-W%U")
	  else
	    formatted_issue[c.caption+"(U)"] = ""
	  end
        else
          formatted_issue[c.caption] = column_content(c, i)
        end
      }
      result_list.push(formatted_issue)
    }

    result_list 
  end

  def javascript_exists?(script)
    # Used to avoid Route Error in logs.
    script = "#{Rails.root}/public/plugin_assets/redmine_pivot_table/javascripts/#{script}"
    File.exists?(script) || File.exists?("#{script}.coffee") 
  end
end
