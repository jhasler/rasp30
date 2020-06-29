global file_name path fname extension board_num chip_num;

fd_r1 = mopen(fname+".xcos",'r'); xcos_org0=mgetl(fd_r1, 1); xcos_org0=strsplit(xcos_org0,['><';'<';'>';]); mclose(fd_r1);

size_xcos_org0=size(xcos_org0);

xcos_org="";
for i=2:size_xcos_org0(1)-1
    xcos_org(i-1)=xcos_org0(i);
end

xcos_mod="";
bl_id_table=""; bl_id_line=1;
size_xcos_org=size(xcos_org);
line_org=1;
line_mod=1;
while line_org < size_xcos_org(1)
    flag_1=0;
    temp_str=strsplit(xcos_org(line_org),[" ";"="]);
    size_temp_str=size(temp_str);
    if temp_str(1) == "?xml" then
        flag_1=1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
    end
    if temp_str(1) == "BasicBlock" then
        // Convert each block
        file_list=listfiles("/home/ubuntu/rasp30/sci2blif/con2mod_added_blocks/*.sce");
        size_file_list=size(file_list);
        if file_list ~= [] then
            for i=1:size_file_list(1)
                exec(file_list(i),-1);
            end
        end
    end
    if temp_str(1) == "/root" then
        flag_1=1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
        xcos_mod(line_mod)=xcos_org(line_org); line_org=line_org+1; line_mod=line_mod+1;
    end
    if flag_1 == 0 then
        while flag_1 == 0
            line_org=line_org+1;
            temp_str=strsplit(xcos_org(line_org),[" ";"="]);
            if temp_str(1) == "?xml" then flag_1 = 1; end
            if temp_str(1) == "BasicBlock" then flag_1 = 1; end
            if temp_str(1) == "/root" then flag_1 = 1; end
        end
    end
end

for i=1:line_mod-1
    xcos_mod(i)="<"+xcos_mod(i)+">";
end

fd_w= mopen(fname+"_modelica.xcos",'wt'); mputl(xcos_mod,fd_w); mclose(fd_w);

xcos(fname+"_modelica.xcos");
