global file_name path fname extension chip_num board_num brdtype b_elements

brd_sz=[];


function Board_settings()
    global board_num brdtype handles;

    Choose_Board3= findobj('tag','Choose_Board3'); 
    if (board_num == 2) then
        brdtype = '';
        brd_sz.cab=7;
        brd_sz.clb=7;
        brd_sz.tot=14;
        brd_sz.len=14;
    elseif (board_num == 3) then
        brdtype = '_30a';
        brd_sz.cab=4;
        brd_sz.clb=3;
        brd_sz.tot=7;
        brd_sz.len=14;
    elseif (board_num == 4) then
        board_num=4;
        brdtype = '_30n';
    elseif (board_num == 5) then
        board_num=5;
        brdtype = '_30h';
    else

    end
    brd_sz=return(brd_sz)
endfunction


function Design_Metrics()
    global file_name path fname extension b_elements

    AreaSi_val = findobj('tag','AreaSi_val');
    AreaTile_val1 = findobj('tag','AreaTile_val1');
    AreaTile_val2 = findobj('tag','AreaTile_val2'); 
    Eota_val = findobj('tag','Eota_val');
    Efgota_val = findobj('tag','Efgota_val');
    Ecap_val = findobj('tag','Ecap_val');
    Enfet_val = findobj('tag','Enfet_val');
    Epfet_val = findobj('tag','Epfet_val');
    Etgate_val = findobj('tag','Etgate_val');
    Enmirror_val = findobj('tag','Enmirror_val');
    Eble_val = findobj('tag','Eble_val');
    Efg_val = findobj('tag','Efg_val');
    ctiles_sep = [];
    ctiles_num = [];
    b_ele_sep = [];
    Tile_val1 = %f;
    Tile_val2 = %f;

    Power_val = findobj('tag','Power_val');
    Power_val.string = string(msprintf('%.2e', b_elements.b_ibias*2.5))

    b_ele= unix_g('grep -o '"mode=\'"ble'" ' + path + '.' + fname + '/' + fname + '.net' +' | grep -o '"ble'" | sort | uniq -c | sed -e ''s/^[ \t]*//''');
    b_ele_sep=strsplit(b_ele, ' ')'; 
    b_ble=strtod(b_ele_sep(1,1));

    fg_val = size(csvRead(path+fname+'.swcs',',' ,'.' , 'string'),1)/359014;

    btot= b_elements.b_ota + b_elements.b_fgota + b_elements.b_nfet + b_elements.b_pfet + b_elements.b_cap + b_elements.b_tgate + b_elements.b_nmirror + b_elements.b_ble;
    //2 otas 2 fgotas 2 nfets 2 pfets 4 caps 4 tgates 2 nmirrors 8 bles
    etot = btot/(([2+2+2+2+4+4+2]*brd_sz.cab + [8]*brd_sz.clb)*brd_sz.len);
    if (etot)*100 <= 0.99 then
        AreaSi_val.string=string(msprintf('%.2f', (etot)*100))
    else
        AreaSi_val.string=string(msprintf('%.f', (etot)*100))
    end


    ctiles = unix_g('grep -o '"mode=\'"c.*'"[^\'"\>] ' + path + '.' + fname + '/' + fname + '.net' +' | grep -o '"c[a\|l]b'" | sort | uniq -c | sed -e ''s/^[ \t]*//''');
    ctiles_sz=size(ctiles,1);
    for i=1:ctiles_sz 
        ctiles_sep(i,:)=strsplit(ctiles(i), ' ')'; 
        ctiles_num=ctiles_num+strtod(ctiles_sep(i,1));
        if ctiles_sep(i,2) == 'cab' then
            AreaTile_val1.string=string(msprintf('%.f', (strtod(ctiles_sep(i,1))/(brd_sz.cab*brd_sz.len))*100))
            Tile_val1 = %t;
        else
            AreaTile_val2.string=string(msprintf('%.f', (strtod(ctiles_sep(i,1))/(brd_sz.clb*brd_sz.len))*100));
            Tile_val2 = %t;
        end
    end

    if Tile_val1 == %f then
        AreaTile_val1.string = '0';
    end

    if Tile_val2 == %f then
        AreaTile_val2.string = '0';
    end

    Eota_val.string = string(b_elements.b_ota);
    Efgota_val.string = string(b_elements.b_fgota); 
    Ecap_val.string = string(b_elements.b_cap); 
    Enfet_val.string = string(b_elements.b_nfet); 
    Epfet_val.string = string(b_elements.b_pfet); 
    Etgate_val.string = string(b_elements.b_tgate); 
    Enmirror_val.string = string(b_elements.b_nmirror); 

    if isnan(b_ble) == %f then
        b_elements.b_ble = b_ble;
    end
    Eble_val.string = string(b_elements.b_ble);

    if fg_val <= 0.99 then
        Efg_val.string = string(msprintf('%.2f',fg_val));
    else
        Efg_val.string = string(msprintf('%.f',fg_val));
    end

endfunction
