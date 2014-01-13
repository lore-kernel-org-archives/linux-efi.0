From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Date: Mon, 13 Jan 2014 15:49:09 +0000
Message-ID: <20140113154909.GI3256@console-pimps.org>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-2-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1389473370-1940-2-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Arjan van de Ven <arjan@linux.intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, Toshi Kani <toshi.kani@hp.com>
List-Id: linux-efi@vger.kernel.org

On Sat, 11 Jan, at 09:49:27PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> With reusing the ->trampoline_pgd page table for mapping EFI regions in
> order to use them after having switched to EFI virtual mode, it is very
> useful to be able to dump aforementioned page table in dmesg. This adds
> that functionality through the walk_pgd_level() interface which can be
> called from somewhere else.
> 
> The original functionality of dumping to debugfs remains untouched.
> 
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/pgtable.h |  3 +-
>  arch/x86/mm/dump_pagetables.c  | 77 ++++++++++++++++++++++++++++--------------
>  2 files changed, 53 insertions(+), 27 deletions(-)

[...]

> @@ -296,7 +316,7 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st, pgd_t addr,
>  #define pgd_none(a)  pud_none(__pud(pgd_val(a)))
>  #endif
>  
> -static void walk_pgd_level(struct seq_file *m)
> +void walk_pgd_level(struct seq_file *m, pgd_t *pgd)
>  {

If you're going to start exporting this function, might I suggest
renaming it something like ptdump_walk_pgd_level()?

-- 
Matt Fleming, Intel Open Source Technology Center
