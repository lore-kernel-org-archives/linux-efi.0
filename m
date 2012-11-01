From: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 01 Nov 2012 11:12:55 +0100
Message-ID: <1904191.8HVCpRFbLH@linux-lqwf.site>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <36538307.gzWq1oO7Kg@linux-lqwf.site> <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351760905.2391.19.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thursday 01 November 2012 09:08:25 James Bottomley wrote:
> On Wed, 2012-10-31 at 23:19 +0100, Oliver Neukum wrote:
> > On Wednesday 31 October 2012 15:58:05 Chris Friesen wrote:
> > > On 10/31/2012 02:14 PM, Oliver Neukum wrote:
> > 
> > > > That would do it on my system.
> > > > Maybe in theory you could solve this by the kernel invalidating images
> > > > it hasn't written itself and forbidding to change the resume partition from the
> > > > kernel command line, but that would break user space hibernation.
> > > 
> > > If the resuming kernel refuses to resume from images it didn't create 
> > > itself, why do you need to forbid changing the resume partition from the 
> > > kernel command line?
> > 
> > You don't. Signed images solve the problem.
> 
> I really don't think they do.  The proposed attack vector is to try to
> prevent a local root exploit from running arbitrary in-kernel code,
> because that would compromise the secure boot part of the kernel.

Well, it is an attempt to prevent unsigned code from altering signed
code or data structures private to signed code. That can be seen as
a technical question. What that is useful for is not strictly a technical
question.

We can of course discuss whether secure boot makes sense at all.
But that is a different discussion. Once it is decided that it is to be
implemented, some issues arise logically.

> The point I'm making is that given that the majority of exploits will
> already be able to execute arbitrary code in-kernel, there's not much
> point trying to consider features like this as attacker prevention.  We
> should really be focusing on discussing why we'd want to prevent a
> legitimate local root from writing to the suspend partition in a secure
> boot environment.

That is strictly speaking what we are discussing.
First, it is not given that root is local.
Second, we don't want to stop root from writing to a partition.
We just want to prevent that from altering kernel memory.

	Regards
		Oliver
