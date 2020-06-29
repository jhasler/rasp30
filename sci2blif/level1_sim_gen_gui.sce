global L1_sim_name;

fcal=figure('figure_position',[400,400],'figure_size',[250,350],'auto_resize','on','background',[12],'figure_name','Generate Level1 Simulation');
delmenu(fcal.figure_id,gettext('File'));
delmenu(fcal.figure_id,gettext('?'));
delmenu(fcal.figure_id,gettext('Tools'));
delmenu(fcal.figure_id,gettext('Edit'));
toolbar(fcal.figure_id,'off');
handles.dummy = 0;

//L1_sim = Level 1 Simulation
//handles.MC_folder_name=uicontrol(fcal,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.7,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Enter_Folder_Name','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','MC_folder_name','Callback','MC_folder_name_callback()');
handles.L1_sim_name=uicontrol(fcal,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.55,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Enter_L1_Sim_Name','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','L1_sim_name','Callback','L1_sim_name_callback()');
handles.Start_L1_sim=uicontrol(fcal,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.4,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Start Level 1 Sim.','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','Start_L1_sim','Callback','Start_L1_sim_callback()');
handles.Gen_L1_sim=uicontrol(fcal,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.25,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Generate Level 1 Sim.','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','Gen_L1_sim','Callback','Gen_L1_sim_callback()');

dir_menu = uimenu("Parent", fcal, "Label", gettext("Directions"), 'ForegroundColor',[0.53,0.81,0.98],"callback", "dir_callback();");

