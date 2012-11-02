From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 02 Nov 2012 01:49:25 -0700
Message-ID: <87625ogzje.fsf@xmission.com>
References: <CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
	<1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
	<CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
	<1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
	<20121101210634.GA19723@srcf.ucam.org>
	<20121101213127.5967327f@pyramind.ukuu.org.uk>
	<20121101212843.GA20309@srcf.ucam.org>
	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>
	<20121101213452.GA20564@srcf.ucam.org>
	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>
	<20121101215752.GA21154@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121101215752.GA21154-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> (Matthew Garrett's message
	of "Thu, 1 Nov 2012 21:57:52 +0000")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> writes:

> On Thu, Nov 01, 2012 at 09:58:17PM +0000, Alan Cox wrote:
>> On Thu, 1 Nov 2012 21:34:52 +0000
>> Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:
>> > I think you've misunderstood. Blacklist updates are append only.
>> 
>> I think you've misunderstood - thats a technical detail that merely
>> alters the cost to the people who did something improper.
>
> Winning a case is cold comfort if your software has been uninstallable 
> for the years it took to get through the courts. If others want to take 
> that risk, fine.

When the goal is to secure Linux I don't see how any of this helps.
Windows 8 compromises are already available so if we turn most of these
arguments around I am certain clever attackers can go through windows to
run compromised kernel on a linux system, at least as easily as the
reverse.

Short of instructing UEFI to stop trusting the Microsoft signing key I
don't see any of the secureboot dance gaining any security of computers
running linux or security from keys being revoked for non-sense reasons.

Eric
