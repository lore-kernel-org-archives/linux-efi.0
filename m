From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] efibc: avoid stack overflow warning
Date: Sun, 01 May 2016 00:34:29 +0200
Message-ID: <18565207.dPI1UNgYiO@wuerfel>
References: <1461952128-2135409-1-git-send-email-arnd@arndb.de> <20160430201449.GL2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160430201449.GL2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Saturday 30 April 2016 21:14:49 Matt Fleming wrote:
> On Fri, 29 Apr, at 07:48:31PM, Arnd Bergmann wrote:
> > gcc complains about a newly added file for the EFI Bootloader Control:
> > 
> > drivers/firmware/efi/efibc.c: In function 'efibc_set_variable':
> > drivers/firmware/efi/efibc.c:53:1: error: the frame size of 2272 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> > 
> > The problem is the declaration of a local variable of type
> > struct efivar_entry, which is by itself larger than the warning
> > limit of 1024 bytes.
> > 
> > We know that the reboot notifiers are not called from a deep stack,
> > so this is not an actual bug, but we should still try to rework
> > the code to avoid the warning. We also know that reboot notifiers
> > are never run concurrently on multiple CPUs, so there is no problem
> > in just making the variable 'static'.
>  
> I assumed reboot notifiers were guaranteed to be non-concurrent too
> but having dug into the callers of kernel_reboot(), I couldn't find
> any kind of mutual exclusion.
> 
> How/where is this guaranteed?

The sys_restart() system call takes a mutex before calling kernel_restart()
or kernel_poweroff().

I've had a closer look now and found that there are a few other
callers of kernel_restart, so I guess if you restart using sysctl
at the exact same time as calling /sbin/reboot, things may break.

It's not something we'd have to worry about in practice, but it does
make my patch incorrect. Should we come up with a different way to
do it?

	Arnd
