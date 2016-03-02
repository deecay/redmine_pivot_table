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
end
