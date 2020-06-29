function [tar_pgm_result]=read_tar_pgm_result(result_file_name,m_graph,time_scale)
    fd = mopen(result_file_name,'r'); 
    j=1;
    str_temp = mgetstr(7,fd);
    while str_temp ~= "0xffff ",
        tar_pgm_result(j,1) = msscanf(str_temp,"%x");
        for i=2:m_graph
            tar_pgm_result(j,i) = msscanf(mgetstr(7,fd),"%x");
        end
        str_temp = mgetstr(7,fd);
        j=j+1;
    end
    mclose(fd);
    tar_pgm_result(:,2)=tar_pgm_result(:,2)*time_scale;
endfunction

