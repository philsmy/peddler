require 'delegate'
require 'csv'
require 'digest/md5'

module Peddler
  # @api private
  class FlatFileParser < SimpleDelegator
    # http://stackoverflow.com/questions/8073920/importing-csv-quoting-error-is-driving-me-nuts
    OPTIONS = { col_sep: "\t", quote_char: "\x00", headers: true }.freeze

    attr_reader :content, :summary, :old_encoding

    def initialize(res, encoding)
      super(res)
      @old_encoding = encoding
      extract_content
    end

    def parse(&blk)
      CSV.parse(scrub_content, OPTIONS, &blk) if content
    end

    def records_count
      summarize if summary?
    end

    def valid?
      headers['Content-MD5'] == Digest::MD5.base64digest(body)
    end

    private

    def extract_content
      if summary?
        @summary, @content = body.split("\n\n")
      else
        @content = body.dup
      end
    end

    def scrub_content
      content
        .force_encoding(encoding)
        .encode('UTF-8', undef: :replace, replace: '?')
    end

    def summary?
      body.include?("\n\n")
    end

    def summarize
      Hash[summary.split("\n\t")[1, 2].map { |line| line.split("\t\t") }]
    end
    
    def encoding
      if headers["Content-Type"].present?
        headers["Content-Type"][/charset=(.+)/]
        
        return $1
      else
        @old_encoding
      end
    end
  end
end
