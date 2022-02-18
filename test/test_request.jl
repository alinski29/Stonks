using Test
import Dates: Day, today
import Pipe: @pipe

import Stonx: UpdatableSymbol, split_tickers_in_batches
import Stonx: APIClients, Requests

include("test_utils.jl")

@testset "Testing request utilities" begin

  test_client = APIClients.YahooClient("abc")

  @testset "Test ticker batching when all dates are missing" begin
    tickers = @pipe ["AAPL", "MSFT", "TSLA", "IBM"] |>
      map(t -> UpdatableSymbol(t), _)
    batches_max10 = split_tickers_in_batches(tickers, 10)
    batches_max2 = split_tickers_in_batches(tickers, 2)
    @test length(batches_max10) == 1
    @test length(batches_max2) == 2
  end

  # TODO - move it to test_utils.jl
  @testset "Test complex ticker batching" begin
    tickers = complex_tickers()
    batches = split_tickers_in_batches(tickers, 2)
    groups = @pipe batches |> map(batch -> map(t -> t.ticker, batch), _)
    @test length(batches) == 4
    @test groups == [["AAPL"], ["MSFT", "TSLA"], ["IBM", "GOOG"], ["NFLX"]]
  end

  @testset "Test request building using APIResource" begin
    tickers = complex_tickers()
    resource = test_client.endpoints["price"]
    resource.max_batch_size = 2
    request_params = Requests.prepare_requests(tickers, resource)
    @test length(request_params) == 4
    @test sum(map(r -> length(r.tickers), request_params)) == length(tickers)
  end

  @testset "Test request building using APIClient" begin
    tickers = complex_tickers()
    request_params = Requests.prepare_requests(tickers, test_client)
    @test isa(request_params, Dict)
    @test keys(request_params) == keys(test_client.endpoints)
  end

  @testset "Test resolution of url params" begin
    url = "https://example.com/{endpoint}/{symbol}?lang=en&symbol={symbol}"
    new_url = Requests.resolve_url_params(url, endpoint="quote", symbol="AAPL", foo="bar")
    @test new_url == "https://example.com/quote/AAPL?lang=en&symbol=AAPL"
  end

  @testset "Test resoltion of query parameters" begin 
    query_params = Dict("interval" => "{interval}", "range" => "{range}", "symbols" => "{symbols}", "content" => "json")
    params_resolved = Requests.resolve_query_params(query_params, interval="1d", range="30d", symbols="AAPL,MSFT")
    @test params_resolved["interval"] == "1d"
    @test params_resolved["symbols"] == "AAPL,MSFT"
    @test params_resolved["range"] == "30d"
    @test params_resolved["content"] == "json"
  end

  @testset "Test resolution of all request parameters (url, query, others)" begin
    resource = test_client.endpoints["price"]
    tickers = complex_tickers()
    request_params = Requests.prepare_requests(tickers, resource; interval="1d")
    @test length(request_params) == 4
    @test first(request_params).params["interval"] == "1d"
  end

  @testset "Tetst conversions of date to range expression" begin
    today = Dates.today()
    conv_fn = Requests.convert_date_to_range_expr
    @test conv_fn(today) == "1d"
    @test conv_fn(today - Dates.Day(2)) == "5d"
    @test conv_fn(today - Dates.Day(7)) == "1mo"
    @test conv_fn(today - Dates.Day(28)) == "1mo"
    @test conv_fn(today - Dates.Day(30)) == "3mo"
    @test conv_fn(today - Dates.Day(89)) == "6mo"
    @test conv_fn(today - Dates.Day(179)) == "6mo"
    @test conv_fn(today - Dates.Day(180)) == "1y"
    @test conv_fn(today - Dates.Day(364)) == "1y"
    @test conv_fn(today - Dates.Day(365)) == "5y"
    @test conv_fn(today - Dates.Day(5000)) == "5y"
  end

end