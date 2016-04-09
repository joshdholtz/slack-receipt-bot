defmodule SlackReceipt.Slack do
  use Slacker

  def handle_cast({:handle_incoming, "file_shared", msg}, state) do
    Logger.debug "A file was shared or something"

    url = msg["file"]["permalink_public"]

    IO.inspect msg
    IO.inspect url

    file_path = "/tmp/#{:os.system_time(:seconds)}.png"

    IO.inspect file_path

    body = HTTPoison.get!(url).body
    File.write!(file_path, body)

    IO.puts "About to upload"

    resp = SlackReceipt.Xero.post_file(file_path, "some_file")

    IO.inspect resp

    {:noreply, state}
  end
end
