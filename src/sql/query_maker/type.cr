abstract class SQL::Convertible
  abstract def as_sql : String
end

abstract class SQL::Condition < SQL::Convertible
  abstract def bind : Array(SQL::Type)
  abstract def bind_column : String?
  abstract def bind_column=(column : String?) : String?
  abstract def as_sql(
                      column : String?,
                      quote_cb : (String -> String)?) : String

  def as_sql
    as_sql(nil, nil)
  end
end

module SQL::Mixin::Condition::Function
  def bind : Array(SQL::Type)
    [] of SQL::Type
  end

  def bind_column : String?
    nil
  end

  def bind_column=(column : String?) : String?
    nil
  end
end

class SQL::QueryMaker::NoColumnBindingError < ArgumentError
  def initialize(fn : String)
    super("no column binding for #{fn}(args...)")
  end
end

class SQL::QueryMaker::BindingValuesCountError < ArgumentError
  def initialize(num_args : Int)
    super("the operator expects #{num_args} but got ")
  end
end

module SQL
  alias Type = String | Nil | Bool | Int32 | Float32 | Float64 | Time | SQL::Convertible
end
