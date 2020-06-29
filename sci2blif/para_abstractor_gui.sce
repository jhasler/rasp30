global para_abs_name;

//////////
fcal=figure('figure_position',[400,400],'figure_size',[250,350],'auto_resize','on','background',[12],'figure_name','Abstract Block Parameters');
//////////
delmenu(fcal.figure_id,gettext('File'));
delmenu(fcal.figure_id,gettext('?'));
delmenu(fcal.figure_id,gettext('Tools'));
delmenu(fcal.figure_id,gettext('Edit'));
toolbar(fcal.figure_id,'off');
handles.dummy = 0;

//BP = Block Parameter
//handles.MB_folder_name=uicontrol(fcal,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.7,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Enter_Folder_Name','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','MB_folder_name','Callback','MB_folder_name_callback()');
handles.BP_block_name=uicontrol(fcal,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.55,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Enter_Block_Name','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','BP_block_name','Callback','BP_block_name_callback()');
//handles.Start_MB_design=uicontrol(fcal,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.4,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Start MB Design','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','Start_MB_design','Callback','Start_MB_design_callback()');
handles.Show_BP=uicontrol(fcal,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.25,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Generate Macroblif','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','Show_BP','Callback','Show_BP_callback()');

dir_menu = uimenu("Parent", fcal, "Label", gettext("Directions"), 'ForegroundColor',[0.53,0.81,0.98],"callback", "dir_callback();");
