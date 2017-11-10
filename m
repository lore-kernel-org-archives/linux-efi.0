From: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 26/30] Lock down ftrace
Date: Fri, 10 Nov 2017 10:23:19 +0100 (CET)
Message-ID: <alpine.LRH.2.00.1711101021440.24296@gjva.wvxbf.pm>
References: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk> <151024883613.28329.14808632296386937974.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <151024883613.28329.14808632296386937974.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 9 Nov 2017, David Howells wrote:

> Disallow the use of ftrace when the kernel is locked down.  This patch
> turns off ftrace_enabled late in the kernel boot so that the selftest can
> still be potentially be run.
> 
> The sysctl that controls ftrace_enables is also disallowed when the kernel
> is locked down.  If the lockdown is lifted, then the sysctl can be used to
> reenable ftrace - if ftrace was compiled with CONFIG_DYNAMIC_FTRACE, that
> is; if it wasn't then it won't be possible to reenable it.
> 
> This prevents crypto data theft by analysis of execution patterns, and, if
> in future ftrace also logs the register contents at the time, will prevent
> data theft by that mechanism also.

I fail to see how this fits into the secure boot security model, could you 
please explain?

Secure boot is about having a constant proof / verification that the code 
you're running in ring0 can be trusted (IOW is the one that has been 
signed and verified by the whole boot chain).

Checking execution patterns doesn't seem to fit at all.

Thanks,

-- 
Jiri Kosina
SUSE Labs
