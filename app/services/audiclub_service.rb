class AudiclubService


  class << self
    attr_accessor :debug_model
    # 210881198909193316
    CHECK_URL = 'http://audiclubtest.faw-vw.com:8080/acms/own/checkxcgnh.do'

    def checkxcgnh( cardnumber=nil)
      RestClient.post(CHECK_URL, {'cardnumber' => 1}.to_json, {content_type: :json, accept: :json})
    end

    SIGNUP_URL = 'http://audiclubtest.faw-vw.com:8080/acms/own/signupxcgnh.do'
    def signupxcgnh

    end


    SUBSCORE_URL = 'http://audiclubtest.faw-vw.com:8080/acms/own/subscorexcgnh.do'
    def subscorexcgnh

    end

    USERVALIDATION_URL='http://wxtest.runlin.cn/acmswx/interfaces/uservalidation.do'
    def uservalidation
      request( USERVALIDATION_URL )

    end

    INITJSAPI_URL='http://wxtest.runlin.cn/acmswx/interfaces/initjsapi.do'
    def initjsapi
      request( INITJSAPI_URL ) do |data|
        puts data
      end
    end

    def request( url, method= 'get',  data={}, header={}, &_block )
      response  = nil
      if method == 'get'
        response = RestClient.get(url, {content_type: :json, accept: :json})
      else
        response = RestClient.post(url, data, {content_type: :json, accept: :json})
      end
      
      parse_response(response, :json) do |parse_as, data|
        yield data
      end
    end

    def debug_mode?
      !!@debug_model
    end

    def parse_response(response, as)
      content_type = response.headers[:content_type]
      parse_as = {
        %r{^application\/json} => :json,
        %r{^image\/.*}         => :file,
        %r{^audio\/.*}         => :file,
        %r{^voice\/.*}         => :file,
        %r{^text\/html}        => :xml,
        %r{^text\/plain}       => :probably_json
      }.each_with_object([]) { |match, memo| memo << match[1] if content_type =~ match[0] }.first || as || :text

      # try to parse response as json, fallback to user-specified format or text if failed
      if parse_as == :probably_json
        data = JSON.parse response.body.to_s.gsub(/[\u0000-\u001f]+/, '') rescue nil
        if data
          return yield(:json, data)
        else
          parse_as = as || :text
        end
      end

      case parse_as
      when :file
        file = Tempfile.new('tmp')
        file.binmode
        file.write(response.body)
        file.close
        data = file

      when :json
        data = JSON.parse response.body.to_s.gsub(/[\u0000-\u001f]+/, '')
      when :xml
        data = Hash.from_xml(response.body.to_s)
      else
        data = response.body
      end

      yield(parse_as, data)
    end

  end
end
