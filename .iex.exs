alias KGB.{Employee, Review, Spider}

{:ok, %HTTPoison.Response{body: body}} = HTTPoison.get("https://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/page5")
{:ok, document} = Floki.parse_document(body)
review_document = document |> Floki.find("div.review-entry")
