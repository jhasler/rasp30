clear mite_473_977_10uA;
mite_473_977_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
//polyfit
[p_mite_977_10uA,S_mite_977_10uA]=polyfit(mite_473_977_10uA(:,1), mite_473_977_10uA(:,2),7);
size_a=size(mite_473_977_10uA);
MITE_range_977 = mite_473_977_10uA(size_a(1,1),1):1:mite_473_977_10uA(1,1);
MITE_fit_977 = polyval(p_mite_977_10uA,MITE_range_977,S_mite_977_10uA);

//clear mite_473_978_10uA;
//mite_473_978_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_978_chip"+chip_num+brdtype);
////polyfit
//[p_mite_978_10uA,S_mite_978_10uA]=polyfit(mite_473_978_10uA(:,1), mite_473_978_10uA(:,2),7);
//size_b=size(mite_473_978_10uA);
//MITE_range_978 =  mite_473_978_10uA(size_b(1,1),1):1:mite_473_978_10uA(1,1);
//MITE_fit_978 = polyval(p_mite_978_10uA,MITE_range_978,S_mite_978_10uA);
//
//clear mite_473_979_10uA;
//mite_473_979_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_979_chip"+chip_num+brdtype);
////polyfit
//[p_mite_979_10uA,S_mite_979_10uA]=polyfit(mite_473_979_10uA(:,1), mite_473_979_10uA(:,2),7);
//size_c=size(mite_473_979_10uA);
//MITE_range_979 = mite_473_979_10uA(size_c(1,1),1):1:mite_473_979_10uA(1,1);
//MITE_fit_979 = polyval(p_mite_979_10uA,MITE_range_979,S_mite_979_10uA);




//// 980 to 986, 1009 to 1018 uses same data with 977 at the moment.
//clear mite_473_980_10uA;
//mite_473_980_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_980_10uA,S_mite_980_10uA]=polyfit(mite_473_980_10uA(:,1), mite_473_980_10uA(:,2),7);
//size_a=size(mite_473_980_10uA);
//MITE_range_980 = mite_473_980_10uA(size_a(1,1),1):1:mite_473_980_10uA(1,1);
//MITE_fit_980 = polyval(p_mite_980_10uA,MITE_range_980,S_mite_980_10uA);
//
//clear mite_473_981_10uA;
//mite_473_981_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_981_10uA,S_mite_981_10uA]=polyfit(mite_473_981_10uA(:,1), mite_473_981_10uA(:,2),7);
//size_a=size(mite_473_981_10uA);
//MITE_range_981 = mite_473_981_10uA(size_a(1,1),1):1:mite_473_981_10uA(1,1);
//MITE_fit_981 = polyval(p_mite_981_10uA,MITE_range_981,S_mite_981_10uA);
//
//clear mite_473_982_10uA;
//mite_473_982_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_982_10uA,S_mite_982_10uA]=polyfit(mite_473_982_10uA(:,1), mite_473_982_10uA(:,2),7);
//size_a=size(mite_473_982_10uA);
//MITE_range_982 = mite_473_982_10uA(size_a(1,1),1):1:mite_473_982_10uA(1,1);
//MITE_fit_982 = polyval(p_mite_982_10uA,MITE_range_982,S_mite_982_10uA);
//
//clear mite_473_983_10uA;
//mite_473_983_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_983_10uA,S_mite_983_10uA]=polyfit(mite_473_983_10uA(:,1), mite_473_983_10uA(:,2),7);
//size_a=size(mite_473_983_10uA);
//MITE_range_983 = mite_473_983_10uA(size_a(1,1),1):1:mite_473_983_10uA(1,1);
//MITE_fit_983 = polyval(p_mite_983_10uA,MITE_range_983,S_mite_983_10uA);
//
//clear mite_473_984_10uA;
//mite_473_984_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_984_10uA,S_mite_984_10uA]=polyfit(mite_473_984_10uA(:,1), mite_473_984_10uA(:,2),7);
//size_a=size(mite_473_984_10uA);
//MITE_range_984 = mite_473_984_10uA(size_a(1,1),1):1:mite_473_984_10uA(1,1);
//MITE_fit_984 = polyval(p_mite_984_10uA,MITE_range_984,S_mite_984_10uA);
//
//clear mite_473_985_10uA;
//mite_473_985_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_985_10uA,S_mite_985_10uA]=polyfit(mite_473_985_10uA(:,1), mite_473_985_10uA(:,2),7);
//size_a=size(mite_473_985_10uA);
//MITE_range_985 = mite_473_985_10uA(size_a(1,1),1):1:mite_473_985_10uA(1,1);
//MITE_fit_985 = polyval(p_mite_985_10uA,MITE_range_985,S_mite_985_10uA);
//
//clear mite_473_986_10uA;
//mite_473_986_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_986_10uA,S_mite_986_10uA]=polyfit(mite_473_986_10uA(:,1), mite_473_986_10uA(:,2),7);
//size_a=size(mite_473_986_10uA);
//MITE_range_986 = mite_473_986_10uA(size_a(1,1),1):1:mite_473_986_10uA(1,1);
//MITE_fit_986 = polyval(p_mite_986_10uA,MITE_range_986,S_mite_986_10uA);
//
//clear mite_473_1009_10uA;
//mite_473_1009_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1009_10uA,S_mite_1009_10uA]=polyfit(mite_473_1009_10uA(:,1), mite_473_1009_10uA(:,2),7);
//size_a=size(mite_473_1009_10uA);
//MITE_range_1009 = mite_473_1009_10uA(size_a(1,1),1):1:mite_473_1009_10uA(1,1);
//MITE_fit_1009 = polyval(p_mite_1009_10uA,MITE_range_1009,S_mite_1009_10uA);
//
//clear mite_473_1010_10uA;
//mite_473_1010_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1010_10uA,S_mite_1010_10uA]=polyfit(mite_473_1010_10uA(:,1), mite_473_1010_10uA(:,2),7);
//size_a=size(mite_473_1010_10uA);
//MITE_range_1010 = mite_473_1010_10uA(size_a(1,1),1):1:mite_473_1010_10uA(1,1);
//MITE_fit_1010 = polyval(p_mite_1010_10uA,MITE_range_1010,S_mite_1010_10uA);
//
//clear mite_473_1011_10uA;
//mite_473_1011_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1011_10uA,S_mite_1011_10uA]=polyfit(mite_473_1011_10uA(:,1), mite_473_1011_10uA(:,2),7);
//size_a=size(mite_473_1011_10uA);
//MITE_range_1011 = mite_473_1011_10uA(size_a(1,1),1):1:mite_473_1011_10uA(1,1);
//MITE_fit_1011 = polyval(p_mite_1011_10uA,MITE_range_1011,S_mite_1011_10uA);
//
//clear mite_473_1012_10uA;
//mite_473_1012_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1012_10uA,S_mite_1012_10uA]=polyfit(mite_473_1012_10uA(:,1), mite_473_1012_10uA(:,2),7);
//size_a=size(mite_473_1012_10uA);
//MITE_range_1012 = mite_473_1012_10uA(size_a(1,1),1):1:mite_473_1012_10uA(1,1);
//MITE_fit_1012 = polyval(p_mite_1012_10uA,MITE_range_1012,S_mite_1012_10uA);
//
//clear mite_473_1013_10uA;
//mite_473_1013_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1013_10uA,S_mite_1013_10uA]=polyfit(mite_473_1013_10uA(:,1), mite_473_1013_10uA(:,2),7);
//size_a=size(mite_473_1013_10uA);
//MITE_range_1013 = mite_473_1013_10uA(size_a(1,1),1):1:mite_473_1013_10uA(1,1);
//MITE_fit_1013 = polyval(p_mite_1013_10uA,MITE_range_1013,S_mite_1013_10uA);
//
//clear mite_473_1014_10uA;
//mite_473_1014_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1014_10uA,S_mite_1014_10uA]=polyfit(mite_473_1014_10uA(:,1), mite_473_1014_10uA(:,2),7);
//size_a=size(mite_473_1014_10uA);
//MITE_range_1014 = mite_473_1014_10uA(size_a(1,1),1):1:mite_473_1014_10uA(1,1);
//MITE_fit_1014 = polyval(p_mite_1014_10uA,MITE_range_1014,S_mite_1014_10uA);
//
//clear mite_473_1015_10uA;
//mite_473_1015_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1015_10uA,S_mite_1015_10uA]=polyfit(mite_473_1015_10uA(:,1), mite_473_1015_10uA(:,2),7);
//size_a=size(mite_473_1015_10uA);
//MITE_range_1015 = mite_473_1015_10uA(size_a(1,1),1):1:mite_473_1015_10uA(1,1);
//MITE_fit_1015 = polyval(p_mite_1015_10uA,MITE_range_1015,S_mite_1015_10uA);
//
//clear mite_473_1016_10uA;
//mite_473_1016_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1016_10uA,S_mite_1016_10uA]=polyfit(mite_473_1016_10uA(:,1), mite_473_1016_10uA(:,2),7);
//size_a=size(mite_473_1016_10uA);
//MITE_range_1016 = mite_473_1016_10uA(size_a(1,1),1):1:mite_473_1016_10uA(1,1);
//MITE_fit_1016 = polyval(p_mite_1016_10uA,MITE_range_1016,S_mite_1016_10uA);
//
//clear mite_473_1017_10uA;
//mite_473_1017_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1017_10uA,S_mite_1017_10uA]=polyfit(mite_473_1017_10uA(:,1), mite_473_1017_10uA(:,2),7);
//size_a=size(mite_473_1017_10uA);
//MITE_range_1017 = mite_473_1017_10uA(size_a(1,1),1):1:mite_473_1017_10uA(1,1);
//MITE_fit_1017 = polyval(p_mite_1017_10uA,MITE_range_1017,S_mite_1017_10uA);
//
//clear mite_473_1018_10uA;
//mite_473_1018_10uA=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC/data_miteADC473_977_chip"+chip_num+brdtype);
////polyfit
//[p_mite_1018_10uA,S_mite_1018_10uA]=polyfit(mite_473_1018_10uA(:,1), mite_473_1018_10uA(:,2),7);
//size_a=size(mite_473_1018_10uA);
//MITE_range_1018 = mite_473_1018_10uA(size_a(1,1),1):1:mite_473_1018_10uA(1,1);
//MITE_fit_1018 = polyval(p_mite_1018_10uA,MITE_range_1018,S_mite_1018_10uA);


//// Plot the data
//scf(7);
//clf(7);
//plot2d("nn", mite_473_977_10uA(:,1), mite_473_977_10uA(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
//plot2d("nn", mite_473_978_10uA(:,1), mite_473_978_10uA(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
//plot2d("nn", mite_473_979_10uA(:,1), mite_473_979_10uA(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=3;
//plot2d("nn", MITE_range_977, MITE_fit_977, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", MITE_range_978, MITE_fit_978, style=2);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", MITE_range_979, MITE_fit_979, style=3);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//a=gca();//a.data_bounds=[0 0; 150 2.6];
//legend("mite_473_977","mite_473_978","mite_473_979","in_upper_right");
//xtitle("","ADC code","Vg (V)");
