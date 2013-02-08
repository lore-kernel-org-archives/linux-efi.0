From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH v5 -next 0/2] make efivars/efi_pstore interrupt-safe
Date: Fri, 8 Feb 2013 22:31:27 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A884D6@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A5419C@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A5419C-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Matt,

Can you please take a look at this patchset which removes create_sysfs_entries() from efi_pstore_write()?

It has been updated in accordance with Mike's comment and fixes an actual bug.
http://comments.gmane.org/gmane.linux.kernel.efi/406

Seiji

> -----Original Message-----
> From: Seiji Aguchi
> Sent: Wednesday, January 23, 2013 7:41 PM
> To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org); mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org;
> matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Satoru Moriya
> Subject: [PATCH v5 -next 0/2] make efivars/efi_pstore interrupt-safe
> 
> Changelogv4 -> v5
>    - Rebase from a linus tree to a linux-next tree to avoid getting
>      a conflict when this patchset is merged to a linux-next tree.
>    - Merge previous patches 2/3 and 3/3 into 2/2 because they fix
>      a same problem.
>    - Modify to fit a latest upstream kernel as follows.
>     - Change spinlock operations of efivarfs which has been
>       introduced recently.(Patch 1/2)
>     - Remove delete_all_stale_sysfs_entries() from update_sysfs_entries()
>       because a currnet efi_pstore doesn't erase existing entries
>       in a write callback and sysfs entries don't become stale.
>       (Patch 2/2)
> 
> v3 -> v4
>   - Patch 2/3
>     Move cancel_work_sync() above an efi_enabled test in efivars_exit().
> 
> v2 -> v3
>   - Patch 1/3
>     Replace spin_lock_irqsave/spin_unlock_irqrestore with spin_lock_irq/spin_unlock_irq in efivars_unregister(),
>     efivar_create(), efivar_store_raw() and efivar_delete() which are called in a process context.
> 
>  - Patch 2/3
>     Change a name of delete_sysfs_entry() to delete_all_stale_sysfs_entries().
>     Also, don't release an efivar->lock while searching efivar->list in delete_all_stale_sysfs_entries().
> 
>  - Patch 3/3
>     Remove a logic in efi_pstore_erase() which freshly created in patch v2.
> 
> v1 -> v2
>  - Patch 1/3
>     Add spin_lock_irq/spin_unlock_irq to open/close callbacks of efi_pstore
>     instead of moving spin_locks to a read callback.
> 
>  - Patch 2/3
>     Replace a periodical timer with schedule_work().
> 
>  - Patch 3/3
>     freshly create to kick a workqueue in oops case only.
> 
> [Problem]
>  There are following problems related to an interrupt context in efivars  including efivarfs and efi_pstore.
> 
> (1)There is a scenario which efi_pstore fails to log messages
>    in a panic case.
> 
>    - CPUA holds an efi_var->lock in either efivarfs parts
>      or efi_pstore with interrupt enabled.
>    - CPUB panics and sends IPI to CPUA in smp_send_stop().
>    - CPUA stops with holding the lock.
>    - CPUB kicks efi_pstore_write() via kmsg_dump(KSMG_DUMP_PANIC)
>      but it returns without logging messages.
> 
> (2)Also, efi_pstore creates sysfs entries, which enable users to access to
>    NVRAM, in a write callback.
>    If a kernel panic happens in an interrupt contexts, pstore may fail
>    because it could sleep due to dynamic memory allocations during creating
>    sysfs entries.
>    An actual failure due to the create_sysfs_entry() has been reported.
>    http://comments.gmane.org/gmane.linux.kernel.efi/406
> 
> To resolve problems above, this patchset makes efivars/efi_pstore interrupt-safe.
> 
> [Patch Description]
>   Please see detailed explanations in each patch.
> 
> Seiji Aguchi (2):
>   efivars: Disable external interrupt while holding efivars->lock
>    - This patch fixes a problem (1).
> 
>   efi_pstore: Introducing workqueue updating sysfs entries
>    - This patch fixes a problem (2).
> 
>  drivers/firmware/efivars.c |  171 ++++++++++++++++++++++++++++++++------------
>  include/linux/efi.h        |    3 +-
>  2 files changed, 126 insertions(+), 48 deletions(-)
