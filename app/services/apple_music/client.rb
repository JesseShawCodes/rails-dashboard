require "jwt"
require "faraday"
require "json"

module AppleMusic
  class Client
    APPLE_MUSIC_URL = "https://api.music.apple.com/v1".freeze
    def initialize
      creds = Rails.application.credentials.dig(:apple_music)   
      @key_id = creds[:key_id]
      @team_id = creds[:team_id]
      @private_key = OpenSSL::PKey::EC.new(creds[:private_key])

      @token = generate_token
      @connection = Faraday.new(url: APPLE_MUSIC_URL) do |faraday|
        faraday.headers["AUTHORIZATION"] = "Bearer #{@token}"
        faraday.adapter Faraday.default_adapter
      end
    end

    def generate_jwt
      payload = { iss: @team_id, iat: Time.now.to_i, exp: 6.months.from_now.to_i }
      headers = { alg: "ES256", kid: @key_id }
      JWT.encode(payload, @private_key, "ES256", headers)
    end

    def fetch_top_songs(user)
      real_api_call("/v1/me/top/songs")
    end

    def fetch_song(song_id:)
      get("/catalog/us/songs/#{song_id}")
    end

    def fetch_recently_played(user_token:)
      get("/me/recent/played/tracks", headers: { "Music-User-Token" => user_token})
    end

    private

    def real_api_call(path)
      response = Faraday.get("https://api.music.apple.com#{path}", nil, headers)
      JSON.parse(response.body)
    end

    def get(path, headers: {})
      response = @connection.get(path) do |req|
        headers.each { |k, v| req.headers[k] = v}
      end
      JSON.parse(response.body, symbolize_names: true)
    rescue Faraday::Error => each
      Rails.logger.error("AppleMusic::Client Error #{e.message}")
      {}
    end

    def generate_token
      key_id = @key_id
      team_id = @team_id
      # private_key = OpenSSL::PKey::EC.new(ENV.fetch("APPLE_MUSIC_PRIVATE_KEY"))
      private_key = @private_key

      payload = { iss: team_id, iat: Time.now.to_i, exp: 6.months.from_now.to_i }
      headers = { alg: "ES256", kid: key_id }

      JWT.encode(payload, private_key, "ES256", headers)
    end

    def headers
      {
        "Authorization" => "Bearer #{AppleMusic::TokenService.jwt}"
      }
    end

  end
end