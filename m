From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH 2/5] efi: Introduce a Runtime Services lock
Date: Wed, 16 Oct 2013 23:36:54 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EF85DC@USINDEM103.corp.hds.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-3-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381931460-6999-3-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> +#define efi_call_reset_virt(f, args...)					\
> +({									\
> +	unsigned long __flags;						\
> +	bool __nmi = in_nmi();						\
> +									\
> +	if (__nmi)							\
> +		spin_lock_irqsave(&efi_runtime_lock, __flags);		\

If the lock is not held in the nmi context, runtime service may run concurrently
in non-nmi context as follows.
 - In nmi context, cpu0 calls a runtime service (no lock is held.)
 - In non-nmi context, cpu1 call can take the lock and call the runtime service.

To avoid this, using try_lock in nmi context is better..

If(in_nmi())
	try_spin_lock_irqsave();
else
	spin_lock_irqsave();

Please see the commit abd4d5587be911f63592537284dad78766d97d62,
which is introduced to pstore by Don Zickus.

Seiji
