function op_compile = output_compile(x,y)

        clear temp_spring
        No_of_output = '0x'+ string(sprintf('%4.4x', y))
        mite_row_address = '0x'+ string(sprintf('%4.4x', 473))
        mite_col_address = '0x'+ string(sprintf('%4.4x', 1009))
        temp_string = No_of_output + ' ' + mite_row_address + ' ' + mite_col_address + ' ' + '0xFFFF'
        fd = mopen('output_info','wt'); mputl(temp_string, fd); mclose(fd);
        disp(temp_string)
    
op_compile = 1
    
endfunction
