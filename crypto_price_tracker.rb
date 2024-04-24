require 'httparty'
require 'json'

def fetch_crypto_data
  url = 'https://api.coingecko.com/api/v3/coins/markets'
  params = {
    vs_currency: 'usd',
    order: 'market_cap_desc',
    per_page: 5,
    page: 1
  }

  response = HTTParty.get(url, query: params)

  if response.code == 200
    JSON.parse(response.body)
  else
    puts "Error: #{response.code} - #{response.message}"
    nil
  end
end

def display_top_cryptos(cryptos)
  return puts "No cryptocurrency data found." if cryptos.nil? || cryptos.empty?

  puts "Top 5 Cryptocurrencies by Market Cap (CoinGecko API):"
  cryptos.each_with_index do |crypto, index|
    puts "##{index + 1}: #{crypto['name']}"
    puts "   Price: $#{crypto['current_price']}"
    puts "   Market Cap: $#{crypto['market_cap']}"
    puts "   ----------------------------------"
  end
end


cryptos = fetch_crypto_data

if cryptos
  display_top_cryptos(cryptos)
end
