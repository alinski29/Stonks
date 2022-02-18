"""
Modules defining data structues
"""

module Models

import Dates: Date

export FinancialData, AssetInfo, AssetPrice, ExchangeRate, EconomicIndicator

abstract type FinancialData end

struct AssetInfo <: FinancialData
  symbol::String
  currency::String
  name::Union{String, Missing}
  type::Union{String, Missing}
  exchange::Union{String, Missing}
  country::Union{String, Missing}
  industry::Union{String, Missing}
  sector::Union{String, Missing}
  timezone::Union{String, Missing}
  employees::Union{Int64, Missing}
end
function AssetInfo(; symbol, currency, name=missing, type=missing, exchange=missing, country=missing,
  industry=missing, sector=missing, timezone=missing, employees=missing)
  AssetInfo(symbol, currency, name, type, exchange, country, industry, sector, timezone, employees)
end

struct AssetPrice <: FinancialData
  symbol::String
  date::Date
  close::Float64
  open::Union{Float64, Missing}
  high::Union{Float64, Missing}
  low::Union{Float64, Missing}
  close_adjusted::Union{Float64, Missing}
  volume::Union{Float64, Missing}
  function AssetPrice(symbol, date, close, open=missing, high=missing, low=missing, close_adjusted=missing, volume = missing)
    new(symbol, date, close, open, high, low, close_adjusted, volume)
  end
end

function AssetPrice(; symbol, date, close,
    open=missing, high=missing, low=missing,
    close_adjusted=missing, volume = missing)
  AssetPrice(symbol, date, close, open, high, low, close_adjusted, volume)
end

struct ExchangeRate <: FinancialData 
  base::String
  target::String
  date::Date
  rate::Float64
end

struct EconomicIndicator <: FinancialData
  symbol::String
  name::String
  date::Date
  value::Date
end

# abstract type Transaction end
#
# struct Deposit <: Transaction
#   date::Date
#   currency::String
#   amount::Float64
# end
#
# struct CurrencyExchange <: Transaction
#   date::Date
#   from::String
#   to::String
#   rate::Float64
# end
#
#
#
# struct Buy <: Transaction
#   date::Date
#   asset::String
#   shares::Int64
#   share_price::Float64
#   comission::Float64
#   currency::String
#   amount::Float64
#   function Buy(date::Date, asset::String, shares::Int64, share_price::Float64, comission::Float64 = 0.0, currency::String = "USD")
#     return new(date, asset, shares, share_price, comission, currency, shares * share_price)
#   end
# end
#
# struct Sell <: Transaction
#   date::Date
#   asset::String
#   shares::Int64
#   share_price::Float64
#   commission::Float64
#   amount::Float64
#   function Sell(date::Date, asset::String, shares::Int64, share_price::Float64, comission::Float64 = 0.0)
#     return new(date, asset, shares, share_price, comission, shares * share_price)
#   end
# end
#
#
# struct Portfolio
#   name::String
#   holdings::Array{Transaction}
# end
# #get_assets(p::Portfolio)::Array{FinancialAsset} = map(x -> x.asset, p.holdings)
# # function get_data(p::Portfolio)::DataFrame
#
# # end

end