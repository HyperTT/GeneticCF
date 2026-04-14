using CSV, Statistics, DataFrames, MLJ, MLJLinearModels

#data_path = joinpath(@__DIR__, "..", "..", "GeCo", "data", "adult", "adult_processed.csv")

#df = CSV.read(data_path, DataFrame)
df = CSV.File(joinpath(@__DIR__, "../../data/adult/adult_processed.csv")) |> DataFrame
data = df
println(names(df))
#path = "data/adult"
#data = CSV.File(path*"/adult_data_mace.csv") |> DataFrame

# DO NOT mutate `data` before extracting label
@assert "income" in names(data)

#rename!(data, Dict(
#    "education_num"   => "EducationNumber",
#    "marital_status"  => "MaritalStatus",
#    "capital_gain"    => "CapitalGain",
#    "capital_loss"    => "CapitalLoss",
#    "hours_per_week"  => "HoursPerWeek",
#    "workclass"       => "WorkClass",
#    "native_country"  => "NativeCountry",
#	"education" => "EducationLevel"
#))


data = CSV.read(path, DataFrame)

# CRITICAL FIX
rename!(data, Symbol.(names(data)))

# semantic renames
rename!(data, Dict(
    :education        => :EducationLevel,
    :education_num    => :EducationNumber,
    :marital_status   => :MaritalStatus,
    :capital_gain     => :CapitalGain,
    :capital_loss     => :CapitalLoss,
    :hours_per_week   => :HoursPerWeek,
    :workclass        => :WorkClass,
    :native_country   => :NativeCountry
))

orig_instance = data[6, :]

include("src/GeneticCF.jl")

explanations = generate_rules(
    orig_instance,
    data,
    mach,
    plaf
)

print_rule(orig_instance, explanations[1])

 
const LABEL = :income

# extract target FIRST
y = data[:, LABEL]

# extract features WITHOUT mutation
X = select(data, Not(LABEL))

y = categorical(y)

classifier = LogisticClassifier()
encoder = OneHotEncoder()



model = @pipeline(
    OneHotEncoder(handle_unknown = :ignore),  # ⬅ important
    LogisticClassifier()
)


mach = machine(model, X, y)
MLJ.fit!(mach)


include("adult_constraints_MACE.jl");

orig_instance = X[6, :]
