require 'helper'
require 'yahoo_ff'

class TestYahooFf < Test::Unit::TestCase

  def test_version
    version = YahooFf.const_get('VERSION')

    assert !version.empty?, 'should have a VERSION constant'
  end

end
