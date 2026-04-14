function score(
    classifier::MLJ.Machine,
    counterfactuals::DataFrame,
    desired_class;
    extra_col = NUM_EXTRA_COL
)::Vector{Float64}

    # Training feature schema (exact)
    Xtrain = fitted_params(classifier)[1]
    feature_names = names(Xtrain)

    # Force exact match: no extra, no missing, correct order
    Xcf = select(counterfactuals, feature_names)

    preds = MLJ.predict(classifier, Xcf)
    return broadcast(MLJ.pdf, preds, desired_class)
end