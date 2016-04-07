function varargout = MenuMake(dlgTitle,Resize,NameWs,EraseWorkspace, ...
    varargin)
% Interface function for inpdlg
% EXAMPLE -->
% Title  = 'input data'
% Resize = 'on'
% NameWs = '/home/joaquin/USO_COMUN_MATLAB/DATA/var_1' --> For the
% workspace
% EraseWorkspace = 0 (or 1, if you want to erase NameWs )
%
% varargin ={prompt_1,NumLines_1,DefAns_1,PrompDef_A_1,PrompDef_B_1,ListInit_1,AffEraseWs_1, ...
%            prompt_2,NumLines_2,DefAns_2,PrompDef_A_2,PrompDef_B_2,ListInit_2,AffEraseWs_2, ...
%            ....}
%
%%  	PromptDef(1,:) = [ 0 0 N 0 ...] 0 - edit box,
%%                                  N - Popup menu(N is the initial selection)
%%                                 -N for ListBox(ListInit{N} is the initial selection)
%%  	PromptDef(2,:) = [ 0 1 0 0 ...] 1 - initially disabled Quests
%%      						for ListBox:	1  initially disabled ListBox
%%                  							2  Single item selection ListBox
%%							                  3  Single item selection + initially disabled ListBox
% Example:
%
%
%
% prompt_1      = 'Nodes selected'
% NumLines_1    = [5  10];
% DefAns_1      = num2str[3; 7; 9; 10]
% PrompDef_A_1  = -1
% PrompDef_B_1  =  1
% ListInit_1    =  [1 3] ;
% AffEraseWs_1  = 0 ; --> Default value 0, if  == 1, it means that ALWAYS
% is erased, no matter the value of EraseWorkspace
%
% REMARK : Numerical entries --> Column vector !!!!  
%  % Cell arrays could be string-class or mixed
%            % But only numericall does not require the same
% Written by Joaquin Hernandez Ortega 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
    dlgTitle = 'Select nodes';
    Resize   = 'on';
    NameWs = '/home/joaquin/USO_COMUN_MATLAB/DATA/var_1';
    EraseWorkspace = 0;
    %            
    varargin = {'Nodes selected',[5  10],num2str([3.6; 7.8; 9.6  ]) ,-1  ,0,     [1],0, ...
                'Elem selected' ,[3 8]  ,{'YES',num2str([4.1;4.5;7.6])},-1  ,0,     [1]  ,0, ...
                'Choose Eleme'  ,[2 10] ,{'YES','NO','PUEDE'}          , 1  ,0,     []   ,0, ...
                'TIME'          ,[2 10] , num2str(2.56)                , 0  ,0,     []   ,0};
end

% Default inputs
AnsF     = {} ;
ncol     = 7 ;
% %%%%%%%%%%%%%%

% 1. Number of prompts
ncol2 = length(varargin);
if ncol2/ncol ~= round(ncol2/ncol)
    'Error in MenuMake-- ncol2/ncol ~= round(ncol2/ncol)';
else
    nvar = ncol2/ncol ;
end

% 2. Initializing
prompt     = cell(1,nvar);
NumLines   = zeros(nvar,2) ;
DefAns     = cell(1,nvar)  ;
PromptDef  = zeros(2,nvar) ;
ListInit   = cell(1,nvar);
nlistbox   = 0 ;
AffEraseWs = zeros(nvar,1) ;
AnswerMod = cell(1,nvar) ;
isamatrix = ones(nvar,1) ;
isachar   = ones(nvar,1) ;
SaveAns =  cell(1,nvar) ;



%%%

for ivar = 1:nvar
    ivarloc = (ivar-1)*ncol+1;
    prompt{ivar}     = varargin{ivarloc}   ;
    NumLines(ivar,:) = varargin{ivarloc+1} ;
    DefAns{ivar}     = varargin{ivarloc+2} ;
    if varargin{ivarloc+3} == -1
        nlistbox = nlistbox +1 ;
        % List box
        PromptDef(1,ivar) = -nlistbox ;
    else
        PromptDef(1,ivar) =   varargin{ivarloc+3} ;
    end
    PromptDef(2,ivar) = varargin{ivarloc+4} ;
    % List box
    if varargin{ivarloc+3} == -1
        ListInit{nlistbox} = varargin{ivarloc+5} ;
    end
    % AffEraseWs
    AffEraseWs(ivar) = varargin{ivarloc+6} ;
end


%%%
% 3.
if EraseWorkspace == 0
    % We load PrompDef Variables of the last time 
    if exist([NameWs,'.mat']) == 2 | exist([NameWs]) == 2
        try
        load(NameWs)
    catch
    end
        %%%%%%%%%%%%%%%%%%%%%%%%
        for ivar = 1:nvar 
            if AffEraseWs(ivar) == 0
                if PromptDef(1,ivar) == 0
                   DefAns{ivar} = SaveAns{ivar};
                else
                    if  PromptDef(1,ivar) > 0
                        if length(DefAns{ivar})>=max(SaveAns{ivar})
                            PromptDef(1,ivar) = SaveAns{ivar} ;
                        end                        
                    else
                        % ListBox 
                        if length(DefAns{ivar})>=max(SaveAns{ivar})
                            ListInit{-PromptDef(1,ivar)} = SaveAns{ivar} ;
                        end        
                    end
                end            
            end
        end
        
    end
end







[Answer, figfmen1, AnsFlg1] =inpdlg(prompt, dlgTitle, NumLines, ...
    DefAns, PromptDef, AnsF, Resize, ListInit);

% Obtaining answer




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ivar = 1:nvar
    if iscell(Answer{ivar})
        varlocSTR =cell(1,length(Answer{ivar}));
        varloc    = Answer{ivar} ;
        for iloc = 1:length(Answer{ivar})
           % if isempty(str2num(varloc{iloc}))
            if isempty(str2num(varloc{iloc}))
                varlocSTR{iloc} = varloc{iloc};
                isamatrix(ivar) = 0;
            else
                varlocSTR{iloc} = str2num(varloc{iloc}) ;
                isachar(ivar) = 0 ;
            end
        end
        if isamatrix(ivar) == 0
            AnswerMod{ivar} = varlocSTR ;
        else
            AnswerMod{ivar} = cell2mat(varlocSTR) ;
        end
    else
        % Only a variable
        if isempty(str2num(Answer{ivar}))
            for iloc = 1:length(Answer{ivar})
                AnswerMod{ivar}  = Answer{ivar} ;
                isamatrix(ivar) = 0;
            end
        else
            AnswerMod{ivar}  = str2num(Answer{ivar}) ;
            isachar(ivar) = 0 ;
        end

    end
end


%%%%% Saving data --> Defining for the next time PrompDef(1,ivar)
%if EraseWorkspace == 0
for ivar = 1:nvar
    if PromptDef(1,ivar) == 0
        % Edit box
        SaveAns{ivar} = Answer{ivar};
    else
        % Only if they are pure numeric or string characters
        if iscell(DefAns{ivar})
            % Cell arrays could be string-class or mixed            
            LocAns = DefAns{ivar} ;
            ischaracter = 1 ;
            % we assume the cell is only string-class
            for iloc = 1:length(LocAns)
                LocAns{iloc} ;
                if isempty(str2num(LocAns{iloc}))
                else
                    ischaracter = 0;
                    % Hypothesis no valid
                end
            end
            if ischaracter == 1
                % Hypothesis was valid
                Locresp = AnswerMod{ivar};
                if iscell(Locresp)
                    for iloc = 1:length(Locresp)
                        [OK,nnn]=FndStrInCell(DefAns{ivar},Locresp{iloc});
                        LocProm(iloc) = nnn;
                    end
                else
                    [OK,LocProm]=FndStrInCell(DefAns{ivar},Locresp);
                end
                SaveAns{ivar} = LocProm ;
            else
                % Is not a character. Nothing is saved --> Default, the
                % first element in the list
                SaveAns{ivar} = 1 ;
            end
        else
            %  Is not a cell, purely numeric
            if isempty(str2num(DefAns{ivar}))
                'WARNING --> in MenuMake, isempty(str2num(DefAns{ivar})) ??????';
                SaveAns{ivar}  = 1 ;
            else
                NumLoc = AnswerMod{ivar};
                for iloc = 1:length(NumLoc)
                   indig(iloc) = find(str2num(DefAns{ivar}) == NumLoc(iloc));
                end
                SaveAns{ivar} = indig ; 
            end
        end
    end
end

save(NameWs,'SaveAns')
%end

%%%%5
if nargout == nvar
for iout = 1:nargout
    varargout{iout} = AnswerMod{iout};
end
else
    error('Too many/less output arguments')
end

%%%%%



