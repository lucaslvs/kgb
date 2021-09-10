use Mix.Config

dealer_path =
  System.get_env(
    "DEALER_PATH",
    "McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685"
  )

page_number = String.to_integer(System.get_env("PAGE_NUMBER", "5"))

if page_number < 1 do
  raise """
  Environment variable PAGE_NUMBER should be equal or greater than 1.
  """
end

config :kgb, KGB.Spider,
  base_url: "https://www.dealerrater.com",
  dealer_path: dealer_path,
  page_number: page_number

config :crawly,
  concurrent_requests_per_domain: page_number,
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["LucasBot"]}
  ],
  pipelines: [
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, extension: "json", folder: "./", include_timestamp: false}
  ]
