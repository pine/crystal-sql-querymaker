require "./factory"

module SQL::QueryMaker::Helper
  def sql_op(expr : String, args : Array(SQL::Type))
    SQL::QueryMaker::Factory.make_operator("sql_op", expr, nil, args)
  end

  def sql_op(column : String, expr : String, args : Array(SQL::Type))
    SQL::QueryMaker::Factory.make_operator("sql_op", expr, column, args)
  end

  # ===========================================================================

  def sql_not(column : String? = nil)
    SQL::QueryMaker::Factory.make_operator("sql_not", "NOT @", column, [] of SQL::Type)
  end

  # ===========================================================================

  def sql_raw(sql : String, bind_values : Array(SQL::Type))
    SQL::QueryMaker::Factory.make_raw(sql, bind_values)
  end

  def sql_raw(sql : String, *bind_values : SQL::Type)
    sql_raw(sql, bind_values.to_a.map { |x| x.as(SQL::Type) })
  end

  # ===========================================================================

  {% for opts in {
                   {:sql_eq, "= ?"},
                   {:sql_ne, "!= ?"},
                   {:sql_lt, "< ?"},
                   {:sql_gt, "> ?"},
                   {:sql_le, "<= ?"},
                   {:sql_ge, ">= ?"},
                   {:sql_like, "LIKE ?"},
                 } %}

  def {{opts[0].id}}(value : SQL::Type)
    SQL::QueryMaker::Factory.make_operator({{opts[0].stringify}}, {{opts[1]}}, nil, [ value ] of SQL::Type)
  end

  def {{opts[0].id}}(column : String?, value : SQL::Type)
    SQL::QueryMaker::Factory.make_operator({{opts[0].stringify}}, {{opts[1]}}, column, [ value ] of SQL::Type)
  end

  {% end %}

  # ===========================================================================

  {% for opts in {
                   {:sql_is_null, "IS NULL"},
                   {:sql_is_not_null, "IS NOT NULL"},
                 } %}

  def {{opts[0].id}}(column : String? = nil)
    SQL::QueryMaker::Factory.make_operator({{opts[0].stringify}}, {{opts[1]}}, column, [] of SQL::Type)
  end

  {% end %}

  # ===========================================================================

  {% for opts in {
                   {:sql_in, "IN"},
                   {:sql_not_in, "NOT IN"},
                 } %}

  def {{opts[0].id}}(column : String, values : Array(SQL::Type))
    SQL::QueryMaker::Factory.make_in({{opts[0].stringify}}, {{opts[1]}}, column, values)
  end

  def {{opts[0].id}}(column : String, *values : SQL::Type)
    SQL::QueryMaker::Factory.make_in(
      {{opts[0].stringify}}, {{opts[1]}}, column,
      values.to_a.map { |x| x.as(SQL::Type) }
    )
  end

  {% end %}

  # ===========================================================================

  {% for opts in {
                   {:sql_and, "AND"},
                   {:sql_or, "OR"},
                 } %}

  def {{opts[0].id}}(values : Array(SQL::Type))
    SQL::QueryMaker::Factory.make_multi({{opts[0].id.stringify}}, {{opts[1]}}, nil, values)
  end

  def {{opts[0].id}}(column : String?, values : Array(SQL::Type))
    SQL::QueryMaker::Factory.make_multi({{opts[0].id.stringify}}, {{opts[1]}}, column, values)
  end

  {% end %}
end
