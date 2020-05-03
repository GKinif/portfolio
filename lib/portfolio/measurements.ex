defmodule Portfolio.Measurements do

  def dispatch_user_count() do
    # emit a telemetry event when called
    user_count = Portfolio.Accounts.count_user()

    :telemetry.execute(
      [:portfolio, :user_count],
      %{count: user_count},
      %{}
    )
  end
end