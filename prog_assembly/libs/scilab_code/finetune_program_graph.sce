time_scale=1e-5; // Time unit : 10us
clear data_05; data_05=read_tar_pgm_result('data'+info_name+'5.hex',m_graph,time_scale);

data_05_size = size(data_05);
data=[data_05]; fprintfMat("target_program_ADC"+info_name+fname+".data", data, "%5.15f");
for i=3:m_graph
    data(:,i)=diodeADC_v2i(diodeADC_h2v(data(:,i),chip_num,brdtype),chip_num,brdtype)/kapa_constant_or_not;
end
fprintfMat("target_program_Current"+info_name+fname+".data", data, "%5.15f");

clear legend_target_list; legend_target_list = ('a');

if showprog == 1 then
    scf(info_win_num1);
    clf(info_win_num1);
    j=1;
    for i=3:m_graph
        temp=modulo(i,7)+1;
        plot2d("nl", data(:,2), data(:,i), style=temp);
        p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    legend(legend_target_list(:,1),"in_lower_right"); // "in_upper_left" "in_lower_right"
    xtitle("","time [s]", "Id [A]");
    a=gca();a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-12;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-03;
    
    clear final_current;
    final_current(1,:)=data(data_05_size(1),3:data_05_size(2));
    
    clear target_current;
    target_current(1,:)=target_list(:,3)';
    
    clear current_compare; clear current_compare_perc;
    current_compare(1,:)=target_current(1,:)-final_current(1,:);
    for i=1:n_graph
        current_compare_perc(1,i)=100 * (current_compare(1,i) / target_current(1,i));
    end
    
    disp(target_current)
    disp(current_compare_perc)
    
    scf(info_win_num2);
    clf(info_win_num2);
    j=1;
    for i=1:n_graph
        temp=modulo(i,7)+1;
        plot2d("ln", target_current(1,i), current_compare_perc(1,i));p=get("hdl");p.children.mark_style=8;p.children.thickness=3;p.children.mark_foreground=temp;p.children.line_mode = 'off';
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    xtitle("","target current [A]", "errer [%]"); a=gca(); a.data_bounds=[1E-12 -20; 1E-3 100];
    
    scf(info_win_num3);
    clf(info_win_num3);
    j=1;
    for i=1:n_graph
        temp=modulo(i,7)+1;
        plot2d("ln", target_current(1,i), current_compare_perc(1,i));p=get("hdl");p.children.mark_style=9;p.children.thickness=3;p.children.mark_foreground=temp;p.children.line_mode = 'off';
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    xtitle("","target current [A]", "errer [%]"); a=gca(); a.data_bounds=[1E-12 -5.0; 1E-3 5.0];
end
