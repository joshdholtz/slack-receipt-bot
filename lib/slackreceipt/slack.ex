defmodule SlackReceipt.Slack do
  use Slacker

  @slack_token Application.get_env(:slackreceipt, :slack)[:token]

  def handle_cast({:handle_incoming, "file_shared", msg}, state) do
    Logger.debug "A file was shared or something"
    IO.inspect msg
    # Slack info
    url = msg["file"]["permalink_public"]
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
    body = HTTPoison.get!(url).body
    File.write!(file_path, body)

    # Upload
    resp = SlackReceipt.Xero.post_file(file_path, "some_file")
    IO.inspect resp

    # Report back to channels about the thing
    channels = msg["file"]["channels"]
    Enum.each(channels, fn(channel) ->
      say self, channel, "Receipt has been uploaded to Xero :)"
    end)
    {:noreply, state}
  end

  def get_user(user_id) do
    url = "https://slack.com/api/users.info?token=#{@slack_token}&user=#{user_id}"
    HTTPoison.get!(url)
  end

end
