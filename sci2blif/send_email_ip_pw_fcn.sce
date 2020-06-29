global email_id_string email_pw_string chip_num email_name fname board_num;

//////////
// Callbacks are defined as below.
//////////
function email_id_callback(handles)
    global email_id_string;
    email_id = findobj('tag','email_id');
    email_id_string = email_id.string;
endfunction

function email_pw_callback(handles)
    global email_pw_string;
    email_pw = findobj('tag','email_pw');
    email_pw_string = email_pw.string;
endfunction

function id_pw_send_email(handles)
    if chip_num=='13'&board_num==2 then
        unix_s('python /home/ubuntu/rasp30/remote_server/send_email.py '+ email_name + ' ' + fname + ' ' + email_id_string + ' ' + email_pw_string);
        disp("Email Sent!");
    elseif chip_num=='01'&board_num==2 then
        unix_s('python /home/ubuntu/rasp30/remote_server/send_email01.py '+ email_name + ' ' + fname + ' ' + email_id_string + ' ' + email_pw_string);
        disp("Email Sent_01!");
    elseif chip_num=='04'&board_num==3 then
        unix_s('python /home/ubuntu/rasp30/remote_server/send_email02.py '+ email_name + ' ' + fname + ' ' + email_id_string + ' ' + email_pw_string);
        disp("Email Sent_02!");
    else 
         disp('Please use chip 13 and chip 01 with board setting at 3.0.')    
    end
    messagebox(["Close Send Email ID & PW"],"Close the box" , "info", "modal");
    disp('EMAIL NAME: ' + email_name);
    disp('FNAME: ' + fname);
    disp("You will receive an email with your data in a file. Please save that file in the same directory as your design.");
endfunction
