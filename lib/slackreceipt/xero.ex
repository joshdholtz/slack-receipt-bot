defmodule SlackReceipt.Xero do

  @consumer_key Application.get_env(:slackreceipt, :oauth)[:consumer_key]
  @consumer {@consumer_key, Application.get_env(:slackreceipt, :oauth)[:private_key_path], :rsa_sha1}

  def accounts do
    request(:get, "https://api.xero.com/api.xro/2.0/Accounts")
  end

  def request(method, url, params \\ [], body \\ %{}, headers \\ %{}, options \\ []) do
    # Creates signed params for oauth
    signed_params = :oauth.sign(
      Atom.to_string(method) |> String.upcase, String.to_char_list(url), params, @consumer, @consumer_key, ""
    )

    default_headers =  %{
      "Authorization": "OAuth #{:oauth.header_params_encode(signed_params)}",
      "Accept": "application/json"
    }

    headers = Map.merge(default_headers, headers)

    HTTPoison.request(method, url, "", headers, options)
  end
end
