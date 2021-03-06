function seisex=extrapfoci_f(seis,f,x,v,dz,table,ktable,ntable,params)
%
% seisex=extrapfoci_f(seis,f,x,v,dz,table,ktable,params)
%
% Explicit space-frequency domain wavefield extrapolation based
% on the FOCI method. This method first designs a forward
% extrapolation operator for a step of dz/2 and then a least-squares
% inverse of this operator. The final operator is given by
% final_op = conv(conj(inverse_op), forward_op),
% In this version, the operators in the table are assumed to provide the
% focussing phase shift only. The static phase shift is computed and
% applied directly.
%
% seis ... input seismic matrix in (x,f) domain
% f ... frequency coordinate for rows of seis
% x ... space coordinate for columns of seis
% v ... velocity vector (same size as f)
% dz ... depth step size
% table ... table of extrapolation operators, one per row
% ktable ... vector of k values labeling the rows of table
%           Assumes regular sampling
% ntable ... vector of the same size as ktable giving operator lengths
% params ... vector of parameters. Nan entires invoke defaults
% params(1) ... minimum frequency to extrapolate
% params(2) ... maximum frequency to extrapolate
% params(3) ... round velocities to the nearest this many m/s (or ft/sec)
%               (applies to focussing phase shift only)
%            ****** default 100 ******
% 
%  

if(~isnan(params(1)))
    fmin=params(1);
else
    fmin=f(1);
end
if(~isnan(params(2)))
    fmax=params(2);
else
    fmax=(f(end));
end
if(~isnan(params(3)))
    nround=params(3);
else
    nround=100;
end

nx=length(x);

if(length(f)>1)
	iuse=between(fmin,fmax,f,2);
	dk=ktable(2)-ktable(1);
	kmin=ktable(1);
else
    iuse=1;
    dk=1;
    kmin=ktable(1);
end

%disp([int2str(length(iuse)) ' frequencies to extrapolate'])

nopm=size(table,2);%maximum operator length
nopm2=floor(nopm/2);

seisex=zeros(size(seis));

%process velocities
vround=nround*round(v/nround);
test=zeros(size(vround));
nvels=1;
inext=1;
while(~prod(test))
    vels{nvels}=vround(inext);
    ivels{nvels}=find(vround==vels{nvels});
    test(ivels{nvels})=1;
    ii=find(test==0);
    if(~isempty(ii))
        inext=ii(1);
        nvels=nvels+1;
    end
end
%so vels is a cell array of the unique velocites in vround
%ivels points to the locations of each unique velocity
oneoverv=1./v;

for jf=1:length(iuse)
    tmpout=zeros(1,nx+nopm-1); %storage for extrapolated frequency
    tmpin=seis(iuse(jf),:);
    for jvel=1:nvels
        %grab closest operator in table. No interpolation since they are
        %different lengths
        k=f(iuse(jf))/vels{jvel};
        jk=round((k-kmin)/dk)+1;
        if(jk<1) jk=1; end
        if(jk>length(ntable))jk=length(ntable);end
        nop=ntable(jk);
        nop2=floor(nop/2);
        op=table(jk,1:nop);
        %dnop=nopm-nop;
        %dnop2=nopm2-nop2;
        tmp=zeros(size(tmpout));
        tmp(ivels{jvel}+nop2+1)=tmpin(ivels{jvel});
        tmpout=tmpout+convz(tmp,op);
    end
    
    seisex(iuse(jf),:)=tmpout(1+nopm2:1+nopm2+nx-1).*exp(i*dz*2*pi*f(iuse(jf))*oneoverv);
    %seisex(iuse(jf),:)=tmpout(1+nopm2:1+nopm2+nx-1);
end