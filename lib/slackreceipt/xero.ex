defmodule SlackReceipt.Xero do
  @consumer {Application.get_env(:slackreceipt, :oauth)[:consumer_key], Application.get_env(:slackreceipt, :oauth)[:private_key_path], :rsa_sha1}

  def get(url, params) do
    #authorization_header = :oauth.sign(
    #   "GET", url, params, @consumer, Application.get_env(:slackreceipt, :oauth)[:consumer_key], ""
    #  ) |> Enum.map( fn {k,v} ->
      #    "#{k}=\"#{v}\""
      #end) |> Enum.join("=")

    signed_params = :oauth.sign(
      "GET", url, params, @consumer, Application.get_env(:slackreceipt, :oauth)[:consumer_key], ""
    )
   
    headers = %{
      "Authorization": "OAuth #{:oauth.header_params_encode(signed_params)}",
      "Accept": "application/json"
    }

    uri = :oauth.uri(url, signed_params)

    HTTPoison.get(url, headers)
  end
end
