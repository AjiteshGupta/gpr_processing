function [Ux,Uxt0,Uz,Uzt0].....
    = fdInitArrayB(nxf,nzf)
% function [Ux,Uxt0,Uz,Uzt0].....
%     = fdInitArrayB(nxf,nzf)
%Declare space for arrays carried from step to step
    %Initialize to zero only at first step
%The input parameters are
%nxf     .... Number of X samples including border
%nzf     .... Number of Z samples including border
%The output parameters are
%Ux   ....... X displacements in an X/Y grid
%Uxt0   ..... X displacements in an X/Y grid, previous time step
%Uz   ....... Z displacements in an X/Y grid
%Uzt0   ..... Z displacements in an X/Y grid, previous time step
%
% P.M. Manning, Dec 2011
%
% NOTE: It is illegal for you to use this software for a purpose other
% than non-profit education or research UNLESS you are employed by a CREWES
% Project sponsor. By using this software, you are agreeing to the terms
% detailed in this software's Matlab source file.
 
% BEGIN TERMS OF USE LICENSE
%
% This SOFTWARE is maintained by the CREWES Project at the Department
% of Geology and Geophysics of the University of Calgary, Calgary,
% Alberta, Canada.  The copyright and ownership is jointly held by 
% its author (identified above) and the CREWES Project.  The CREWES 
% project may be contacted via email at:  crewesinfo@crewes.org
% 
% The term 'SOFTWARE' refers to the Matlab source code, translations to
% any other computer language, or object code
%
% Terms of use of this SOFTWARE
%
% 1) Use of this SOFTWARE by any for-profit commercial organization is
%    expressly forbidden unless said organization is a CREWES Project
%    Sponsor.
%
% 2) A CREWES Project sponsor may use this SOFTWARE under the terms of the 
%    CREWES Project Sponsorship agreement.
%
% 3) A student or employee of a non-profit educational institution may 
%    use this SOFTWARE subject to the following terms and conditions:
%    - this SOFTWARE is for teaching or research purposes only.
%    - this SOFTWARE may be distributed to other students or researchers 
%      provided that these license terms are included.
%    - reselling the SOFTWARE, or including it or any portion of it, in any
%      software that will be resold is expressly forbidden.
%    - transfering the SOFTWARE in any form to a commercial firm or any 
%      other for-profit organization is expressly forbidden.
%
% END TERMS OF USE LICENSE

%nzp = nz+1;
Ux = zeros(nxf,nzf);
Uxt0 = zeros(nxf,nzf);
Uz = zeros(nxf,nzf);
Uzt0 = zeros(nxf,nzf);
