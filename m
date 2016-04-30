From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] efibc: avoid stack overflow warning
Date: Sun, 01 May 2016 01:25:12 +0200
Message-ID: <2137916.p0oDBh93bk@wuerfel>
References: <1461952128-2135409-1-git-send-email-arnd@arndb.de> <18565207.dPI1UNgYiO@wuerfel> <20160430224641.GQ2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160430224641.GQ2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Saturday 30 April 2016 23:46:41 Matt Fleming wrote:
> 
> > It's not something we'd have to worry about in practice, but it does
> > make my patch incorrect. Should we come up with a different way to
> > do it?
> 
> Jeremy proposed a patch to dynamically allocate the memory, which I
> think is the correct way to go given that our (reasonable) assumptions
> about reboot notifier concurrency are not guaranteed,
> 
>   https://lkml.kernel.org/r/87h9eked24.fsf-e2kLcBBGnpIIbNWpFUBdLQzuBQEzu/OPQQ4Iyu8u01E@public.gmane.org

Sure, that works. I considered doing it that way but it seemed more
complicated. Please use that patch instead of mine.

	Arnd
