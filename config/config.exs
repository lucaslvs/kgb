use Mix.Config

config :crawly,
  concurrent_requests_per_domain: 5,
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["LucasBot"]}
  ],
  pipelines: [
    # {Crawly.Pipelines.Validate,
    #  fields: [
    #    :custumer_name,
    #    :content,
    #    :published_at,
    #    :rating,
    #    :custom_service,
    #    :quality_of_work,
    #    :friendliness,
    #    :pricing,
    #    :overall_experience,
    #    :recommendend_dealer,
    #    :mentioned_employees
    #  ]},
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, extension: "json", folder: "./"}
  ]

config :kgb, KGB.Spider,
  base_url: "https://www.dealerrater.com",
  dealer_path: System.get_env("DEALER_PATH", "McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685"),
  page_number: String.to_integer(System.get_env("PAGE_NUMBER", "5"))
