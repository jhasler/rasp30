# Import Statements
import zipfile, os, sys
import poplib, getpass, email, smtplib
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email import encoders

# Email Account Details
#u = 'fpaabot.dev1@yahoo.com'
#u = 'fpaabot.dev1@gmail.com'
#up = 'cadsp_fpaa'

# Process Command Line Arguments
# First argument is file folder name
# Second argument is user's email address
if (len(sys.argv) == 5):
    users_email = str(sys.argv[1])
    file_name = str(sys.argv[2])
    send_email_id = str(sys.argv[3])
    send_email_pw = str(sys.argv[4])
    print(users_email)
    print(file_name)
    print(send_email_id)
    print(send_email_pw)
else:
    sys.exit("user email not provided")

u = send_email_id
up = send_email_pw
zip_name = file_name+'.zip'
# Change zip file extension name ...
new_name = file_name +".cadsp"
os.renames(zip_name, new_name)

# Compose email ...
fromaddr = send_email_id
#fromaddr = "fpaabot.dev1@yahoo.com"
#fromaddr = "fpaabot.dev1@gmail.com"
toaddr = "fpaabot.dev2@gmail.com"
msg = MIMEMultipart()
msg['From'] = fromaddr
msg['To'] = toaddr
msg['Subject'] = users_email
body = "Don't need to put anything in here yet"
msg.attach(MIMEText(body, 'plain'))
"""part = MIMEBase('application', "octet-stream")
        part.set_payload( open(new_name,"rb").read() )
        Encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(f))
        msg.attach(part)"""
try:
    part = MIMEBase('application', "octet-stream")
    part.set_payload( open(new_name,"rb").read() )
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(new_name))
    msg.attach(part)
except:
    print ('Failed to attach zipped file!')

# Send email ...
#s = smtplib.SMTP('smtp.mail.yahoo.com', 587)
s = smtplib.SMTP('smtp.gmail.com', 587)
s.ehlo()
s.starttls()
s.login(u, up)
s.sendmail(fromaddr, toaddr, msg.as_string())
s.quit()

# Deleting created files
os.remove(new_name)
