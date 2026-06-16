function [Lambda1,Lambda2] = eig2image(Dxx,Dxy,Dyy)


% Eigenvalues of Hessian matrix


tmp = sqrt((Dxx-Dyy).^2 + 4*Dxy.^2);


mu1 = 0.5*(Dxx+Dyy+tmp);

mu2 = 0.5*(Dxx+Dyy-tmp);



check = abs(mu1) > abs(mu2);


Lambda1 = mu1;

Lambda1(check)=mu2(check);


Lambda2 = mu2;

Lambda2(check)=mu1(check);


end