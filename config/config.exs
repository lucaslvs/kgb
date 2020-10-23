use Mix.Config

config :crawly,
  concurrent_requests_per_domain: 5,
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["LucasBot"]}
  ],
  pipelines: [
    {Crawly.Pipelines.Validate,
     fields: [
       :from,
       :content,
       :published_at,
       :rating,
       :custom_service,
       :quality_of_work,
       :friendliness,
       :pricing,
       :overall_experience,
       :recommendend_dealer,
       :mentioned_employees
     ]},
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, extension: "json", folder: "./"}
  ]
