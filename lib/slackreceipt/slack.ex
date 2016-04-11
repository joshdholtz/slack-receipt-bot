defmodule SlackReceipt.Slack do
  use Slacker

  @slack_token Application.get_env(:slackreceipt, :slack)[:token]
  @slack_channel_id Application.get_env(:slackreceipt, :slack)[:channel_id]

  def handle_cast({:handle_incoming, "file_shared", msg}, state) do
    Logger.debug "A file was shared or something"
    IO.inspect msg

    #Enum.find(channels, fn(%{"name"=>name}) -> name == "receipts"end)

    channels = msg["file"]["channels"]
    if Enum.member?(channels, @slack_channel_id) do
      send_image(msg, state, channels)
    end

    {:noreply, state}
  end

  def send_image(msg, state, channels) do
    # Slack info
    url = msg["file"]["url_private_download"]
    user_id = msg["file"]["user"]
    title = msg["file"]["title"]
    name = msg["file"]["name"]

    user_name = Poison.decode!(get_user(user_id).body)["user"]["name"]

    IO.inspect user_name

    # File path
    file_name = "#{user_name}_#{:os.system_time(:seconds)}_#{name}"
    file_path = "/tmp/#{file_name}"

    IO.inspect file_path

    # Download and save
    body = HTTPoison.get!(url, %{"Authorization": "Bearer #{@slack_token}"}).body
    File.write!(file_path, body)

    # Upload
    resp = SlackReceipt.Xero.post_file(file_path, "some_file")
    IO.inspect resp

    # Report back to channels about the thing
    Enum.each(channels, fn(channel) ->
      say self, channel, "Receipt has been uploaded to Xero :)"
    end)
  end

  def get_user(user_id) do
    url = "https://slack.com/api/users.info?token=#{@slack_token}&user=#{user_id}"
    HTTPoison.get!(url)
  end

  def get_channels do
    url = "https://slack.com/api/channels.list?token=#{@slack_token}"
    HTTPoison.get!(url)
  end

end
