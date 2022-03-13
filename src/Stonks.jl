module Stonks

include("utils.jl")
include("errors.jl")
include("Models.jl")
include("Parsers.jl")
include("APIClients.jl")
include("Requests.jl")
include("curl.jl")
include("conversions.jl")
include("Stores.jl")

using Stonks.Models
using Stonks.Parsers
using Stonks.APIClients
using Stonks.Stores

export AbstractStonksRecord, AssetInfo, AssetPrice, ExchangeRate
export AlphavantageJSONClient, YahooClient
export get_price, get_info, get_exchange_rate, get_data, to_dataframe
export FileStore, load, save, update

end