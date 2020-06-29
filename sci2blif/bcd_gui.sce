global bcd_file_name folder_name;

//////////
fcal=figure('figure_position',[400,400],'figure_size',[250,350],'auto_resize','on','background',[12],'figure_name','Block & Connection Description');
//////////
delmenu(fcal.figure_id,gettext('File'));
delmenu(fcal.figure_id,gettext('?'));
delmenu(fcal.figure_id,gettext('Tools'));
delmenu(fcal.figure_id,gettext('Edit'));
toolbar(fcal.figure_id,'off');
handles.dummy = 0;

//bcd = Block and Connection Description
handles.bcd_folder_name=uicontrol(fcal,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.7,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Enter_Folder_Name','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','bcd_folder_name','Callback','bcd_folder_name_callback()');
handles.bcd_file_name=uicontrol(fcal,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.55,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Enter_File_Name','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','bcd_file_name','Callback','bcd_file_name_callback()');
//handles.bcd_example=uicontrol(fcal,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.5,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Example','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','bcd_example','Callback','bcd_example_callback()');
handles.bcd_xcosgen=uicontrol(fcal,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.4,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Xcos generation','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','bcd_xcosgen','Callback','bcd_xcosgen_callback()');
handles.bcd_sim=uicontrol(fcal,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.25,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Simulation','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','bcd_sim','Callback','bcd_sim_callback()');
dir_menu = uimenu("Parent", fcal, "Label", gettext("Directions"), 'ForegroundColor',[0.53,0.81,0.98],"callback", "dir_callback();");

