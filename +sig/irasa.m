% IRASA - Irregular-Resampling Auto-Spectral Analysis
% x = s.values{1};%Da;%
% f = 0:.25:250;
% q = 0;
% Fs = 2000;
% nw = 5;

% TODO: precalculate tapers, can't since taper lengths change...

function pfractal = irasa(x,f,quad,Fs,nw)
h = 1.1:.05:1.9;

%[px,params] = sig.mtspectrum(x,'thbw',nw,'f',f,'Fs',Fs,'quadratic',quad);

nh = numel(h);
pg = zeros(length(f),nh);
for i = 1:nh
   [p,q] = rat(h(i));
   
   % Fractionally downsampled
   xh = resample(x,p,q);
   ph = sig.mtspectrum(xh,'thbw',nw,'f',f,'Fs',Fs,'quadratic',quad);
   
   % Fractionally upsampled
   x1h = resample(x,q,p);
   p1h = sig.mtspectrum(x1h,'thbw',nw,'f',f,'Fs',Fs,'quadratic',quad);

   % Geometric mean
   pg(:,i) = sqrt(ph.P.*p1h.P);
end

pfractal = median(pg,2);