require "./type"

class SQL::QueryMaker::Condition < SQL::Condition
  alias AsSqlProc = (String?, (String -> String)) -> String

  getter bind : Array(SQL::Type)

  def initialize(@column : String?, @as_sql : AsSqlProc, @bind : Array(SQL::Type))
  end

  def as_sql(supplied_colname : String? = nil, quote_cb : (String -> String)? = nil) : String
    supplied_colname.try { |x| self.bind_column = x }
    @as_sql.call(@column, ->(label : String) { quote_identifier(label) })
  end

  def quote_identifier(label : String?) : String?
    label.try { |x| x.split('.').map { |s| "`#{s}`" }.join('.') }
  end

  def bind_column : String?
    @column
  end

  def bind_column=(column : String?) : String?
    @column = column
  end
end
