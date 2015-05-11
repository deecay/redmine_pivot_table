module PivottablesHelper
  def to_caption(query, colname)
    query.available_columns.find(){ |x| x.name == colname }.caption
  end
end
