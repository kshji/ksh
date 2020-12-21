# Mutt - Send email using smtp server ex. Gmail or Office365 #

In commandline you can use mail, sendmail, ... to send emails.

[Mutt](http://www.mutt.org/) include also easy way to use attachments, smtp authentication including Oauth2.

I have done as so many others: kill my own MTA and moved to use Gmail, Office 365 , ...

Some of my software send sometimes emails. I have used own MTA, operator MTA, ...

Today it's safety, secure, less spam, ... to use service provider like Google,  Microsoft, ...

SMTP sending using account is easy method, but the authentication to the smtp servers is not anymore only some easy basic auth. Need something more: app password, OAuth2, ...

Gmail and O365 support application password and OAuth2.  

When you use 2FA in your account, you need application password or OAuth2 authentication.

I have tested application password. It's "shared" password for application, user can't use this ex. to login.

## Mutt ##

Ubuntu/Debian install:

```sh
apt-get install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules
# need using Oauth2
apt-get instgall gpg
# mutt
apt-get install mutt
```

Mutt config default is $HOME/.muttrc file.

You can make own rc file for some service and use it using option -F rcfile

### Using mutt ###

```sh
# basic send email using environment mail setup (MTA), message is in the file message.txt
mutt -s "Test some message" some.person@gmail.com <<EOF

$(cat message.txt)

EOF
```

```sh
# send using Gmail smtp server
# using ex. some rcfile gmail.muttrc  Att: my example gmail.muttrc include env variables, need to setup those before using
mutt -F gmail.muttrc -s "Sub using Gmail" -b "some.bcc@domain.some" some.person@gmail.com <<EOF

$(cat message.txt)

EOF
```

```sh
# send using Gmail smtp server with attachments
mutt -F gmail.muttrc -s "Sub using Gmail" -b "some.bcc@domain.some" some.person@gmail.com -a example1.pdf -a example2.pdf <<EOF

$(cat message.txt)

EOF
```

## Setup Application Password ##

### Google Gmail ###
 * [Login MyAccount](https://myaccount.google.com/)
 * Left menu Security
 * [Application password](https://myaccount.google.com/apppasswords)
 ** Select application Email
 ** Give some name for this application ex. linux_email or mutt or ...
 ** save the app passwordstring

### Microsoft Office 365 ###
 * [MyAccount](https://mysignins.microsoft.com/security-info)
 ** admin need force  to you add other methods as 2FA: application password
 *** [User Management](https://accounts.activedirectory.windowsazure.com)
 *** service settings "tab"
 **** allow users to create app passwords to sign in to non-browser apps
 ** after that you can add method "application password"  [MyAccount] (https://myaccount.google.com/)
 ** give some label for this password ex. smtp_mutt
 ** save the app passwordstring

## sendemail.sh ##
 * use *mutt* command
 * in basic smtp auth method sendemail.sh ask user password, if not set environment variable SMTPAUTHPASS


```sh
# send mail using Gmail
# template muttrc gmail.muttrc has done using variables which sendemail.sh expand.
# you can putt fixed variables to the template and use directly muu command 

# using Gmail account and smtp
# - muttrc, look realname. Gmail accept to change it
sendemail.sh -D gmail.com -u my.account@gmail.com -r gmail.muttrc -t to.some@example.com -s "Subject Gmail $(date)" -m message.txt -f from my.email@gmail.com  -p my_appgmail_password -a example1.pdf -a example2.pdf 

# using Office 365 account and smtp
# - muttrc, look realname. Office 365 not accept to change it, use always account Realname
# - muttrc, look from. Office 365 accept to change it, but have to be one of the aliases email which you have setup for account
sendemail.sh -D some.com -u my.account@some.com -r o365app.muttrc -t to.some@gmail.com -s "Subject O365 $(date)" -m message.txt -f from my.alias@some.com  -p my_appo365_password -a example1.pdf -a example2.pdf 
	
```


