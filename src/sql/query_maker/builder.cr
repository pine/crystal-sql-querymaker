class SQL::QueryMaker::Builder
  getter num_args : Int32
  @exprs : Array(String)

  def initialize(expr : String)
    expr = "@ #{expr}" if /@/ !~ expr
    @num_args = expr.count('?')
    @exprs = expr.split('@')
  end

  def call(column : String) : String
    @exprs.join(column)
  end
end
