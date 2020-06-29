if temp_str(9) == """pfet""" then
    flag_1=1;
    bl_id_table(bl_id_line)=temp_str(5); bl_id_line=bl_id_line+1;
    
    // BasicBlock
    xcos_mod(line_mod)=temp_str(1)+" "+temp_str(4)+"="+temp_str(5)+" "+temp_str(6)+"="+temp_str(7)+" "+temp_str(8)+"=""PMOS_mod"" "+temp_str(10)+"="+temp_str(11)+" "++temp_str(12)+"=""PMOS_ekv"" "+temp_str(14)+"=""DEFAULT"" "++temp_str(16)+"=""NMOS_mod;flip=false;mirror=false"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabString as=""exprs"" height=""5"" width=""1"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""0"" value=""0.7""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""1"" value=""0.025""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""2"" value=""5.0E-8""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""3"" value=""5.0E-2""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""4"" value=""0.3""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ScilabString"; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabDouble as=""realParameters"" height=""0"" width=""0""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabDouble as=""integerParameters"" height=""0"" width=""0""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="Array as=""objectsParameters"" scilabClass=""ScilabList""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabDouble as=""nbZerosCrossing"" height=""1"" width=""1"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""0"" realPart=""0.0""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ScilabDouble"; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabDouble as=""nmode"" height=""1"" width=""1"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""0"" realPart=""0.0""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ScilabDouble"; line_mod=line_mod+1;
    xcos_mod(line_mod)="Array as=""oDState"" scilabClass=""ScilabList""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="Array as=""equations"" scilabClass=""ScilabTList"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabString height=""1"" width=""5"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""0"" value=""modelica""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""1"" line=""0"" value=""model""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""2"" line=""0"" value=""inputs""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""3"" line=""0"" value=""outputs""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""4"" line=""0"" value=""parameters""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ScilabString"; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabString height=""1"" width=""1"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""0"" value=""PMOS_mod""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ScilabString"; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabString height=""1"" width=""1"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""0"" value=""G""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ScilabString"; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabString height=""3"" width=""1"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""0"" value=""D""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""1"" value=""B""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""2"" value=""S""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ScilabString"; line_mod=line_mod+1;
    xcos_mod(line_mod)="Array scilabClass=""ScilabList"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabString height=""5"" width=""1"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""0"" value=""K""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""1"" value=""UT""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""2"" value=""Ith""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""3"" value=""sig""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""4"" value=""VT0""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ScilabString"; line_mod=line_mod+1;
    xcos_mod(line_mod)="ScilabDouble height=""5"" width=""1"""; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""0"" realPart=""0.7""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""1"" realPart=""0.025""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""2"" realPart=""5.0E-8""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""3"" realPart=""5.0E-2""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="data column=""0"" line=""4"" realPart=""0.3""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ScilabDouble"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/Array"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/Array"; line_mod=line_mod+1;
    //xcos_mod(line_mod)="/Array"; line_mod=line_mod+1;
    line_org=line_org+27;
    temp_str=strsplit(xcos_org(line_org),[" ";"="]);
    xcos_mod(line_mod)="mxGeometry as=""geometry"" height=""40.0"" width=""80.0"" x="+temp_str(9)+" y="+temp_str(11);line_org=line_org+1; line_mod=line_mod+1;
    xcos_mod(line_mod)="/BasicBlock"; line_org=line_org+1; line_mod=line_mod+1;
    
    // InputPorts
    temp_str=strsplit(xcos_org(line_org),[" ";"="]);
    temp_str1=strsplit(temp_str(11),["""";]);
    
    ordering_no=1; // Input 1
    xcos_mod(line_mod)="ImplicitInputPort dataColumns=""1"" dataLines=""1"" dataType=""REAL_MATRIX"" id="""+temp_str1(2)+"_in"+string(ordering_no)+""" ordering="""+string(ordering_no)+""" parent="+temp_str(11)+" style=""ImplicitInputPort;align=left;verticalAlign=middle;spacing=10.0;rotation=0;flip=false;mirror=false"" value="""""; line_mod=line_mod+1;
    xcos_mod(line_mod)="mxGeometry as=""geometry"" height=""8.0"" width=""8.0"" x=""-8.0"" y=""16.0""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ImplicitInputPort"; line_mod=line_mod+1;
    
    line_org=line_org+3;
    
    // OutputPorts
    temp_str=strsplit(xcos_org(line_org),[" ";"="]);
    temp_str1=strsplit(temp_str(11),["""";]);
    
    ordering_no=1; // Output 1
    xcos_mod(line_mod)="ImplicitOutputPort dataColumns=""1"" dataLines=""1"" dataType=""REAL_MATRIX"" id="""+temp_str1(2)+"_out"+string(ordering_no)+""" ordering="""+string(ordering_no)+""" parent="+temp_str(11)+" style=""ImplicitOutputPort;align=right;verticalAlign=middle;spacing=10.0;rotation=0;flip=false;mirror=false"" value="""""; line_mod=line_mod+1;
    xcos_mod(line_mod)="mxGeometry as=""geometry"" height=""8.0"" width=""8.0"" x=""80.0"" y=""6.0""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ImplicitOutputPort"; line_mod=line_mod+1;
    
    ordering_no=2; // Output 2
    xcos_mod(line_mod)="ImplicitOutputPort dataColumns=""1"" dataLines=""1"" dataType=""REAL_MATRIX"" id="""+temp_str1(2)+"_out"+string(ordering_no)+""" ordering="""+string(ordering_no)+""" parent="+temp_str(11)+" style=""ImplicitOutputPort;align=right;verticalAlign=middle;spacing=10.0;rotation=0;flip=false;mirror=false"" value="""""; line_mod=line_mod+1;
    xcos_mod(line_mod)="mxGeometry as=""geometry"" height=""8.0"" width=""8.0"" x=""80.0"" y=""16.0""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ImplicitOutputPort"; line_mod=line_mod+1;
    
    ordering_no=3; // Output 2
    xcos_mod(line_mod)="ImplicitOutputPort dataColumns=""1"" dataLines=""1"" dataType=""REAL_MATRIX"" id="""+temp_str1(2)+"_out"+string(ordering_no)+""" ordering="""+string(ordering_no)+""" parent="+temp_str(11)+" style=""ImplicitOutputPort;align=right;verticalAlign=middle;spacing=10.0;rotation=0;flip=false;mirror=false"" value="""""; line_mod=line_mod+1;
    xcos_mod(line_mod)="mxGeometry as=""geometry"" height=""8.0"" width=""8.0"" x=""80.0"" y=""26.0""/"; line_mod=line_mod+1;
    xcos_mod(line_mod)="/ImplicitOutputPort"; line_mod=line_mod+1;
    
    line_org=line_org+3;
end
