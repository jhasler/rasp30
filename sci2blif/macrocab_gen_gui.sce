global file_name path fname extension chip_num board_num brdtype macrocab_name folder_name bl_level;

//////////
fcal=figure('figure_position',[400,400],'figure_size',[250,350],'auto_resize','on','background',[12],'figure_name','Generate Macro-CAB block');
//////////
delmenu(fcal.figure_id,gettext('File'));
delmenu(fcal.figure_id,gettext('?'));
delmenu(fcal.figure_id,gettext('Tools'));
delmenu(fcal.figure_id,gettext('Edit'));
toolbar(fcal.figure_id,'off');
handles.dummy = 0;

//MC = Macro CAB
handles.MC_folder_name=uicontrol(fcal,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.8,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Enter_Folder_Name','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','MC_folder_name','Callback','MC_folder_name_callback()');
handles.MC_block_name=uicontrol(fcal,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.65,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Enter_Block_Name','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','MC_block_name','Callback','MC_block_name_callback()');
handles.MC_bl_level=uicontrol(fcal,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.5,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Choose Block Category|Level 1|Level 2','Style','popupmenu','Value',[1 2 3],'VerticalAlignment','middle','Visible','on','Tag','Block_level','Callback','MC_bl_level_callback()');
handles.Start_MC_design=uicontrol(fcal,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.35,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Start MC Design','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','Start_MC_design','Callback','Start_MC_design_callback()');
handles.Generate_MC=uicontrol(fcal,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.2,0.7,0.1],'Relief','flat','SliderStep',[0.01,0.1],'String','Generate Macrocab','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','Generate_MC','Callback','Generate_MC_callback()');

dir_menu = uimenu("Parent", fcal, "Label", gettext("Directions"), 'ForegroundColor',[0.53,0.81,0.98],"callback", "dir_callback();");

