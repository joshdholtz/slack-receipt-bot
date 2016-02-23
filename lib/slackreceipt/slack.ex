defmodule SlackReceipt.Slack do
  use Slacker

  def handle_cast({:handle_incoming, "file_shared", msg}, state) do
    Logger.debug "A file was shared or something"

    # TODO Download file and upload file to Xero

    #Exauth.sign("GET", "https://api.xero.com/api.xro/2.0/Accounts")

    #resp = Slackreceipt.Xero.get("https://api.xero.com/api.xro/2.0/Accounts", [])
  
    # http://oauth.net/core/1.0a/#anchor18
    # http://erlang.org/doc/man/public_key.html
    # :public_key.encrypt_private(M, K)

    {:noreply, state}
  end
end
