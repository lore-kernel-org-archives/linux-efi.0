From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Wed, 4 May 2016 14:20:42 +0200
Message-ID: <20160504122042.GB4074@pd.tnic>
References: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
 <20160503090229.GC27540@pd.tnic>
 <20160503141201.GW2839@codeblueprint.co.uk>
 <20160504093031.GA4074@pd.tnic>
 <20160504114605.GH2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504114605.GH2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, May 04, 2016 at 12:46:05PM +0100, Matt Fleming wrote:
> But emergency_restart() is called after bust_spinlocks(0) which can
> reset oops_in_progress, so can't even use that to solve the panic
> case.

Blergh.

So I guess you need an explicit call efi_stop_capsules() somewhere in
the reboot path and be done with it. No reboot notifiers, no bla bla.
Just one big hammer which STFU the EFI.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
