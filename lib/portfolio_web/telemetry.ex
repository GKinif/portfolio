defmodule PortfolioWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
      # Add reporters as children of your supervision tree.
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      # App Metrics
      counter("portfolio.render.controller",  tags: [:controller, :action]),

      # User metrics
      # summary("portfolio.user_count.count"),

      # Database Metrics
      summary("portfolio.repo.query.total_time", unit: {:native, :millisecond}),
      summary("portfolio.repo.query.decode_time", unit: {:native, :millisecond}),
      summary("portfolio.repo.query.query_time", unit: {:native, :millisecond}),
      summary("portfolio.repo.query.queue_time", unit: {:native, :millisecond}),
      summary("portfolio.repo.query.idle_time", unit: {:native, :millisecond}),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :megabyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io"),
    ]
  end

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      # This function must call :telemetry.execute/3 and a metric must be added above.
      # {Portfolio.Measurements, :dispatch_user_count, []}
    ]
  end
end
