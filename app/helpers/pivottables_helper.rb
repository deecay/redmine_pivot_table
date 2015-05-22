module PivottablesHelper
  def pv_caption(colname)
    @query.available_columns.find(){ |x| x.name == colname }.caption
  end
end
