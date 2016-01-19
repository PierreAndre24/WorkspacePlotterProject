function [A2ridge, RidgeLim] = ExtractSquareAmpRidge(ridgenum,wt,skellist,skelptr,skellen)
% ExtractRidge -- Pull One Ridge Continuous Wavelet Transform
%  Usage
%    ridge = ExtractRidge(ridgenum,wt,skellist,skelptr,skellen)
%  Inputs
%    ridgenum  index of ridge to extract, 1 <= ridgenum <= nchains
%    wt        continuous wavelet transform output by CWT
%    skellist  storage for list of chains
%    skelptr   vector of length nchain -- pointers to heads of chains
%    skellen   vector of length nchain -- length of skellists
%  Outputs
%	 ridge	   len by 2 array of numbers, 
%              each row is a scale, amplitude pair
%
%  Description
%    The amplitude of the wavelet transform is followed along the
%    ridge chain. 
%
%  See Also
%    CWT, WTMM, BuildSkelMap, PlotSkelMap
%

	nchain  = length(skelptr);
	
	if ridgenum < 1 || ridgenum > nchain,
		fprintf('ridge #%i not in range (1,%i)\n',ridgenum,nchain),
	end
	
	head = skelptr(ridgenum);
	len  = skellen(ridgenum);
	
	A2ridge = zeros(len,1);
	
	vec = zeros(2,len);
	ix  = head : (head + 2*len-1);
	vec(:) = skellist(ix);

	for i=1:len,
		iscale = vec(1,i);
		ipos   = vec(2,i);
		amp2    = wt(ipos,iscale)^2;
		A2ridge(i) = amp2;
	end
    RidgeLim=[vec(:,1) vec(:,end)];

	
    
    
%   
% Originally Part of WaveLab Version .701
%
% Modified by Maureen Clerc and Jerome Kalifa, 1997
% clerc@cmapx.polytechnique.fr, kalifa@cmapx.polytechnique.fr
%

% Modified by Benoit to try the edge detection scheme proposed in Prance Nanotechnology 26 215201 (2015)  
    
 
 
%
%  Part of Wavelab Version 850
%  Built Tue Jan  3 13:20:39 EST 2006
%  This is Copyrighted Material
%  For Copying permissions see COPYING.m
%  Comments? e-mail wavelab@stat.stanford.edu 
