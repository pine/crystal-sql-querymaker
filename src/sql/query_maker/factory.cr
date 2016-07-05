require "./type"
require "./condition"

module SQL::QueryMaker::Factory
  def self.make_operator(
                         fn : String,
                         expr : String,
                         column : String?,
                         bind_values : Array(SQL::Type) = [] of SQL::Type) : SQL::QueryMaker::Condition
    builder = SQL::QueryMaker::Builder.new(expr)

    if bind_values.size != builder.num_args
      raise BindingValuesCountError.new(builder.num_args)
    end

    Condition.new(
      column,
      ->(column : String?, quote_cb : (String -> String)) {
        raise NoColumnBindingError.new(fn) if column.nil?
        builder.call(quote_cb.call(column.not_nil!))
      },
      bind_values
    )
  end

  def self.make_raw(
                    sql : String,
                    bind_values : Array(SQL::Type)) : SQL::QueryMaker::Condition
    SQL::QueryMaker::Condition.new(
      nil,
      ->(column : String?, quote_cb : (String -> String)) { sql },
      bind_values
    )
  end

  def self.make_in(
                   fn : String,
                   op : String,
                   column : String?,
                   values : Array(SQL::Type)) : SQL::QueryMaker::Condition
    as_sql = ->(column : String?, quote_cb : (String -> String)) {
      raise NoColumnBindingError.new(fn) if column.nil?

      if values.size == 0
        op == "IN" ? "0=1" : "1=1"
      else
        terms = [] of String
        values.each do |arg|
          if convertible = arg.as?(SQL::Condition)
            term = convertible.as_sql(column.not_nil!, quote_cb)
            terms.push(term == "?" ? term : "(#{term})")
          else
            terms.push("?")
          end
        end
        quote_cb.call(column.not_nil!) + " #{op} (" + terms.join(',') + ")"
      end
    }

    bind_values = [] of SQL::Type
    values.each do |arg|
      if convertible = arg.as?(SQL::Condition)
        convertible.bind.each { |x| bind_values.push(x) }
      else
        bind_values.push(arg)
      end
    end

    SQL::QueryMaker::Condition.new(
      column,
      as_sql,
      bind_values
    )
  end

  def self.make_multi(
                      fn : String,
                      op : String,
                      column : String?,
                      values : Array(SQL::Type)) : SQL::QueryMaker::Condition
    as_sql = ->(column : String?, quote_cb : (String -> String)) {
      if values.size == 0
        op == "AND" ? "0=1" : "1=1"
      else
        terms = [] of String
        values.each do |arg|
          if convertible = arg.as?(SQL::Condition)
            term = convertible.as_sql(column, quote_cb)
            terms.push("(#{term})")
          else
            raise NoColumnBindingError.new(fn) if column.nil?
            terms.push("(" + quote_cb.call(column.not_nil!) + " = ?)")
          end
        end
        terms.join(" #{op} ")
      end
    }

    bind_values = [] of SQL::Type
    values.each do |arg|
      if convertible = arg.as?(SQL::Condition)
        convertible.bind.each { |x| bind_values.push(x) }
      else
        bind_values.push(arg)
      end
    end

    SQL::QueryMaker::Condition.new(
      column,
      as_sql,
      bind_values
    )
  end
end
