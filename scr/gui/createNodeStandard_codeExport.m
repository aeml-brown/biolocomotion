classdef createNodeStandard < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        SaveAsEditFieldLabel    matlab.ui.control.Label
        editF_saveAs            matlab.ui.control.EditField
        label_targetDir         matlab.ui.control.Label
        button_saveAll          matlab.ui.control.Button
        label_separator         matlab.ui.control.Label
        label_emptyName         matlab.ui.control.Label
        panel                   matlab.ui.container.Panel
        table_recordedNodes     matlab.ui.control.Table
        chkB_Suffix_X           matlab.ui.control.CheckBox
        chkB_Suffix_Y           matlab.ui.control.CheckBox
        chkB_Suffix_Z           matlab.ui.control.CheckBox
        chkB_SuffixR            matlab.ui.control.CheckBox
        chkB_SuffixL            matlab.ui.control.CheckBox
        button_ADD              matlab.ui.control.Button
        button_deleteSelection  matlab.ui.control.Button
        Label_errorMsg          matlab.ui.control.Label
        button_uploadImage      matlab.ui.control.Button
        NodeListTextAreaLabel   matlab.ui.control.Label
        textA_nodeList          matlab.ui.control.TextArea
        uia_image               matlab.ui.control.UIAxes
        button_openImage        matlab.ui.control.Button
        button_changeDir        matlab.ui.control.Button
    end


    properties (Access = private)
        % root drectory for Node Standards
        %TODO -- Change this to Desktop
        rootDir = [pwd '\res'];
        % used to transfer values from user entry to Node table
        % a value of 0 is no cells selected
        selectedTableNodes = 0;
        
        % used to append characters from user entry prior to storage in Node table
        rightChar   =  'R';
        leftChar    =  'L';
        xCoordinate = '_X';
        yCoordinate = '_Y';
        zCoordinate = '_Z';
        
        % record a name for the directory and file to save
        createdFlag = 0;
        
        %image for reference location and name
        imageChangeFlag = 0;
        imageFile = '';
        prevImageFile = '';
        imagePath = '';

    end
    
    methods (Access = private)
        % make sure that savingDir contains no directory with the same name.
        function k = doesDirExsist(app)
            k = 0;
            tdirs = cellstr(ls(app.rootDir));
            for i = 1:size(tdirs,1)
                if(strcmp(tdirs(i), char(app.editF_saveAs.Value)))
                    k = 1;
                end
            end
        end%func doesDirExsist
    
    end%methods
       

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.panel.Visible = 'off';
            
            %TODO -- is pwd always at biolocomotion when starting?
            %TODO -- what about if the app is launched from an exe
            %TODO -- is prob best if it saves in Host's home, for now save in ./res
            app.label_targetDir.Text = app.rootDir;
           
        end

        % Value changed function: textA_nodeList
        function textA_nodeListValueChanged(app, event)
            % for some reason declearing the method is needed to propperly operate the handle
            % though nothing happens here
            value = app.textA_nodeList.Value;
        end

        % Button pushed function: button_ADD
        function button_ADDButtonPushed(app, event)
            %TODO -- i am not specifyign the variable type of either of these arrays, is that ok?
            %TODO -- i am not checking if node list is empty. though it seems to be file
            %TODO -- i am not trimming witespaces
            
            % first get the values
            tArray = app.textA_nodeList.Value;
            newArray = {};
            
            % for every item on the iist append a suffix  R and/or L 
            for i = 1:size(tArray,1)                  
                % right suffix
                if(app.chkB_SuffixR.Value==1)
                    tmp = char(tArray(i));
                    tmp = [tmp app.rightChar];
                    newArray = [newArray; tmp];
                end
                % left suffix
                if(app.chkB_SuffixL.Value==1)
                    tmp = char(tArray(i));
                    tmp = [tmp app.leftChar];
                    newArray = [newArray; tmp];
                end
                % no suffix
                 if(app.chkB_SuffixR.Value==0 && app.chkB_SuffixL.Value==0)
                    tmp = char(tArray(i));
                    newArray = [newArray; tmp];
                end
            end %for -- loop RL indices
            
            % assign new values if RL was appended.
            tArray = newArray;
            newArray = {};
            
            %for every item on the iist append a suffix X and/or Y and/or Z
            for i = 1:size(tArray,1) 
                tmp = char(tArray(i));
                % X suffix
                if(app.chkB_Suffix_X.Value==1)
                    tmpC = [tmp app.xCoordinate];
                    newArray = [newArray; tmpC];
                end
                % Y suffix
                if(app.chkB_Suffix_Y.Value==1)
                    tmpC = [tmp app.yCoordinate];
                    newArray = [newArray; tmpC];
                end
                % Z suffix
                if(app.chkB_Suffix_Z.Value==1)
                    tmpC = [tmp app.zCoordinate];
                    newArray = [newArray; tmpC];
                end
                % no suffix
                if(app.chkB_Suffix_X.Value==0 & app.chkB_Suffix_Y.Value==0 & app.chkB_Suffix_Z.Value==0)
                    tmp = char(tArray(i));
                    newArray = [newArray; tmp];
                end                    
                
            end%for -- loop XYZ indices
            
            % assign new array values to Node Table
            app.table_recordedNodes.Data = [app.table_recordedNodes.Data; newArray];
            % clear user entry list
            app.textA_nodeList.Value = '';
        end

        % Button pushed function: button_deleteSelection
        function button_deleteSelectionPushed(app, event)
            % cherry-pick values from table and remove them
            % user needs to make a selection first, then press
            % cells selected array comes from an ISR table_recordedNodesCellSelection()
            if(app.selectedTableNodes ~= 0)
                app.Label_errorMsg.Text = "";
                app.table_recordedNodes.Data(app.selectedTableNodes) = '';
                app.selectedTableNodes = 0;
            else
                app.Label_errorMsg.Text = "ERROR: Select at least one cell";
            end
        end

        % Cell selection callback: table_recordedNodes
        function table_recordedNodesCellSelection(app, event)
           indices = event.Indices(:,1);                %for some reason it does not like to be directly assigned to private var
           app.selectedTableNodes = indices;            %indices is probably adefined attribute of this function.
        end

        % Button pushed function: button_uploadImage
        function button_uploadImageButtonPushed(app, event)
            %TODO -- needs to be wraped in try-catch
            %TODO -- make sure file selected is less than 500kb
            %TODO -- this may be different for unix systems
            %s = dir([path file]);
            %if (s.bytes < 500000)
            
            [app.imageFile,app.imagePath] = uigetfile('*png', 'Select a PNG image (500kB max)');
            app.button_openImage.Enable = 'on';
            
            % this is used for saving the image just once
            % copy even if it is the same image again.
            %TODO -- do I need full path here in other platforms?
            app.imageChangeFlag = 1;
            tmp = imread([app.imagePath app.imageFile]);
            
            %display image on app
            imshow(tmp, 'parent', app.uia_image);
            
        end

        % Button pushed function: button_saveAll
        function button_saveAllPushed(app, event)
            %TODO -- trim image name so it does not have spaces
            %TODO -- format input text to make sure it follows rules

            % if this is the first time user hits create
            if(app.createdFlag == 0)
                if(size(app.editF_saveAs.Value, 1) == 0)
                    app.label_emptyName.Text = 'Name cannot be Empty';
                elseif(doesDirExsist(app) == 1)
                    app.label_emptyName.Text = 'There is a directory with that name here already';
                else
                    app.label_emptyName.Text = '';
                    app.editF_saveAs.Enable = 'off';
                    app.button_saveAll.Text = 'Save All';
                    app.panel.Visible = 'on';
                    
                    % create a directory with the same name as the file to save
                    %TODO -- this needs a try catch
                    app.label_targetDir.Text = fullfile(app.label_targetDir.Text, app.editF_saveAs.Value);
                    mkdir(app.label_targetDir.Text);
                    app.createdFlag = 1;
                end
                
            % if user hits save, store all valuable variables.
            else
                %variables to store
                stdNodeNames = app.table_recordedNodes.Data;
                stdName = char(app.editF_saveAs.Value);
                stdImageName = app.imageFile;
                
                % only save image if user has selected a different one
                if(app.imageChangeFlag == 1)
                    % delete prev image as to keep just one
                    % dont attempt to delete if it is the first image
                    if(strcmp(app.prevImageFile, '')==0)
                        delete(fullfile(app.label_targetDir.Text, app.prevImageFile))
                    end
                    copyfile([app.imagePath app.imageFile], app.label_targetDir.Text);
                    % remember name this image in case user changes it; this to delete it.
                    app.prevImageFile = app.imageFile;
                    app.imageChangeFlag = 0;
                end
                
                %save file to disk and tell user app can be closed
                %TODO -- if directory gets deleted between its creation and save, this will crap out?
                %TODO -- does this work cross platform?
                save(fullfile(app.label_targetDir.Text, [app.editF_saveAs.Value '.mat']), 'stdNodeNames','stdName','stdImageName','-mat');
                msgbox({'All Saved!!!';'You can keep modfying or just close the window'},'Success');
            end% if(app.createdFlag == 0)
            
        end

        % Button pushed function: button_changeDir
        function button_changeDirPushed(app, event)
            path = uigetdir('Select annother working directory');
            %TODO -- this should default to the users desktop
            %TODO -- for some reason this sometimes crashes if it is on my first screen only??
            try 
                app.label_targetDir.Text = path; %TODO -- should trim this to show a ../../dir
            catch
               warning("select a valid directory"); %TODO -- pop a message insted
            end
            
        end

        % Button pushed function: button_openImage
        function button_openImageButtonPushed(app, event)
            % the button is enabled by loading an image, then display this to zoom
            imshow([app.imagePath app.imageFile]);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 871 510];
            app.UIFigure.Name = 'UI Figure';

            % Create SaveAsEditFieldLabel
            app.SaveAsEditFieldLabel = uilabel(app.UIFigure);
            app.SaveAsEditFieldLabel.HorizontalAlignment = 'right';
            app.SaveAsEditFieldLabel.Position = [28 468 54 22];
            app.SaveAsEditFieldLabel.Text = 'Save As:';

            % Create editF_saveAs
            app.editF_saveAs = uieditfield(app.UIFigure, 'text');
            app.editF_saveAs.Tooltip = {'No spaces no symbols no underscores no extensions.'; 'Just use camelCase. There is no error checking.'};
            app.editF_saveAs.Position = [97 468 172 22];

            % Create label_targetDir
            app.label_targetDir = uilabel(app.UIFigure);
            app.label_targetDir.HorizontalAlignment = 'right';
            app.label_targetDir.FontSize = 10;
            app.label_targetDir.FontColor = [0 0.451 0.7412];
            app.label_targetDir.Tooltip = {'No spaces'; ' no symbols'; ' no underscores no extensions.'; 'Just use camelCase. There is no error checking.'};
            app.label_targetDir.Position = [411 478 446 12];
            app.label_targetDir.Text = '';

            % Create button_saveAll
            app.button_saveAll = uibutton(app.UIFigure, 'push');
            app.button_saveAll.ButtonPushedFcn = createCallbackFcn(app, @button_saveAllPushed, true);
            app.button_saveAll.Position = [286 468 91 22];
            app.button_saveAll.Text = 'Create';

            % Create label_separator
            app.label_separator = uilabel(app.UIFigure);
            app.label_separator.HorizontalAlignment = 'center';
            app.label_separator.Position = [15 426 842 22];
            app.label_separator.Text = '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';

            % Create label_emptyName
            app.label_emptyName = uilabel(app.UIFigure);
            app.label_emptyName.FontSize = 11;
            app.label_emptyName.FontColor = [0.6392 0.0784 0.1804];
            app.label_emptyName.Position = [98 447 279 22];
            app.label_emptyName.Text = '';

            % Create panel
            app.panel = uipanel(app.UIFigure);
            app.panel.BorderType = 'none';
            app.panel.Position = [16 12 842 415];

            % Create table_recordedNodes
            app.table_recordedNodes = uitable(app.panel);
            app.table_recordedNodes.ColumnName = {'Recorded Nodes'};
            app.table_recordedNodes.RowName = {};
            app.table_recordedNodes.CellSelectionCallback = createCallbackFcn(app, @table_recordedNodesCellSelection, true);
            app.table_recordedNodes.Position = [13 60 191 347];

            % Create chkB_Suffix_X
            app.chkB_Suffix_X = uicheckbox(app.panel);
            app.chkB_Suffix_X.Text = 'Suffix _X';
            app.chkB_Suffix_X.Position = [364 89 70 22];

            % Create chkB_Suffix_Y
            app.chkB_Suffix_Y = uicheckbox(app.panel);
            app.chkB_Suffix_Y.Text = 'Suffix _Y';
            app.chkB_Suffix_Y.Position = [364 64 70 22];

            % Create chkB_Suffix_Z
            app.chkB_Suffix_Z = uicheckbox(app.panel);
            app.chkB_Suffix_Z.Text = 'Suffix _Z';
            app.chkB_Suffix_Z.Position = [364 39 69 22];

            % Create chkB_SuffixR
            app.chkB_SuffixR = uicheckbox(app.panel);
            app.chkB_SuffixR.Text = 'Suffix R';
            app.chkB_SuffixR.Position = [284 89 64 22];

            % Create chkB_SuffixL
            app.chkB_SuffixL = uicheckbox(app.panel);
            app.chkB_SuffixL.Text = 'Suffix L';
            app.chkB_SuffixL.Position = [284 64 62 22];

            % Create button_ADD
            app.button_ADD = uibutton(app.panel, 'push');
            app.button_ADD.ButtonPushedFcn = createCallbackFcn(app, @button_ADDButtonPushed, true);
            app.button_ADD.Position = [212 222 63 22];
            app.button_ADD.Text = '<< ADD';

            % Create button_deleteSelection
            app.button_deleteSelection = uibutton(app.panel, 'push');
            app.button_deleteSelection.ButtonPushedFcn = createCallbackFcn(app, @button_deleteSelectionPushed, true);
            app.button_deleteSelection.Position = [57 34 103 22];
            app.button_deleteSelection.Text = 'Delete Selection';

            % Create Label_errorMsg
            app.Label_errorMsg = uilabel(app.panel);
            app.Label_errorMsg.HorizontalAlignment = 'center';
            app.Label_errorMsg.FontSize = 11;
            app.Label_errorMsg.FontColor = [0.6392 0.0784 0.1804];
            app.Label_errorMsg.Position = [13 13 191 22];
            app.Label_errorMsg.Text = '';

            % Create button_uploadImage
            app.button_uploadImage = uibutton(app.panel, 'push');
            app.button_uploadImage.ButtonPushedFcn = createCallbackFcn(app, @button_uploadImageButtonPushed, true);
            app.button_uploadImage.Position = [574 385 144 22];
            app.button_uploadImage.Text = 'Upload Image (optional)';

            % Create NodeListTextAreaLabel
            app.NodeListTextAreaLabel = uilabel(app.panel);
            app.NodeListTextAreaLabel.HorizontalAlignment = 'center';
            app.NodeListTextAreaLabel.FontSize = 16;
            app.NodeListTextAreaLabel.Position = [322 385 73 22];
            app.NodeListTextAreaLabel.Text = 'Node List';

            % Create textA_nodeList
            app.textA_nodeList = uitextarea(app.panel);
            app.textA_nodeList.ValueChangedFcn = createCallbackFcn(app, @textA_nodeListValueChanged, true);
            app.textA_nodeList.Position = [283 122 150 264];

            % Create uia_image
            app.uia_image = uiaxes(app.panel);
            app.uia_image.Box = 'on';
            app.uia_image.XColor = 'none';
            app.uia_image.YColor = 'none';
            app.uia_image.ZColor = 'none';
            app.uia_image.Color = 'none';
            app.uia_image.Position = [463 34 366 344];

            % Create button_openImage
            app.button_openImage = uibutton(app.panel, 'push');
            app.button_openImage.ButtonPushedFcn = createCallbackFcn(app, @button_openImageButtonPushed, true);
            app.button_openImage.Enable = 'off';
            app.button_openImage.Position = [576 4 140 22];
            app.button_openImage.Text = 'Open Image in Window';

            % Create button_changeDir
            app.button_changeDir = uibutton(app.UIFigure, 'push');
            app.button_changeDir.ButtonPushedFcn = createCallbackFcn(app, @button_changeDirPushed, true);
            app.button_changeDir.FontSize = 10;
            app.button_changeDir.Position = [720 449 138 19];
            app.button_changeDir.Text = 'Change Directory (optional)';
        end
    end

    methods (Access = public)

        % Construct app
        function app = createNodeStandard

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end