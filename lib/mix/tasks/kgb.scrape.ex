defmodule Mix.Tasks.Kgb.Scrape do
  @moduledoc false

  use Mix.Task

  @impl Mix.Task
  def run(_arguments) do
    Application.ensure_all_started(:kgb)
    KGB.print_top_three_reviews_overly_positive()
  end
end
