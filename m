From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 26/30] Lock down ftrace
Date: Fri, 10 Nov 2017 10:21:44 +0000
Message-ID: <27646.1510309304@warthog.procyon.org.uk>
References: <nycvar.YFH.7.76.1711101114410.32604@cbobk.fhfr.pm> <alpine.LRH.2.00.1711101021440.24296@gjva.wvxbf.pm> <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk> <151024883613.28329.14808632296386937974.stgit@warthog.procyon.org.uk> <27323.1510308432@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <nycvar.YFH.7.76.1711101114410.32604-YHPUNQjx9ReKbouaWp301Q@public.gmane.org>
Content-ID: <27645.1510309304.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> > The idea is to prevent cryptographic data for filesystems and other things
> > from being read out of the kernel memory as well as to prevent unauthorised
> > modification of kernel memory.
> 
> Then it would make sense to actually lock down dumping of registers / 
> function arguments (kprobes can currently do that, ftrace eventually could 
> as well I guess), but disabling the whole ftrace altogether seems like a 
> totally unnecessary overkill.

That would be fine by me.  I have a patch that locks down kprobes in this
series.  Steven says that ftrace might acquire the ability to dump registers
in the future.

David
