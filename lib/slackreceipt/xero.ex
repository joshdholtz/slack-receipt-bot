defmodule SlackReceipt.Xero do

  @consumer_key Application.get_env(:slackreceipt, :oauth)[:consumer_key]
  @consumer {@consumer_key, Application.get_env(:slackreceipt, :oauth)[:private_key_path], :rsa_sha1}

  def accounts do
    request(:get, "https://api.xero.com/api.xro/2.0/Accounts")
  end

  def files do
    request(:get, "https://api.xero.com/files.xro/1.0/Files")
  end

  def post_file(path_to_file, folder_id) do
    method = :post
    body = {:multipart, [{:file, path_to_file}] }
    headers = %{
    }
    options = []
    params = ["name": "name"]
    url = "https://api.xero.com/files.xro/1.0/Files"

    #request(:post, "https://api.xero.com/files.xro/1.0/Files/#{path_to_file}", [], body)

    # Creates signed params for oauth
    signed_params = :oauth.sign(
      Atom.to_string(method) |> String.upcase, String.to_char_list(url), params, @consumer, @consumer_key, ""
    )

   default_headers =  %{
      "Authorization": "OAuth #{:oauth.header_params_encode(signed_params)}",
      "Accept": "application/json",
    }

    headers = Map.merge(default_headers, headers)

    HTTPoison.post(url, {:multipart, [{:file, path_to_file}]}, headers, options)
  end

  def folders do
    request(:get, "https://api.xero.com/files.xro/1.0/Folders")
  end

  def create_folder(name) do
    body = %{name: name} |> Poison.encode!
    headers = %{
      "Content-Type": "application/json"
    }
    request(:post, "https://api.xero.com/files.xro/1.0/Folders", [], body, headers)
  end

  def request(method, url, params \\ [], body \\ "", headers \\ %{}, options \\ []) do
    # Creates signed params for oauth
    signed_params = :oauth.sign(
      Atom.to_string(method) |> String.upcase, String.to_char_list(url), params, @consumer, @consumer_key, ""
    )

    default_headers =  %{
      "Authorization": "OAuth #{:oauth.header_params_encode(signed_params)}",
      "Accept": "application/json"
    }

    headers = Map.merge(default_headers, headers)
    HTTPoison.request(method, url, body, headers, options)
  end
end
