#!/usr/bin/perl -wT
#SMS alerting application


use strict;

use Mail::Sender;

sub makealert();


while(my $read = <>)
{
	if ($read =~ /Subject: Value Too High - Error - Temperature/)
	{
		makealert();
		exit 0;
	}
}

exit 0;

sub makealert()
{
	my $temp = "unknown"; #Actually not a temporary variable
	while (my $read = <>)
	{
		if ($read =~ m!Sensor Value:</td><td>\s*(\d+\.\d*)! )
		{
			$temp = $1;
			last;
		}
	}
		 
	my $alerttext=<<ENDALERT;
user:username
password:password
api_id:apikey
to:phonenumber
reply:jsmall\@email.com
text: Temperature Alert, currently $temp
ENDALERT


	my $sender = new Mail::Sender {
		smtp => '127.0.0.1',
		from => 'technion@lolware.net',
		on_errors => 'code',
	};
	die "Can't create the Mail::Sender object: $Mail::Sender::Error\n"
		unless ref $sender;

	if ($sender->MailMsg({
	   to =>'jsmall@email.com,sms@messaging.clickatell.com',
	   subject => 'Netbotz Alert',
	   msg => $alerttext
	 }) < 0) {
	  die "$Mail::Sender::Error\n";
	 }
}
