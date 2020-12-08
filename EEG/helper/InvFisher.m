function r = InvFisher(Z)
% inverse of Fisher's Z transform for correlation coefficients

r = (exp(2.*Z) - 1) ./ (exp(2.*Z) + 1);
