# GeneticCF: Using Counterfactual Explanations in Generating Rule-based Explanations

To run GeneticCF, you need to have Julia installed ([link](https://julialang.org/downloads/)). Then you can run the following commands to load the package GeCo, which we used as the underneath counterfactual explanation system.

Please open up the Command Prompt in the repository directory

Installing 1.6 and 1.7 versions for this outdated codebase (2022 - 4 years ago)
You can install different versions of Julia using the Juliaup command

<H2> REVISIONS </H2>
This version is slightly different than the original creators. When trying to work with dependencies.
I had lots of errors with anything related to Python.
I decided to replace them with the MLJ and MLJScientificTypes.
I still have a lot of work to do since GeCo and GeneticCF manage data less strictly, and MLJ requires strict rules.

<H2> COMMANDS TO RUN CODE </H2>
```PowerShell
  juliaup add 1.7.3 
  juliaup default 1.7.3
```
Install dependencies that work together

```Julia
pkg> add DataFrames@0.22.1 GR@0.72.10 Plots@1.38.12 StatsPlots@0.15.6 Clustering@0.14.2 NearestNeighbors@0.4.13
```

For patching dependencies to make them compatible with older versions
```Julia
if !isdefined(Base, :Returns)
    @eval Base Returns(value) = (args...; kwargs...) -> value
end
```
When loading files, dependencies may still need to be added
To load a specific folder, you can use the command `Pkg.activate(string source)` function
```Julia
using Pkg; Pkg.activate("./GeCo")
using GeCo
using Pkg; Pkg.activate(".") # this is the main repository folder
include("src/GeneticCF.jl") 
```

We provide scripts to load the data and model. For instance:
```Julia
include("scripts/credit/credit_setup_MACE.jl");
include("scripts/adult/adult_setup_MACE.jl");
include("../scripts/fico/fico-setup.jl")
```

Then run the following command to compute the rule-based explanations:
```Julia
explanations, = generate_rules(orig_instance, X, classifier, plaf)
```
for GeneticRule;
```Julia
explanations, = generate_rules(orig_instance, X, classifier, plaf, geco_initial = true, geco_mutation = true)
```
for RuleCF;
```Julia
explanation, = greedyCF(orig_instance, X, classifier, plaf)
```
for RuleCFGreedy,
where `orig_entity` is the entity to be explained, `X` is the dataset, `classifier` is the model that is explained, and plaf is the PLAF constrains.

To print out the top rule:
```Julia
explanation = explanations[1]
print_rule(orig_instance, explanation)
```

Here is another format you can use for explanation commands
```Julia

explanations = generate_rules(
    orig_instance,
    data,
    predict_fn,
    plaf
)
```
