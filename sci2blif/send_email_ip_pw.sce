global email_id_string email_pw_string chip_num email_name fname;

fsendemail=figure('figure_position',[800,400],'figure_size',[250,200],'auto_resize','on','background',[12],'figure_name','Send Email ID & PW');

delmenu(fsendemail.figure_id,gettext('File'))
delmenu(fsendemail.figure_id,gettext('?'))
delmenu(fsendemail.figure_id,gettext('Tools'))
delmenu(fsendemail.figure_id,gettext('Edit'))
toolbar(fsendemail.figure_id,'off')
handles.dummy = 0;

handles.email_id=uicontrol(fsendemail,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.70,0.7,0.2],'Relief','flat','SliderStep',[0.01,0.1],'String','Email address','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','email_id','Callback','email_id_callback(handles)');
handles.email_pw=uicontrol(fsendemail,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[0,0,0],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.15,0.4,0.7,0.2],'Relief','flat','SliderStep',[0.01,0.1],'String','Password','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','email_pw','Callback','email_pw_callback(handles)');
handles.Send=uicontrol(fsendemail,'unit','normalized','BackgroundColor',[0.27,0.5,0.7],'Enable','on','FontAngle','normal','FontName','mukti narrow','FontSize',[14],'FontUnits','points','FontWeight','bold','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.35,0.1,0.3,0.2],'Relief','flat','SliderStep',[0.01,0.1],'String','Send','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','Send','Callback','id_pw_send_email(handles)');

