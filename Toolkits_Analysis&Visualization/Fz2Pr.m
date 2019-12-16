function r = Fz2Pr(z)
%% This function is to transform Fizher z back to Pearson's r
%z = 0.5 * [(1+ln(r)) - (1-ln(r))]
r = (exp(2*z) - 1)/(exp(2*z) + 1);
