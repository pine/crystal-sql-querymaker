require "../spec_helper"

include SQL::QueryMaker::Helper

describe "SQL::QueryMaker::Helper" do
  describe "sql_eq" do
    it "single" do
      query = sql_eq("bar")
      query.as_sql("foo").should eq "`foo` = ?"
      query.bind.should eq ["bar"] of SQL::Type
    end

    it "double" do
      query = sql_eq("foo", "bar")
      query.as_sql.should eq "`foo` = ?"
      query.bind.should eq ["bar"] of SQL::Type
    end
  end

  describe "sql_ne" do
    it "single" do
      query = sql_ne("bar")
      query.as_sql("foo").should eq "`foo` != ?"
      query.bind.should eq ["bar"] of SQL::Type
    end

    it "double" do
      query = sql_ne("foo", "bar")
      query.as_sql.should eq "`foo` != ?"
      query.bind.should eq ["bar"] of SQL::Type
    end
  end

  describe "sql_lt" do
    it "single" do
      query = sql_lt(5)
      query.as_sql("foo").should eq "`foo` < ?"
      query.bind.should eq [5] of SQL::Type
    end

    it "double" do
      query = sql_lt("foo", 5)
      query.as_sql.should eq "`foo` < ?"
      query.bind.should eq [5] of SQL::Type
    end
  end

  describe "sql_gt" do
    it "single" do
      query = sql_gt(5)
      query.as_sql("foo").should eq "`foo` > ?"
      query.bind.should eq [5] of SQL::Type
    end

    it "double" do
      query = sql_gt("foo", 5)
      query.as_sql.should eq "`foo` > ?"
      query.bind.should eq [5] of SQL::Type
    end
  end

  describe "sql_le" do
    it "single" do
      query = sql_le(5)
      query.as_sql("foo").should eq "`foo` <= ?"
      query.bind.should eq [5] of SQL::Type
    end

    it "double" do
      query = sql_le("foo", 5)
      query.as_sql.should eq "`foo` <= ?"
      query.bind.should eq [5] of SQL::Type
    end
  end

  describe "sql_ge" do
    it "single" do
      query = sql_ge(5)
      query.as_sql("foo").should eq "`foo` >= ?"
      query.bind.should eq [5] of SQL::Type
    end

    it "double" do
      query = sql_ge("foo", 5)
      query.as_sql.should eq "`foo` >= ?"
      query.bind.should eq [5] of SQL::Type
    end
  end

  describe "sql_like" do
    it "single" do
      query = sql_like("bar")
      query.as_sql("foo").should eq "`foo` LIKE ?"
      query.bind.should eq ["bar"] of SQL::Type
    end

    it "double" do
      query = sql_like("foo", "bar")
      query.as_sql.should eq "`foo` LIKE ?"
      query.bind.should eq ["bar"] of SQL::Type
    end
  end

  describe "sql_not" do
    it "single" do
      query = sql_not
      query.as_sql("foo").should eq "NOT `foo`"
      query.bind.should eq [] of SQL::Type
    end

    it "double" do
      query = sql_not("foo")
      query.as_sql.should eq "NOT `foo`"
      query.bind.should eq [] of SQL::Type
    end
  end

  describe "sql_is_null" do
    it "single" do
      query = sql_is_null
      query.as_sql("foo").should eq "`foo` IS NULL"
      query.bind.should eq [] of SQL::Type
    end

    it "double" do
      query = sql_is_null("foo")
      query.as_sql.should eq "`foo` IS NULL"
      query.bind.should eq [] of SQL::Type
    end
  end

  describe "sql_is_not_null" do
    it "single" do
      query = sql_is_not_null("foo")
      query.as_sql.should eq "`foo` IS NOT NULL"
      query.bind.should eq [] of SQL::Type
    end

    it "double" do
      query = sql_is_not_null("foo")
      query.as_sql.should eq "`foo` IS NOT NULL"
      query.bind.should eq [] of SQL::Type
    end
  end

  describe "sql_raw" do
    it "array" do
      query = sql_raw("SELECT * FROM t WHERE id=?", [123] of SQL::Type)
      query.as_sql.should eq "SELECT * FROM t WHERE id=?"
      query.bind.should eq [123] of SQL::Type
    end

    it "vargs" do
      query = sql_raw("SELECT * FROM t WHERE id=?", 123)
      query.as_sql.should eq "SELECT * FROM t WHERE id=?"
      query.bind.should eq [123] of SQL::Type
    end
  end

  describe "sql_in" do
    it "empty" do
      query = sql_in("foo", [] of SQL::Type)
      query.as_sql.should eq "0=1"
      query.bind.should eq [] of SQL::Type
    end

    it "array" do
      query = sql_in("foo", ["bar", "baz"] of SQL::Type)
      query.as_sql.should eq "`foo` IN (?,?)"
      query.bind.should eq ["bar", "baz"] of SQL::Type
    end

    it "vargs" do
      query = sql_in("foo", "bar", "baz")
      query.as_sql.should eq "`foo` IN (?,?)"
      query.bind.should eq ["bar", "baz"] of SQL::Type
    end
  end

  describe "sql_not_in" do
    it "empty" do
      query = sql_not_in("foo", [] of SQL::Type)
      query.as_sql.should eq "1=1"
      query.bind.should eq [] of SQL::Type
    end

    it "array" do
      query = sql_not_in("foo", ["bar", "baz"] of SQL::Type)
      query.as_sql.should eq "`foo` NOT IN (?,?)"
      query.bind.should eq ["bar", "baz"] of SQL::Type
    end

    it "vargs" do
      query = sql_not_in("foo", "bar", "baz")
      query.as_sql.should eq "`foo` NOT IN (?,?)"
      query.bind.should eq ["bar", "baz"] of SQL::Type
    end
  end

  describe "sql_and" do
    it "empty #1" do
      query = sql_and([] of SQL::Type)
      query.as_sql("foo").should eq "0=1"
      query.bind.should eq [] of SQL::Type
    end

    it "empty #2" do
      query = sql_and("foo", [] of SQL::Type)
      query.as_sql.should eq "0=1"
      query.bind.should eq [] of SQL::Type
    end

    it "conditions #1" do
      query = sql_and([sql_ge("foo", 0), sql_lt("bar", 10)] of SQL::Type)
      query.as_sql.should eq "(`foo` >= ?) AND (`bar` < ?)"
      query.bind.should eq [0, 10] of SQL::Type
    end

    it "conditions #2" do
      query = sql_and([sql_ge(0), sql_lt(10)] of SQL::Type)
      query.as_sql("foo").should eq "(`foo` >= ?) AND (`foo` < ?)"
      query.bind.should eq [0, 10] of SQL::Type
    end

    it "with column" do
      query = sql_and("foo", [sql_ge(0), sql_lt(10)] of SQL::Type)
      query.as_sql.should eq "(`foo` >= ?) AND (`foo` < ?)"
      query.bind.should eq [0, 10] of SQL::Type
    end
  end

  describe "sql_or" do
    it "empty #1" do
      query = sql_or([] of SQL::Type)
      query.as_sql("foo").should eq "1=1"
      query.bind.should eq [] of SQL::Type
    end

    it "empty #2" do
      query = sql_or("foo", [] of SQL::Type)
      query.as_sql.should eq "1=1"
      query.bind.should eq [] of SQL::Type
    end

    it "conditions #1" do
      query = sql_or([sql_eq("foo", 1), sql_eq("bar", 2)] of SQL::Type)
      query.as_sql.should eq "(`foo` = ?) OR (`bar` = ?)"
      query.bind.should eq [1, 2] of SQL::Type
    end

    it "conditions #2" do
      query = sql_or([sql_ge(0), sql_lt(10)] of SQL::Type)
      query.as_sql("foo").should eq "(`foo` >= ?) OR (`foo` < ?)"
      query.bind.should eq [0, 10] of SQL::Type
    end

    it "with column" do
      query = sql_or("foo", [sql_ge(0), sql_lt(10)] of SQL::Type)
      query.as_sql.should eq "(`foo` >= ?) OR (`foo` < ?)"
      query.bind.should eq [0, 10] of SQL::Type
    end
  end

  describe "sql_op" do
    it "single" do
      query = sql_op("MATCH (@) AGAINST (?)", ["oranges"] of SQL::Type)
      query.as_sql("apples").should eq "MATCH (`apples`) AGAINST (?)"
    end

    it "double" do
      query = sql_op("apples", "MATCH (@) AGAINST (?)", ["oranges"] of SQL::Type)
      query.as_sql.should eq "MATCH (`apples`) AGAINST (?)"
    end
  end
end
