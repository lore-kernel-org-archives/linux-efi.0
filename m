From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Tue, 06 Nov 2012 08:56:01 +0100
Message-ID: <878vafqi5q.fsf@mid.deneb.enyo.de>
References: <20121104135251.GA17894@srcf.ucam.org>
	<87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com>
	<87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org>
	<87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org>
	<87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org>
	<87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org>
	<87hap3s3yl.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <87hap3s3yl.fsf@xmission.com> (Eric W. Biederman's message of
	"Mon, 05 Nov 2012 21:19:46 -0800")
Sender: linux-security-module-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

* Eric W. Biederman:

> If windows is not present on a system linux can not be used to boot a
> compromised version of windows without user knowledge because windows is
> not present.

Interesting idea.  Unfortunately, it is very hard to detect reliably
that Windows is not present from the bootloader, so it's not possible
to use this approach to simplify matters.

> If windows is present on a system then to install linux a user must be
> present and push buttons to get the system to boot off of install media.

That's not necessarily true.

> If a user is present a user presence test may be used to prevent a
> bootloader signed with  Microsoft's key from booting linux without the
> users consent, and thus prevent Linux from attacking windows users.

As already explained, I don't think that user presence accomplishes
anything.  You need informed consent, and it's impossible to cram that
on a 80x25 screen.  You also need to make sure that you aren't
unnecessarily alarmist.  We don't want a "Linux may harm your
computer" warning.

> Therefore preventing the revokation of a signature with Microsoft's
> signature from your bootloader does not justify elaborate kernel
> modifications to prevent the booting a compromised version of windows.

I don't like this approach, either.

> Furthermore no matter how hard we try with current techniques there will
> eventually be kernel bugs that allow attackers to inject code into the
> kernel.  So attempting to fully close that attack vector is
> questionable.

I suspect we'd need to revoke old binaries after a grace period.  I
guess the Microsoft approach is to revoke only what's actually used
for attacks, but that leads to a lot of unpredictability for our
users.

It's also annoying if we figure out after release that we have to
disable additional kernel functionality because it can be used to
compromise the boot path.  Users will not like that, especially if
they do not use Windows at all.

Personally, I think the only way out of this mess is to teach users
how to disable Secure Boot.
