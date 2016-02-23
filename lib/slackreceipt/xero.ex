defmodule SlackReceipt.Xero do
  @consumer_key Application.get_env(:slackreceipt, :oauth)[:consumer_key]
  @consumer {@consumer_key, Application.get_env(:slackreceipt, :oauth)[:private_key_path], :rsa_sha1}

  def get(url, params, headers \\ %{}), do: request(:get, url, params, "", headers)
  def post(url, params, body \\ "", headers \\ %{}), do: request(:post, url, params, body, headers)
  def put(url, params, body \\ "", headers \\ %{}), do: request(:put, url, params, body, headers)
  def delete(url, params, headers \\ %{}), do: request(:delete, url, params, "", headers)

  def request(method, url, params, body \\ %{}, headers \\ %{}) do

    # Creates signed params for oauth
    signed_params = :oauth.sign(
      Atom.to_string(method) |> String.upcase, url, params, @consumer, @consumer_key, ""
    )

    # Creates headers
    headers = Dict.merge(headers, %{
      "Authorization": "OAuth #{:oauth.header_params_encode(signed_params)}",
      "Accept": "application/json"
    }) |> Enum.reduce([], fn ({k,v}, a) -> 
      a ++ [{Atom.to_string(k), v}]
    end)

    HTTPoison.request(method, url, "", headers)
  end
end
