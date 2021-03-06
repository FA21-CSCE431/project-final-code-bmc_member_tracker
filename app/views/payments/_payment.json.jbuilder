# frozen_string_literal: true

json.extract! payment, :id, :method, :date, :memberType, :memberShipExp, :amount, :notes, :created_at, :updated_at
json.url payment_url(payment, format: :json)
