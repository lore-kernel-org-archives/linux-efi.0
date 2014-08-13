From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Wed, 13 Aug 2014 15:18:36 +0100
Message-ID: <20140813141836.GQ15082@console-pimps.org>
References: <1407729253-31341-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1407729253-31341-1-git-send-email-linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 10 Aug, at 08:54:13PM, Guenter Roeck wrote:
> spin_is_locked() always returns false for uniprocessor configurations,
> so do not use WARN_ON with it. WARN_ON_SMP() exists for that very
> purpose and must be used instead.
 
Good catch, though I worry that WARN_ON_SMP() doesn't seem to be a very
common pattern,

arch/x86/pci/i386.c:	WARN_ON_SMP(!spin_is_locked(&pcibios_fwaddrmap_lock));
drivers/gpu/drm/drm_irq.c:	WARN_ON_SMP(!spin_is_locked(&dev->event_lock));
include/asm-generic/bug.h: * WARN_ON_SMP() is for cases that the warning is either
include/asm-generic/bug.h: *	WARN_ON_SMP(!zoot->bar);
include/asm-generic/bug.h: * For CONFIG_SMP, WARN_ON_SMP() should act the same as WARN_ON(),
include/asm-generic/bug.h: * if (WARN_ON_SMP(x)) returns true only when CONFIG_SMP is set
include/asm-generic/bug.h:# define WARN_ON_SMP(x)			WARN_ON(x)
include/asm-generic/bug.h: * Use of ({0;}) because WARN_ON_SMP(x) may be used either as
include/asm-generic/bug.h:# define WARN_ON_SMP(x)			({0;})
kernel/futex.c:	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))

and people must want to do this kind of checking all the time.

How about lockdep_assert_held()? That seems to be much more popular.

-- 
Matt Fleming, Intel Open Source Technology Center
