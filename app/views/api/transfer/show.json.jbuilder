json.(@transfer, :id, :amount, :from, :to, :description, :date)
json.source @transfer.source.name
json.target @transfer.target.name