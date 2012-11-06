From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Mon, 05 Nov 2012 19:36:32 -0800
Message-ID: <87fw4nv1vj.fsf@xmission.com>
References: <20121104042802.GA11295@srcf.ucam.org>
	<1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
	<20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com>
	<509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com>
	<20121105123858.GB4374@srcf.ucam.org> <87sj8nc137.fsf@xmission.com>
	<20121105202557.GA16076@srcf.ucam.org> <87hap3zbw7.fsf@xmission.com>
	<20121106031219.GB24235@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121106031219.GB24235@srcf.ucam.org> (Matthew Garrett's message
	of "Tue, 6 Nov 2012 03:12:19 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Mon, Nov 05, 2012 at 06:46:32PM -0800, Eric W. Biederman wrote:
>> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>> 
>> > On Mon, Nov 05, 2012 at 11:16:12AM -0800, Eric W. Biederman wrote:
>> >> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>> >> > No, in the general case the system will do that once it fails to find a 
>> >> > bootable OS on the drive.
>> >> 
>> >> In the general case there will be a bootable OS on the drive.
>> >
>> > That's in no way a given.
>> 
>> You have it backwards.  The conclusion here is that having a case where
>> a non-interactive install is possible is not a given.
>
> I deal with customers who perform non-interactive installs. The fact 
> that you don't care about that use case is entirely irrelevant to me, 
> because you're not the person that I am obliged to satisfy.

I have spent what feels like half my life doing automatic installs.  I
care a lot and I understand the requirements.  I also see through
misstatements about reality used to justify stupid design decisions.

For automated installs you don't have to satisfy me.  Feel free to
deliver a lousy solution to your users.   Just don't use your arbitrary
design decisions to justify your kernel patches.

Non-interactive installs do not justify removing all trust from the root
user of a system, disabling suspend to disk and completely rewriting
kexec for the simple expedient removing a couple of lines of code from
your bootloader.

Eric
