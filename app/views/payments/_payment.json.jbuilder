json.extract! payment, :id, :payMethod, :date, :memberType, :memberShipExp, :amount, :created_at, :updated_at
json.url payment_url(payment, format: :json)