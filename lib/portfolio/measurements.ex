defmodule Portfolio.Measurements do
  def dispatch_session_count() do
    # emit a telemetry event when called
    num_sessions = length(
      Pow.Store.CredentialsCache.users([otp_app: :portfolio], Portfolio.Accounts.User)
    )

    :telemetry.execute(
      [:portfolio, :session_count],
      %{count: num_sessions},
      {}
    )
  end
end