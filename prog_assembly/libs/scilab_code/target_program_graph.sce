time_scale=1e-5; // Time unit : 10us
clear data_02; data_02=read_tar_pgm_result('data'+info_name+'2.hex',m_graph,time_scale);
clear data_03; data_03=read_tar_pgm_result('data'+info_name+'3.hex',m_graph,time_scale);
clear data_04; data_04=read_tar_pgm_result('data'+info_name+'4.hex',m_graph,time_scale);
clear data_05; data_05=read_tar_pgm_result('data'+info_name+'5.hex',m_graph,time_scale);

global target_current_difference;
data_02_size = size(data_02); data_03_size = size(data_03); data_04_size = size(data_04); data_05_size = size(data_05);
data_03(:,2)=data_03(:,2)+data_02(data_02_size(1,1),2); data_04(:,2)=data_04(:,2)+data_03(data_03_size(1,1),2); data_05(:,2)=data_05(:,2)+data_04(data_04_size(1,1),2);
data=[data_02;data_03;data_04;data_05]; fprintfMat("target_program_ADC"+info_name+fname+".data", data, "%5.15f");
//for i=3:m_graph
//    data(:,i)=exp(polyval(p1,data(:,i),S1))/kapa_constant_or_not;
//end
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
    final_current(1,:)=data(data_02_size(1),3:data_02_size(2));
    final_current(2,:)=data(data_02_size(1)+data_03_size(1),3:data_02_size(2));
    final_current(3,:)=data(data_02_size(1)+data_03_size(1)+data_04_size(1),3:data_02_size(2));
    final_current(4,:)=data(data_02_size(1)+data_03_size(1)+data_04_size(1)+data_05_size(1),3:data_02_size(2));
    //a_2=data_02_size(1)+data_03_size(1)+data_04_size(1)+data_05_size(1);
    //a_3=a_2-31;
    //clear a_4;
    //for i=3:data_02_size(2)
    //    a_4(i-2)=mean(data(a_3:a_2,i));
    //end
    //final_current(4,:)=a_4';
    
    clear target_current;
    target_current(1,:)=target_list(:,3)';
    target_current(2,:)=target_list(:,3)';
    target_current(3,:)=target_list(:,3)';
    target_current(4,:)=target_list(:,3)';
    
    clear current_compare; clear current_compare_perc;
    current_compare(1,:)=target_current(1,:)-final_current(1,:);
    current_compare(2,:)=target_current(2,:)-final_current(2,:);
    current_compare(3,:)=target_current(3,:)-final_current(3,:);
    current_compare(4,:)=target_current(4,:)-final_current(4,:);
    for i=1:n_graph
        current_compare_perc(1,i)=100 * (current_compare(1,i) / target_current(1,i));
        current_compare_perc(2,i)=100 * (current_compare(2,i) / target_current(2,i));
        current_compare_perc(3,i)=100 * (current_compare(3,i) / target_current(3,i));
        current_compare_perc(4,i)=100 * (current_compare(4,i) / target_current(4,i));
    end
    
target_current_difference=target_current(4,:)-final_current(4,:);
    disp('Error in nA from target current')
    disp(target_current_difference*1e9)
    scf(info_win_num2);
    clf(info_win_num2);
    j=1;
    for i=1:n_graph
        temp=modulo(i,7)+1;
        plot2d("ln", target_current(2,i), current_compare_perc(2,i));p=get("hdl");p.children.mark_style=8;p.children.thickness=3;p.children.mark_foreground=temp;p.children.line_mode = 'off';
        plot2d("ln", target_current(3,i), current_compare_perc(3,i));p=get("hdl");p.children.mark_style=2;p.children.thickness=3;p.children.mark_foreground=temp;p.children.line_mode = 'off';
        plot2d("ln", target_current(4,i), current_compare_perc(4,i));p=get("hdl");p.children.mark_style=9;p.children.thickness=3;p.children.mark_foreground=temp;p.children.line_mode = 'off';
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    xtitle("","target current [A]", "errer [%]"); a=gca(); a.data_bounds=[1E-12 -20; 1E-3 100];
    
    scf(info_win_num3);
    clf(info_win_num3);
    j=1;
    for i=1:n_graph
        temp=modulo(i,7)+1;
        plot2d("ln", target_current(4,i), current_compare_perc(4,i));p=get("hdl");p.children.mark_style=9;p.children.thickness=3;p.children.mark_foreground=temp;p.children.line_mode = 'off';
        legend_target_list(j,1)='Row. ' + string(target_list(j,1)) + ', Col. ' + string(target_list(j,2));
        j=j+1;
    end
    xtitle("","target current [A]", "errer [%]"); a=gca(); a.data_bounds=[1E-12 -5.0; 1E-3 5.0];
end
