function plotrocs(nu1,sig1,nu2,sig2,color)


t=linspace(20,-10,31);

pfunc= @(x) exp((((x-nu1)/sig1).^2)*(-1/2))*(1/(sig1*sqrt(2*pi)));

nfunc= @(x) exp((((x-nu2)/sig2).^2)*(-1/2))*(1/(sig2*sqrt(2*pi)));

ind=1;

for i=t

truenegative(ind)=quad(nfunc,i,20);

falsepositive(ind)=quad(nfunc,-10,i);

falsenegative(ind)=quad(pfunc,i,20);

truepositive(ind)=quad(pfunc,-10,i);

ind=ind+1;

end



tpr=truepositive./(truepositive+falsenegative);

fpr=falsepositive./(falsepositive+truenegative);



plot(tpr,fpr,color);

hold on;
end