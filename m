From: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/5] arm64: efi: always map runtime services code and data
 regions down to pages
Date: Fri, 22 Jul 2016 15:30:44 +0100
Message-ID: <64a731b2-1ddb-78f5-fd02-204f19f0a432@arm.com>
References: <1467204690-10790-1-git-send-email-ard.biesheuvel@linaro.org>
 <1467204690-10790-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467204690-10790-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On 29/06/16 13:51, Ard Biesheuvel wrote:
> To avoid triggering diagnostics in the MMU code that are finicky about
> splitting block mappings into more granular mappings, ensure that regions
> that are likely to appear in the Memory Attributes table as well as the
> UEFI memory map are always mapped down to pages. This way, we can use
> apply_to_page_range() instead of create_pgd_mapping() for the second pass,
> which cannot split or merge block entries, and operates strictly on PTEs.
>
> Note that this aligns the arm64 Memory Attributes table handling code with
> the ARM code, which already uses apply_to_page_range() to set the strict
> permissions.
>

This patch is merged in arm64/for-next/core now and when I try that
branch with defconfig + CONFIG_PROVE_LOCKING, I get the following splat
on boot and it fails to boot further on Juno.

I could bisect that to this patch(Commit bd264d046aad ("arm64: efi:
always map runtime services code and data regions down to pages") in
that branch)

Regards,
Sudeep

-->8

efi: memattr: Processing EFI Memory Attributes table:
efi: memattr:  0x0000f9400000-0x0000f942ffff [Runtime Data       |RUN| | 
  |XP|  |  |  |   |  |  |  |  ]
Unable to handle kernel NULL pointer dereference at virtual address 00000018
pgd = ffff000009aa4000
[00000018] *pgd=00000009ffffe003, *pud=00000009ffffd003, 
*pmd=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.7.0-rc7-next-20160722 #134
Hardware name: ARM Juno development board (r2) (DT)
task: ffff800976ca0000 task.stack: ffff800976c3c000
PC is at __lock_acquire+0x13c/0x19e0
LR is at lock_acquire+0x4c/0x68
pc : [<ffff000008104544>] lr : [<ffff000008106114>] pstate: 200000c5
....
  __lock_acquire+0x13c/0x19e0
  lock_acquire+0x4c/0x68
  _raw_spin_lock+0x40/0x58
  apply_to_page_range+0x18c/0x388
  efi_set_mapping_permissions+0x34/0x44
  efi_memattr_apply_permissions+0x200/0x2a8
  arm_enable_runtime_services+0x1b4/0x1fc
  do_one_initcall+0x38/0x128
  kernel_init_freeable+0x84/0x1f0
  kernel_init+0x10/0x100
  ret_from_fork+0x10/0x40
Code: 5280003c 79004401 140000b5 b000b880 (f9400282)
---[ end trace 892120beb6681b4e ]---
