function Markers = MarkerMatrix(ntrial,ShowMarker,GiveMark);
% Different Markers
if  nargin == 0
    ntrial = 3;
    ShowMarker = 1; 
elseif nargin == 1
    ShowMarker = 1 ;
    GiveMark = 'none'; 

elseif nargin == 2
   GiveMark = 'none'; 
end

VecMark = {'+','o','*','.','x','square','diamond',...
    'v','>','<','pentagram','hexagram'};

MarkersNew = cell(1,length(VecMark)); 
%ppp = randperm(length(VecMark));
ppp = 1:length(VecMark);
for i = 1:length(VecMark)
   MarkersNew{i} =  VecMark{ppp(i)};
end
VecMark =MarkersNew ;

if ShowMarker == 0
    VecMark = {'none'};
elseif ShowMarker == -1 
    VecMark = {GiveMark} ;
end 
nmark = length(VecMark);
iloc = 1;
nloc = 0 ;
 
for i = 1:ntrial
    if iloc>nmark
        iloc = 1 ;
        nloc = nloc+nmark ; 
    end
    if i == 1
        Markers = {VecMark{iloc}} ;
    else
    Markers = cat(2,Markers,{VecMark{iloc}});
    end

    iloc = iloc + 1;

end


