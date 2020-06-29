global file_name path fname extension chip_num board_num hex_1nA hex_1na;

clear onchip_dac00_char_data;
onchip_dac00_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC00_chip"+chip_num+brdtype);
[p_onchip_dac00,S_onchip_dac00]=polyfit(onchip_dac00_char_data(:,1), onchip_dac00_char_data(:,2),7);
DAC00_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC00_fit = polyval(p_onchip_dac00,DAC00_HEX_range,S_onchip_dac00);
DAC00_char_table = [DAC00_HEX_range(:) DAC00_fit(:)];

clear onchip_dac01_char_data;
onchip_dac01_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC01_chip"+chip_num+brdtype);
[p_onchip_dac01,S_onchip_dac01]=polyfit(onchip_dac01_char_data(:,1), onchip_dac01_char_data(:,2),7);
DAC01_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC01_fit = polyval(p_onchip_dac01,DAC01_HEX_range,S_onchip_dac01);
DAC01_char_table = [DAC01_HEX_range(:) DAC01_fit(:)];

clear onchip_dac02_char_data;
onchip_dac02_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC02_chip"+chip_num+brdtype);
[p_onchip_dac02,S_onchip_dac02]=polyfit(onchip_dac02_char_data(:,1), onchip_dac02_char_data(:,2),7);
DAC02_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC02_fit = polyval(p_onchip_dac02,DAC02_HEX_range,S_onchip_dac02);
DAC02_char_table = [DAC02_HEX_range(:) DAC02_fit(:)];

clear onchip_dac03_char_data;
onchip_dac03_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC03_chip"+chip_num+brdtype);
[p_onchip_dac03,S_onchip_dac03]=polyfit(onchip_dac03_char_data(:,1), onchip_dac03_char_data(:,2),7);
DAC03_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC03_fit = polyval(p_onchip_dac03,DAC03_HEX_range,S_onchip_dac03);
DAC03_char_table = [DAC03_HEX_range(:) DAC03_fit(:)];

clear onchip_dac04_char_data;
onchip_dac04_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC04_chip"+chip_num+brdtype);
[p_onchip_dac04,S_onchip_dac04]=polyfit(onchip_dac04_char_data(:,1), onchip_dac04_char_data(:,2),7);
DAC04_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC04_fit = polyval(p_onchip_dac04,DAC04_HEX_range,S_onchip_dac04);
DAC04_char_table = [DAC04_HEX_range(:) DAC04_fit(:)];

clear onchip_dac05_char_data;
onchip_dac05_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC05_chip"+chip_num+brdtype);
[p_onchip_dac05,S_onchip_dac05]=polyfit(onchip_dac05_char_data(:,1), onchip_dac05_char_data(:,2),7);
DAC05_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC05_fit = polyval(p_onchip_dac05,DAC05_HEX_range,S_onchip_dac05);
DAC05_char_table = [DAC05_HEX_range(:) DAC05_fit(:)];

clear onchip_dac06_char_data;
onchip_dac06_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC06_chip"+chip_num+brdtype);
[p_onchip_dac06,S_onchip_dac06]=polyfit(onchip_dac06_char_data(:,1), onchip_dac06_char_data(:,2),7);
DAC06_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC06_fit = polyval(p_onchip_dac06,DAC06_HEX_range,S_onchip_dac06);
DAC06_char_table = [DAC06_HEX_range(:) DAC06_fit(:)];

clear onchip_dac07_char_data;
onchip_dac07_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC07_chip"+chip_num+brdtype);
[p_onchip_dac07,S_onchip_dac07]=polyfit(onchip_dac07_char_data(:,1), onchip_dac07_char_data(:,2),7);
DAC07_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC07_fit = polyval(p_onchip_dac07,DAC07_HEX_range,S_onchip_dac07);
DAC07_char_table = [DAC07_HEX_range(:) DAC07_fit(:)];

clear onchip_dac08_char_data;
onchip_dac08_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC08_chip"+chip_num+brdtype);
[p_onchip_dac08,S_onchip_dac08]=polyfit(onchip_dac08_char_data(:,1), onchip_dac08_char_data(:,2),7);
DAC08_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC08_fit = polyval(p_onchip_dac08,DAC08_HEX_range,S_onchip_dac08);
DAC08_char_table = [DAC08_HEX_range(:) DAC08_fit(:)];

clear onchip_dac09_char_data;
onchip_dac09_char_data=csvRead("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_onchipDAC/data_onchipDAC09_chip"+chip_num+brdtype);
[p_onchip_dac09,S_onchip_dac09]=polyfit(onchip_dac09_char_data(:,1), onchip_dac09_char_data(:,2),7);
DAC09_HEX_range = hex2dec('0000'):1:hex2dec('007F');
DAC09_fit = polyval(p_onchip_dac09,DAC09_HEX_range,S_onchip_dac09);
DAC09_char_table = [DAC09_HEX_range(:) DAC09_fit(:)];

//// Plot the data
//scf(6);
//clf(6);
//plot2d("nn", onchip_dac00_char_data(:,1), onchip_dac00_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
//plot2d("nn", onchip_dac01_char_data(:,1), onchip_dac01_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
//plot2d("nn", onchip_dac02_char_data(:,1), onchip_dac02_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=3;
//plot2d("nn", onchip_dac03_char_data(:,1), onchip_dac03_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=5;
//plot2d("nn", onchip_dac04_char_data(:,1), onchip_dac04_char_data(:,2));p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=6;
//plot2d("nn", onchip_dac05_char_data(:,1), onchip_dac05_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=1;
//plot2d("nn", onchip_dac06_char_data(:,1), onchip_dac06_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=2;
//plot2d("nn", onchip_dac07_char_data(:,1), onchip_dac07_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=3;
//plot2d("nn", onchip_dac08_char_data(:,1), onchip_dac08_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=5;
//plot2d("nn", onchip_dac09_char_data(:,1), onchip_dac09_char_data(:,2));p = get("hdl"); p.children.mark_style = 2; p.children.thickness = 3; p.children.line_mode="off";p.children.mark_foreground=6;
//plot2d("nn", DAC00_HEX_range, DAC00_fit, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", DAC01_HEX_range, DAC01_fit, style=2);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", DAC02_HEX_range, DAC02_fit, style=3);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", DAC03_HEX_range, DAC03_fit, style=5);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", DAC04_HEX_range, DAC04_fit, style=6);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", DAC05_HEX_range, DAC05_fit, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", DAC06_HEX_range, DAC06_fit, style=2);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", DAC07_HEX_range, DAC07_fit, style=3);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", DAC08_HEX_range, DAC08_fit, style=5);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//plot2d("nn", DAC09_HEX_range, DAC09_fit, style=6);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//a=gca();a.data_bounds=[0 0; 150 2.6];
//legend("DAC00","DAC01","DAC02","DAC03","DAC04","DAC05","DAC06","DAC07","DAC08","DAC09","in_upper_right");
//xtitle("","ADC code","Vg (V)");
