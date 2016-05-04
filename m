From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Wed, 4 May 2016 11:30:31 +0200
Message-ID: <20160504093031.GA4074@pd.tnic>
References: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
 <20160503090229.GC27540@pd.tnic>
 <20160503141201.GW2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160503141201.GW2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, May 03, 2016 at 03:12:01PM +0100, Matt Fleming wrote:
> We can find ourselves in the reboot code even if the admin has not
> executed the reboot command. The trace above shows we entered because
> the kernel panic()'d and it was booted with panic=-1.

I knew you were gonna say something like that...

> Right. You could find yourself in this situation if you're in the
> middle of a capsule update and the box panics and reboots. Like you
> said, there's really not much you can do there to ensure the update
> completes. Your best option is to just not block and hang the machine.

Hmmm, so panic() does bust_spinlocks() and efi_capsule_pending() could
look at oops_in_progress which is set by bust_spinlocks() and that would
probably solve the panic case but maybe the normal reboot case would
still hang...

> Note that in the panic() -> emergency_restart() case the reboot
> notifiers are not called at all.

And then there's that.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
