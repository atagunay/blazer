require_relative "../test_helper"

class BigqueryTest < ActionDispatch::IntegrationTest
  include AdapterTest

  def data_source
    "bigquery"
  end

  def test_run
    assert_result [{"hello" => "world"}], "SELECT 'world' AS hello"
  end

  def test_audit
    assert_audit "SELECT ? AS hello\n\n[\"world\"]", "SELECT {var} AS hello", var: "world"
  end

  def test_string
    assert_result [{"hello" => "world"}], "SELECT {var} AS hello", var: "world"
  end

  def test_integer
    assert_result [{"hello" => "1"}], "SELECT {var} AS hello", var: "1"
  end

  def test_float
    assert_result [{"hello" => "1.5"}], "SELECT {var} AS hello", var: "1.5"
  end

  def test_time
    assert_result [{"hello" => "2022-01-01 08:00:00 UTC"}], "SELECT {created_at} AS hello", created_at: "2022-01-01 08:00:00"
  end

  # TODO fix
  def test_nil
    assert_error "nil params are not supported, must assign optional type", "SELECT {var} AS hello", var: ""
  end

  def test_single_quote
    assert_result [{"hello" => "'"}], "SELECT {var} AS hello", var: "'"
  end

  def test_double_quote
    assert_result [{"hello" => '"'}], "SELECT {var} AS hello", var: '"'
  end

  def test_backslash
    assert_result [{"hello" => "\\"}], "SELECT {var} AS hello", var: "\\"
  end

  def test_bad_position
    assert_bad_position "SELECT 'world' AS {var}", var: "hello"
  end

  # does not raise error for too many params
  def test_quoted
    assert_result [{"hello" => "?"}], "SELECT '{var}' AS hello", var: "world"
  end
end
