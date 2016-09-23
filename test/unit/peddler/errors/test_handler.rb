require 'helper'
require 'peddler/errors/handler'

class TestPeddlerErrorsHandler < MiniTest::Test
  def setup
<<<<<<< HEAD
    Peddler::Errors::Handler.call(@cause)
=======
    @error = Peddler::Errors::Handler.call(@cause)
>>>>>>> upstream/master
  rescue => @error
  end

  class CausedByHTTPStatusError < TestPeddlerErrorsHandler
    def setup
      @code = 'FeedProcessingResultNotReady'
      @message = 'Feed Submission Result is not ready for Feed 123'
<<<<<<< HEAD
      @cause = Excon::Errors::NotFound.new(
=======
      @cause = Excon::Error::NotFound.new(
>>>>>>> upstream/master
        'Expected(200) <=> Actual(404 Not Found)',
        nil,
        OpenStruct.new(code: @code, message: @message)
      )
      super
    end

    def test_generates_custom_error
      assert_includes @error.class.name, @code
    end

    def test_provides_message
      assert_equal @message, @error.message
    end

    def test_provides_cause
      assert_equal @cause, @error.cause
    end
  end

  class CausedByAnotherError < TestPeddlerErrorsHandler
    def setup
      @cause = StandardError.new
      super
    end

    def test_returns_original_error
      assert_equal @cause, @error
    end
  end
<<<<<<< HEAD
=======

  class CausedByInternalServerError < TestPeddlerErrorsHandler
    def setup
      @cause = Excon::Error::InternalServerError.new(
        nil,
        nil,
        OpenStruct.new(code: '500', message: nil)
      )
      super
    end

    def test_returns_original_error
      assert_equal @cause, @error
    end
  end
>>>>>>> upstream/master
end
