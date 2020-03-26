function gaussian = fnGaussian(muy, sdy)
    gaussian = exp(-((yy-muy).^2)/(2*sdy^2));
end