From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efibc: avoid stack overflow warning
Date: Sat, 30 Apr 2016 23:46:41 +0100
Message-ID: <20160430224641.GQ2839@codeblueprint.co.uk>
References: <1461952128-2135409-1-git-send-email-arnd@arndb.de>
 <20160430201449.GL2839@codeblueprint.co.uk>
 <18565207.dPI1UNgYiO@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <18565207.dPI1UNgYiO@wuerfel>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, 01 May, at 12:34:29AM, Arnd Bergmann wrote:
> 
> The sys_restart() system call takes a mutex before calling kernel_restart()
> or kernel_poweroff().
> 
> I've had a closer look now and found that there are a few other
> callers of kernel_restart, so I guess if you restart using sysctl
> at the exact same time as calling /sbin/reboot, things may break.
 
Right. Or if the dm-verify-target driver saw an error.

> It's not something we'd have to worry about in practice, but it does
> make my patch incorrect. Should we come up with a different way to
> do it?

Jeremy proposed a patch to dynamically allocate the memory, which I
think is the correct way to go given that our (reasonable) assumptions
about reboot notifier concurrency are not guaranteed,

  https://lkml.kernel.org/r/87h9eked24.fsf-e2kLcBBGnpIIbNWpFUBdLQzuBQEzu/OPQQ4Iyu8u01E@public.gmane.org
