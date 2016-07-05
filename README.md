# SQL-QueryMaker [![Build Status](https://travis-ci.org/pine/crystal-sql-querymaker.svg?branch=master)](https://travis-ci.org/pine/crystal-sql-querymaker)
Helper functions for SQL query generation like Perl's [SQL::QueryMaker](https://github.com/kazuho/SQL-QueryMaker)

## Installation

Add this to your application's shard.yml:

```yaml
dependencies:
  sql-maker:
    github: pine/crystal-sql-maker
    branch: master
```

## Usage

```crystal
require "sql-maker"

include SQL::Maker::Helper

q = sql_eq("foo", 10)
puts q.as_sql #=> "`foo` = ?"
puts q.bind   #=> [10]
```

## Contributing

1. Fork it ( https://github.com/pine/crystal-sql-maker/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [pine](https://github.com/pine) Pine Mizune - creator, maintainer
