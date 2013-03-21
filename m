From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Thu, 21 Mar 2013 13:15:56 -0400
Message-ID: <20130321171556.GM3934@redhat.com>
References: <1363806968.2580.86.camel@falcor1.watson.ibm.com>
 <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
 <1363813877.2580.120.camel@falcor1.watson.ibm.com>
 <1363814289.2553.41.camel@x230.sbx07502.somerma.wayport.net>
 <20130321134348.GA3934@redhat.com>
 <20130321153725.GA3656@austin.hallyn.com>
 <20130321155220.GL3934@redhat.com>
 <20130321155823.GA4438@austin.hallyn.com>
 <20130321160441.GB6575@redhat.com>
 <20130321161952.GA4957@austin.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130321161952.GA4957-anj0Drq5vpzx6HRWoRZK3AC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 21, 2013 at 11:19:52AM -0500, Serge E. Hallyn wrote:

[..]
> > I am hoping I did not miss your point entirely.
> 
> No, you didn't.  If replay attacks are not a concern then that bit
> doesn't matter.  But if^Wwhen there is a vulnerability in a signed kernel,
> and a user has a copy of bzImage sitting around, signed kexec alone does
> not suffice (and I'm assuming revocation is not going into the kernel?).
> It seems to me if replay attacks are ignored, this is all for theater...
> 

As matthew mentioned, revocation list is in kernel. So old vulnerable
kernels should fail signature verification.

> The other concern is analogous, just more general - seems like I may very
> well be able to find a way to corrupt kexec or even corrupt the kernel with
> a bad environment.
> 
> So I'm just saying that in general it doesn't seem worth having a special
> list of capabilities that only signed executables can have, without doing 
> something about the environment.

Agreed that only being signed is part of the problem. Environment is
important too. And running signed binaries memory locked is I think
one part of controlling the environment. But there might be other
things too which I am blissfully unaware of.

Right now there were few things we were considering for controlling
the environemnt.

- Build /sbin/kexec statically and sign only statically linked exeutables.
- Run executables memory locked
- Unsigned binary can not ptrace() signed one.

> And that the solution to that seems like
> what we can already do today (with a bounding set and init-launched
> services).

Frankly speaking I did not understand this part. For secureboot issue
we don't trust root and don't trust init. I am assuming any restricted
environment setup will have to be done by a trusted entity.
 
> 
> All of this is probably premature though.  IIUC the first thing you are
> after is a way to record on the file the fact that it is a verified-signature
> binary, and that's what CAP_SIGNED meant right?

Yes, that was the first thing. How to reliably sign and verify signature
of a executable. Also make sure executable code/data can not modified
in memory later by anything untrusted.

>   I agree we need something
> like that, but using a capability is not right.  You can add a field to
> the binprm or file or f_cred, or even add a field to the capability struct,
> meaningful only on files, to show it was signed - but not taint the list of
> capabilities with something that is not a capability. 

Ok, I will look into other options too. Agreed being signed is not a
capability. But being signed along with other attributes should allow to 
get one a capability (CAP_MODIFY_KERNEL in this case). I am not sure why
nobody likes that idea. But that's fine, I will go with advice of subject
matter experts.

> I haven't looked
> closer to see which would be the best way (my hunch would be binprm), will 
> be happy to come up with a proposal when I have time, but I don't want to slow
> you down :)

Any suggetions are greatly appreciated whenever time permits. In the mean
time I will atleast write more code and post it for RFC and hopefully
there will be some consensus on how to solve kexec issue.

Thanks
Vivek
