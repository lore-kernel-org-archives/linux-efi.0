From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Sun, 04 Nov 2012 23:24:17 -0800
Message-ID: <87625kh5r2.fsf@xmission.com>
References: <20121102175416.GA11816@srcf.ucam.org>
	<1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
	<20121102180458.GA12052@srcf.ucam.org>
	<1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
	<20121103002244.GC18691@srcf.ucam.org>
	<1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
	<20121103134630.GA28166@srcf.ucam.org>
	<1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
	<20121104042802.GA11295@srcf.ucam.org>
	<1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
	<20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com>
	<509766DB.9090906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <509766DB.9090906-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> (H. Peter Anvin's message of "Mon,
	05 Nov 2012 08:12:27 +0100")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> writes:

> On 11/05/2012 07:14 AM, Eric W. Biederman wrote:
>> 
>> In any case the notion that unattended install with no user interaction
>> on any uefi machine in any state is complete and total rubbish.  It
>> can't be done.  You need power and you need boot media.
>> 
>
> That is a hugely different thing from needing a console.

Not at all.

In the general case user intereaction is required to tell the system to
boot off of your choosen boot media instead of the local hard drive.

Eric
