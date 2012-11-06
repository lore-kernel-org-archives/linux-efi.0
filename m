From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Mon, 05 Nov 2012 21:19:46 -0800
Message-ID: <87hap3s3yl.fsf@xmission.com>
References: <20121104135251.GA17894@srcf.ucam.org>
	<87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com>
	<87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org>
	<87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org>
	<87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org>
	<87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121106035352.GA24698-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> (Matthew Garrett's message
	of "Tue, 6 Nov 2012 03:53:52 +0000")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> writes:

> On Mon, Nov 05, 2012 at 07:36:32PM -0800, Eric W. Biederman wrote:
>
>> For automated installs you don't have to satisfy me.  Feel free to
>> deliver a lousy solution to your users.   Just don't use your arbitrary
>> design decisions to justify your kernel patches.
>
> My kernel patches are justified by genuine user requirements. 

Hogwash.

If windows is not present on a system linux can not be used to boot a
compromised version of windows without user knowledge because windows is
not present.

If windows is present on a system then to install linux a user must be
present and push buttons to get the system to boot off of install media.

If a user is present a user presence test may be used to prevent a
bootloader signed with  Microsoft's key from booting linux without the
users consent, and thus prevent Linux from attacking windows users.

Therefore preventing the revokation of a signature with Microsoft's
signature from your bootloader does not justify elaborate kernel
modifications to prevent the booting a compromised version of windows.

Furthermore no matter how hard we try with current techniques there will
eventually be kernel bugs that allow attackers to inject code into the
kernel.  So attempting to fully close that attack vector is
questionable.

> If you 
> don't feel that there's any requirement for the kernel to satisfy the 
> people who use it, you're free to ignore those patches.

I feel allowing the kernel to be hacked to bits and decend into an
unmaintainable mess does not serve the users who use the kernel,
and to prevent that technically poor patches should be rejected.

This helps prevent non-technical considerations from justifying
technically poor decisions.

Eric
