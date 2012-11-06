From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Mon, 05 Nov 2012 18:46:32 -0800
Message-ID: <87hap3zbw7.fsf@xmission.com>
References: <20121103134630.GA28166@srcf.ucam.org>
	<1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
	<20121104042802.GA11295@srcf.ucam.org>
	<1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
	<20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com>
	<509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com>
	<20121105123858.GB4374@srcf.ucam.org> <87sj8nc137.fsf@xmission.com>
	<20121105202557.GA16076@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20121105202557.GA16076@srcf.ucam.org> (Matthew Garrett's message
	of "Mon, 5 Nov 2012 20:25:57 +0000")
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Mon, Nov 05, 2012 at 11:16:12AM -0800, Eric W. Biederman wrote:
>> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>> > No, in the general case the system will do that once it fails to find a 
>> > bootable OS on the drive.
>> 
>> In the general case there will be a bootable OS on the drive.
>
> That's in no way a given.

You have it backwards.  The conclusion here is that having a case where
a non-interactive install is possible is not a given.

Therefore inflicting the entire rest of the ecosystem with requirements
that only exist in the union of the requirements for non-interactive
installs and installs on a machine with an existing machine does not
make sense.

In situations where a non-interactive install is interesting.  Aka
an empty boot disk it is not interesting to guard against.

In situations where interaction happens is where windows may already exists
and so spoofing windows is a design consideration and and a user
presence test does not break the design.

Eric
