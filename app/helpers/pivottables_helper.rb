module PivottablesHelper
  def pv_caption(colname)
    col = @query.available_columns.find(){ |x| x.name == colname }
    unless col.nil? then
      col.caption
    end
  end
end
