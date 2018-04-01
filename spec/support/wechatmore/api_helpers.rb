module Wechatmore
  module ApiHelpers

    def assert_unauthorized!
      expect(json_response).to eq({ "error" => "You are not authorized to perform that action." })
      expect(response.status).to eq 401
    end

    def stub_authenticate_with_api_key
      allow(User).to receive(:find_by).with(hash_including(:api_key)) { current_api_user }
    end

    # This method can be overriden (with a let block) inside a context
    # For instance, if you wanted to have an admin user instead.
    def current_api_user
      @current_api_user ||= stub_model(User, email: "tester@example.com")
    end

    def image(filename)
      File.open(Rails.application.root + "spec/fixtures" + filename)
    end

    def upload_image(filename)
      fixture_file_upload(image(filename).path, 'image/jpg')
    end
  end
end
