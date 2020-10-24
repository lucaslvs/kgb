# KGB

> A Dealer for The People

This project is a Crawler that scrapes some reviews posted in [DealerRater](https://www.dealerrater.com/) from dealer [McKaig Chevrolet Buick](https://www.mckaig.net/) and prints the top three overly positive.

The Crawler was built with [Crawly](https://github.com/oltarasenko/crawly) and [Floki](https://github.com/philss/floki) packages.

## Requirements

- `Elixir 1.10` or greater

## Usage

To perform the crawler, open your terminal follow the steps below:

- install the dependencies

  ```sh
  mix deps.get
  ```

- Run the crawler and see the top three overly positive endorsements

  ```sh
  mix kgb.scrape
  ```

## Testing

```sh
mix test
```
