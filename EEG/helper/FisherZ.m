function Z = FisherZ(r)
%
% calculates the Fisher Z transform for correlation coefficients

Z = 1/2*log((1+r)./(1-r));

