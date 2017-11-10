From: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 26/30] Lock down ftrace
Date: Fri, 10 Nov 2017 11:15:56 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1711101114410.32604@cbobk.fhfr.pm>
References: <alpine.LRH.2.00.1711101021440.24296@gjva.wvxbf.pm> <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk> <151024883613.28329.14808632296386937974.stgit@warthog.procyon.org.uk> <27323.1510308432@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <27323.1510308432-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Nov 2017, David Howells wrote:

> > I fail to see how this fits into the secure boot security model, could you 
> > please explain?
> 
> The idea is to prevent cryptographic data for filesystems and other things
> from being read out of the kernel memory as well as to prevent unauthorised
> modification of kernel memory.

Then it would make sense to actually lock down dumping of registers / 
function arguments (kprobes can currently do that, ftrace eventually could 
as well I guess), but disabling the whole ftrace altogether seems like a 
totally unnecessary overkill.

> > Secure boot is about having a constant proof / verification that the code 
> > you're running in ring0 can be trusted (IOW is the one that has been 
> > signed and verified by the whole boot chain).
> > 
> > Checking execution patterns doesn't seem to fit at all.
> 
> I'll defer this question to Alexei since he suggested I needed to deal 
> with this too.

Thanks.

-- 
Jiri Kosina
SUSE Labs
