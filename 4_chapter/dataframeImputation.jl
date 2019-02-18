using Random, Statistics
Random.seed!(0)
include("dataframeCreation.jl")

noTypePrice = (ismissing.(purchaseData[:Type])) .& 
	(ismissing.(purchaseData[:Price]))
purchaseData = purchaseData[.!noTypePrice,:]

purchaseData[ismissing.(purchaseData[:Name]), :Name] = "notRecorded"
purchaseData[ismissing.(purchaseData[:Time]), :Time] = "12:00 PM" 

types = unique(skipmissing(purchaseData[:Type])) 

for i in 1:size(purchaseData)[1]
	if ismissing(purchaseData[:Type][i]) 
		purchaseData[:Type][i] = rand(types) 
	end
end

for t in types
	prices = skipmissing(purchaseData[purchaseData[:Type] .== t, :Price])
	if !isempty(prices) 
		m = convert(Int,round(mean(prices)))
		for i in 1:size(purchaseData)[1]
			if (ismissing(purchaseData[:Price][i])) .& 
			   (purchaseData[:Type][i] == t)
				purchaseData[:Price][i] = m
			end	
		end  
	end
end

CSV.write("purchaseDataImputed.csv", purchaseData)
showcols(purchaseData)