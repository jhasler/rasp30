# Import Statements
import zipfile, os, sys
import poplib, getpass, email, smtplib
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email import encoders

# Email Account Details
u = 'fpaabot.dev1@gmail.com'
up = 'cadsp_fpaa'

# Process Command Line Arguments
if (len(sys.argv) == 3):
    users_email = str(sys.argv[1])
    file_name = str(sys.argv[2])
    print(users_email)
    print(file_name)
else:
    sys.exit("user email or results file not provided")

# Compose email ...
fromaddr = "fpaabot.dev@gmail.com"
toaddr = users_email
msg = MIMEMultipart()
msg['From'] = fromaddr
msg['To'] = toaddr


try:
    f1_watch='WATCHDOG.txt'
    FILE=open(f1_watch,'r')
    if FILE.read()=='1':
       print('I am inside watchdog area')
       msg['Subject'] = "Run time execution over 3 minutes"
       body = "You just put the remote system in a loop!!!It had to reset itself.\nFor Debugging:\nIf you are using a long input vector, for now the remote system is constrained to 500 points.\nCheck if you are using the right chip num(01 and 13) and board num(3.0).\nIf you are using RAMP ADC its input voltage range is 0.2 to 1.8 Volts.\nOther things hmm. Maybe check the sampling rate of the DAC and the ADC. Sampling rate is the time between two point. So if Sampling rate is 200 Hz then it will wait for 5ms to measure each point."
    else:
       msg['Subject'] = "Results"
       body = "."
    FILE.close()   
except:
	msg['Subject'] = "Results"
	body = "."   



msg.attach(MIMEText(body, 'plain'))
try:
    part = MIMEBase('application', "octet-stream")
    part.set_payload( open(file_name,"rb").read() )
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(file_name))
    msg.attach(part)
except:
    print ('Failed to attach zipped file!')

# Send email ...
s = smtplib.SMTP('smtp.gmail.com', 587)
s.ehlo()
s.starttls()
s.login(u, up)
s.sendmail(fromaddr, toaddr, msg.as_string())
s.quit()
