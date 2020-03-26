function vonMises = fnVonMises(mux, kappa)
    vonMises = exp(kappa*cos(xx-mux));
end