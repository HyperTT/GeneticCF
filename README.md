# GeneticCF: Using Counterfactual Explanations in Generating Rule-based Explanations

To run GeneticCF, you need to have Julia installed ([link](https://julialang.org/downloads/)). Then you can run the following commands to load the package GeCo, which we used as the underlying counterfactual explanation system.

Please open up the Command Prompt in the repository directory

Installing 1.6 and 1.7 versions for this outdated codebase (2022 - 4 years ago)
You can install different versions of Julia using the Juliaup command

<H2> REVISIONS </H2>
This version is slightly different than the original creators. When trying to work with dependencies.
I had lots of errors with anything related to Python.
I decided to replace them with the MLJ and MLJScientificTypes.
I still have a lot of work to do since GeCo and GeneticCF manage data less strictly, and MLJ requires strict rules.

<H2> CURRENT PROGRESS </H2>

I am currently trying to see if the code is better in Julia v1.6, v1.7, and possibly v1.8.
I am unsure since this code is 4 years old if all of the dependencies still exist and function the same way they did in 2021 and 2022.

<H2> MORE INFORMATION </H2>
<H3>Computing Rule-Based Explanations by Leveraging Counterfactuals</H3>
Here is the research paper that this code connects to: https://www.vldb.org/pvldb/vol16/p420-geng.pdf -- Computing Rule-Based Explanations by Leveraging Counterfactuals.

<H3>GeCo: Quality Counterfactual Explanations in Real Time</H3>
<ul><li>Previous research on the GeCo engine was done in 2021. https://www.vldb.org/pvldb/vol14/p1681-schleich.pdf -- GeCo: Quality Counterfactual Explanations in Real Time. </li>
<li>The connected repository can be found here https://github.com/mjschleich/GeCo.jl>MJSchliech/GeCo.jl. </li>
<li>There is also a video presentation about this paper on YouTube: https://www.youtube.com/watch?v=19BMj3cjBgU --Research 2242 | VLDB 2021</li>
</ul>

<H3> Here is some information about the researchers: </H3>


<ul> <li>Yihong Zhang (张轶泓) Portfolio Website: https://effect.systems/</li>
<li>Dan Suciu Portfolio Website: https://homes.cs.washington.edu/~suciu/</li>
<li>Zixuan (Gibbs) Geng LinkedIn: https://www.linkedin.com/in/zixuan-geng/</li>
<li>Maximilian-Joël Schleich Portfolio Website: https://mjschleich.github.io/</li>
</ul>

<H2> INITALIZATION </H2>

```PowerShell
  juliaup add 1.7.3 
  juliaup default 1.7.3
```
Install dependencies that work together. To open up the package editor, open Julia and then click `]`

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
To load a specific folder, you can use the command `Pkg.activate(string source)` function:
For example, here is how you would open up the GeCo folder through Julia

```Julia
using Pkg; Pkg.activate("./GeCo")
using GeCo
```

In this example, you can open up GeneticCF

```Julia
using Pkg; Pkg.activate(".") # this is the main repository folder
include("src/GeneticCF.jl")
using .GeneticCF
```

When initializing documents, you will need to traverse between these two folders

<H2> LOADING SCRIPTS </H2>

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

When these codes are generated properly, they produce nice graphs.
