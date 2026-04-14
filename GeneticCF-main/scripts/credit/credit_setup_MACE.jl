using CSV, Statistics, DataFrames, MLJ, MLJLinearModels

@load LogisticClassifier pkg=MLJLinearModels

data = CSV.File(joinpath(@__DIR__, "../../data/credit/credit_processed.csv")) |> DataFrame
y, X = unpack(data, ==(:NoDefaultNextMonth), colname -> true);

# change the input to the type they want
coerce!(X,
        :isMale => Count,
        :isMarried => Count,
        :AgeGroup => Count,
        :EducationLevel => Count,
        :MaxBillAmountOverLast6Months => Continuous,
        :MaxPaymentAmountOverLast6Months => Continuous,
        :MonthsWithZeroBalanceOverLast6Months => Continuous,
        :MonthsWithLowSpendingOverLast6Months => Continuous,
        :MonthsWithHighSpendingOverLast6Months => Continuous,
        :MostRecentBillAmount => Continuous,
        :MostRecentPaymentAmount => Continuous,
        :TotalOverdueCounts => Continuous,
        :TotalMonthsOverdue => Continuous,
        :HasHistoryOfOverduePayments => Count,
)

# change the target to the desired
y = categorical(y)

# one-hot encode EducationLevel
# onehot_encoder = OneHotEncoder(; features=[:EducationLevel, :AgeGroup], drop_last=false, ordered_factor=false)
# onehot_machine = machine(onehot_encoder, X)
# MLJ.fit!(onehot_machine)
# X = MLJ.transform(onehot_machine, X)

classifier = LogisticClassifier()
encoder = OneHotEncoder()

model = @pipeline(
    encoder,
    classifier
)

mach = machine(model, X, y)
MLJ.fit!(mach)

orig_instance = X[110, :]

plaf = initPLAF()
