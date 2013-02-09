From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v5 -next 1/2]efivars: Disable external interrupt while
 holding efivars->lock
Date: Sat, 09 Feb 2013 20:02:38 +0000
Message-ID: <1360440158.7515.321.camel@mfleming-mobl1.ger.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541B5@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541B5-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-01-24 at 00:41 +0000, Seiji Aguchi wrote:
> [Problem]
> There is a scenario which efi_pstore fails to log messages in a panic case.
> 
>  - CPUA holds an efi_var->lock in either efivarfs parts 
>    or efi_pstore with interrupt enabled.
>  - CPUB panics and sends IPI to CPUA in smp_send_stop().
>  - CPUA stops with holding the lock.
>  - CPUB kicks efi_pstore_write() via kmsg_dump(KSMG_DUMP_PANIC)
>    but it returns without logging messages.
> 
> [Patch Description]
> This patch disables an external interruption while holding efivars->lock 
> as follows.
> 
> In efi_pstore_write() and get_var_data(), spin_lock/spin_unlock is 
> replaced by spin_lock_irqsave/spin_unlock_irqrestore because they may 
> be called in an interrupt context.
> 
> In other functions, they are replaced by spin_lock_irq/spin_unlock_irq.
> because they are all called from a process context.
> 
> By applying this patch, we can avoid the problem above with 
> a following senario.
> 
>  - CPUA holds an efi_var->lock with interrupt disabled.
>  - CPUB panics and sends IPI to CPUA in smp_send_stop().
>  - CPUA receives the IPI after releasing the lock because it is
>    disabling interrupt while holding the lock.
>  - CPUB waits for one sec until CPUA releases the lock.
>  - CPUB kicks efi_pstore_write() via kmsg_dump(KSMG_DUMP_PANIC)
>    And it can hold the lock successfully.
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
> Acked-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efivars.c |   86 ++++++++++++++++++++++---------------------
>  1 files changed, 44 insertions(+), 42 deletions(-)

Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Tony, are you picking this up?

-- 
Matt Fleming, Intel Open Source Technology Center
