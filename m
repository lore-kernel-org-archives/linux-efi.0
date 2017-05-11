From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Correct ident mapping of efi old_map when
 kalsr enabled
Date: Thu, 11 May 2017 17:32:44 +0800
Message-ID: <20170511093244.GA18062@x1>
References: <1493294823-9315-1-git-send-email-bhe@redhat.com>
 <20170505204214.GB5225@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170505204214.GB5225-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi all,

On 05/05/17 at 09:42pm, Matt Fleming wrote:
> (Including the folks from SGI since this was hit on a UV system)

After debugging, I got the reason why kernel still crash casually when
the ident mapping issue of old_map efi has been fixed. It's because
SGI UV3 needs map MMIOH regions.  On a SGI uv3 system, I found that
there are two MMIOH regions:

[    1.519001] UV: Map MMIOH0_HI 0xffc00000000 - 0x100000000000
                                      16TB-16G -  16T
[    1.523001] UV: Map MMIOH1_HI 0x100000000000 - 0x200000000000
                                           16TB - 32TB
On this system, 512G ram are spread out to 1TB regions. Then above two
SGI MMIOH region also will be mapped into direct mapping section by
adding PAGE_OFFSET. The thing is SGI UV3 maps its MMIOH region to direct
mapping in uv_system_init() which is called during
kernel_init_freeable(), it's much later than kernel_randomize_memory(),
mm KASLR has no chance to take it into consideration.

When kaslr disabled, we can see that there are 64T
memory for ram. If system ram is not big enough, the left space of the
whole 64T memory is still enough to contain MMIOH regions to make it not
reach vmalloc and vmemmap area. 

ffff880000000000 - ffffc7ffffffffff (=64 TB) direct mapping of all phys.
memory                                                                  
136T - 200T
ffffc80000000000 - ffffc8ffffffffff (=40 bits) hole
200T - 201T
ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space
201T - 233T 

While with kaslr enabled, there's no this 64T memory reserved thing for
system ram any more. KASLR only reserve the actual size of system ram plus
10TB for direct mapping. So on SGI uv3 system, with kaslr enabled, MMIOH
region mapping could touch vmalloc or vmemmap area and trigger the BUG_ON()
in __init_extra_mapping().

Below is the back trace of crash after the ident mapping of old_map is
fixed. I believe this will happen on new map efi too, will reboot
several times to test new map efi.

So I will repost v3 for the ident mapping of old_map efi issue because
that is a code bug and independent with this one. And any idea about
this SGI uv3 MMIOH mapping issue?
 

[    1.375001] UV: Found UV300 hub
[    1.376007] UV: UVsystab: Revision:1
[    1.377001] UV: No UVsystab socket table, ignoring
[    1.378003] UV: N:7 M:38 m_shift:26 n_lshift:43
[    1.379001] UV: gpa_mask/shift:0x1fffffffffff/0 pnode_mask:0x7f apic_pns:5
[    1.380001] UV: mmr_base/shift:0xffa00000000/26 gru_base/shift:0x0/0
[    1.381001] UV: gnode_upper:0x0 gnode_extra:0x0
[    1.382001] UV: NODE_PRESENT_DEPTH = 16
[    1.383001] UV: NODE_PRESENT(0) = 0x000000000000000f
[    1.384005] UV: Found 4 hubs, 4 nodes, 128 CPUs
[    1.385076] UV: UVHUB node: 0 pn:00 nrcpus:32
[    1.386001] UV: UVHUB node: 1 pn:01 nrcpus:32
[    1.387001] UV: UVHUB node: 2 pn:02 nrcpus:32
[    1.388001] UV: UVHUB node: 3 pn:03 nrcpus:32
[    1.389001] UV: min_pnode:00 max_pnode:03
[    1.390002] UV: Map GRU_HI 0xff000000000 - 0xff040000000
[    1.391013] UV: Map MMR_HI 0xffa00000000 - 0xffa10000000
[    1.392004] UV: MMIOH0 overlay 0x8006cffc00000000 base:0x3ff00 m_io:27
[    1.393029] UV: MMIOH0[000..127] NASID 0x0000 ADDR 0x00000ffc00000000 - 0x0000100000000000
[    1.394001] UV: MMIOH0 base:0x3ff00 shift:26 M_IO:27 MAX_IO:127
[    1.395001] UV: Map MMIOH0_HI 0xffc00000000 - 0x100000000000
[    1.396116] UV: MMIOH1 overlay 0x8009500000000000 base:0x40000 m_io:37
[    1.397029] UV: MMIOH1[000..127] NASID 0x0000 ADDR 0x0000100000000000 - 0x0000200000000000
[    1.398001] UV: MMIOH1 base:0x40000 shift:26 M_IO:37 MAX_IO:127
[    1.399001] UV: Map MMIOH1_HI 0x100000000000 - 0x200000000000
[    1.487916] ------------[ cut here ]------------
[    1.488002] kernel BUG at arch/x86/mm/init_64.c:311!
[    1.489003] invalid opcode: 0000 [#1] SMP
[    1.490000] Modules linked in:
[    1.490000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.11.0+ #17
[    1.490000] Hardware name: SGI UV300/UV300, BIOS SGI UV 300 series BIOS 05/25/2016
[    1.490000] task: ffff88d6f3910000 task.stack: ffffa488c0018000
[    1.490000] RIP: 0010:__init_extra_mapping+0x188/0x196
[    1.490000] RSP: 0000:ffffa488c001bc50 EFLAGS: 00010202
[    1.490000] RAX: ffff88d6ffc02000 RBX: ffff8897ffd16118 RCX: 00003ffffffff000
[    1.490000] RDX: ffff88d6ffc02000 RSI: 80001bf23fe001fb RDI: 0000000000000000
[    1.490000] RBP: ffffa488c001bc80 R08: 0000000000000000 R09: 000000000001f458
[    1.490000] R10: ffff88b6fffd5d00 R11: 0000000000000001 R12: 00001bf240000000
[    1.490000] R13: 0000040dc0000000 R14: 80000000000001fb R15: 0000000000000118
[    1.490000] FS:  0000000000000000(0000) GS:ffff88b683600000(0000) knlGS:0000000000000000
[    1.490000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.490000] CR2: ffff89757efff000 CR3: 0000000430a09000 CR4: 00000000003406f0
[    1.490000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.490000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.490000] Call Trace:
[    1.490000]  init_extra_mapping_uc+0x13/0x15
[    1.490000]  map_high+0x67/0x75
[    1.490000]  map_mmioh_high_uv3+0x20a/0x219
[    1.490000]  uv_system_init_hub+0x12d9/0x1496
[    1.490000]  uv_system_init+0x27/0x29
[    1.490000]  native_smp_prepare_cpus+0x28d/0x2d8
[    1.490000]  kernel_init_freeable+0xdd/0x253
[    1.490000]  ? rest_init+0x80/0x80
[    1.490000]  kernel_init+0xe/0x110
[    1.490000]  ret_from_fork+0x2c/0x40
[    1.490000] Code: 0a ee 29 ff 66 90 48 8b 3b e8 30 2e 2a ff 4c 89 e2
48 c1 ea 12 81 e2 f8 0f 00 00 48 01 c2 48 f7 02 9f ff ff ff 0f 84 da fe
ff ff <0f> 0b 58 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 55 48 
[    1.490000] RIP: __init_extra_mapping+0x188/0x196 RSP: ffffa488c001bc50
[    1.490002] ---[ end trace f1736a9e6e4b7656 ]---
[    1.491001] Kernel panic - not syncing: Fatal exception
[    1.492000] ---[ end Kernel panic - not syncing: Fatal exception
******** [20170511.020636] BMC r001i11b: Power OFF via BMC 
******** [20170511.020701] BMC r001i11b: Power ON via BMC

> 
> On Thu, 27 Apr, at 08:07:03PM, Baoquan He wrote:
> > For EFI with old_map enabled, Kernel will panic when kaslr is enabled.
> > 
> > The root cause is the ident mapping is not built correctly in this case.
> > 
> > For nokaslr kernel, PAGE_OFFSET is 0xffff880000000000 which is PGDIR_SIZE
> > aligned. We can borrow the pud table from direct mapping safely. Given a
> > physical address X, we have pud_index(X) == pud_index(__va(X)). However,
> > for kaslr kernel, PAGE_OFFSET is PUD_SIZE aligned. For a given physical
> > address X, pud_index(X) != pud_index(__va(X)). We can't only copy pgd entry
> > from direct mapping to build ident mapping, instead need copy pud entry
> > one by one from direct mapping.
> > 
> > So fix it in this patch.
> > 
> > The panic message is like below, an emty PUD or a wrong PUD.
> > 
> > [    0.233007] BUG: unable to handle kernel paging request at 000000007febd57e
> > [    0.233899] IP: 0x7febd57e
> > [    0.234000] PGD 1025a067
> > [    0.234000] PUD 0
> > [    0.234000]
> > [    0.234000] Oops: 0010 [#1] SMP
> > [    0.234000] Modules linked in:
> > [    0.234000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0-rc8+ #125
> > [    0.234000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
> > [    0.234000] task: ffffffffafe104c0 task.stack: ffffffffafe00000
> > [    0.234000] RIP: 0010:0x7febd57e
> > [    0.234000] RSP: 0000:ffffffffafe03d98 EFLAGS: 00010086
> > [    0.234000] RAX: ffff8c9e3fff9540 RBX: 000000007c4b6000 RCX: 0000000000000480
> > [    0.234000] RDX: 0000000000000030 RSI: 0000000000000480 RDI: 000000007febd57e
> > [    0.234000] RBP: ffffffffafe03e40 R08: 0000000000000001 R09: 000000007c4b6000
> > [    0.234000] R10: ffffffffafa71a40 R11: 20786c6c2478303d R12: 0000000000000030
> > [    0.234000] R13: 0000000000000246 R14: ffff8c9e3c4198d8 R15: 0000000000000480
> > [    0.234000] FS:  0000000000000000(0000) GS:ffff8c9e3fa00000(0000) knlGS:0000000000000000
> > [    0.234000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    0.234000] CR2: 000000007febd57e CR3: 000000000fe09000 CR4: 00000000000406b0
> > [    0.234000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [    0.234000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [    0.234000] Call Trace:
> > [    0.234000]  ? efi_call+0x58/0x90
> > [    0.234000]  ? printk+0x58/0x6f
> > [    0.234000]  efi_enter_virtual_mode+0x3c5/0x50d
> > [    0.234000]  start_kernel+0x40f/0x4b8
> > [    0.234000]  ? set_init_arg+0x55/0x55
> > [    0.234000]  ? early_idt_handler_array+0x120/0x120
> > [    0.234000]  x86_64_start_reservations+0x24/0x26
> > [    0.234000]  x86_64_start_kernel+0x14c/0x16f
> > [    0.234000]  start_cpu+0x14/0x14
> > [    0.234000] Code:  Bad RIP value.
> > [    0.234000] RIP: 0x7febd57e RSP: ffffffffafe03d98
> > [    0.234000] CR2: 000000007febd57e
> > [    0.234000] ---[ end trace d4ded46ab8ab8ba9 ]---
> > [    0.234000] Kernel panic - not syncing: Attempted to kill the idle task!
> > [    0.234000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> > 
> > Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> > Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> > Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > ---
> > v1->v2:
> >     Change code and add description according to Thomas's suggestion as below:
> > 
> >     1. Add checking if pud table is allocated successfully. If not just break
> >     the for loop.
> > 
> >     2. Add code comment to explain how the 1:1 mapping is built in efi_call_phys_prolog
> > 
> >     3. Other minor change
> > 
> >  arch/x86/platform/efi/efi_64.c | 72 +++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 64 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index 2ee7694..48de7fd 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -71,11 +71,13 @@ static void __init early_code_mapping_set_exec(int executable)
> >  
> >  pgd_t * __init efi_call_phys_prolog(void)
> >  {
> > -	unsigned long vaddress;
> > +	unsigned long vaddr, left_vaddr;
> > +	unsigned int num_entries;
> >  	pgd_t *save_pgd;
> > -
> > -	int pgd;
> > +	pud_t *pud, *pud_k;
> > +	int pud_idx;
> >  	int n_pgds;
> > +	int i;
> >  
> >  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
> >  		save_pgd = (pgd_t *)read_cr3();
> > @@ -88,10 +90,51 @@ pgd_t * __init efi_call_phys_prolog(void)
> >  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
> >  	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
> >  
> > -	for (pgd = 0; pgd < n_pgds; pgd++) {
> > -		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> > -		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
> > -		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
> > +	/*
> > +	 * We try to build 1:1 ident mapping for efi old_map usage. However,
> > +	 * whether kaslr is enabled or not, PAGE_OFFSET must be PUD_SIZE
> > +	 * aligned. Given a physical address X, we can copy its pud entry
> > +	 * of __va(X) to fill in its pud entry of 1:1 mapping since both
> > +	 * of them relate to the same physical memory position.
> > +	 *
> > +	 * And copying those pud entries one by one is inefficient. We copy
> > +	 * memory. Assume PAGE_OFFSET is not PGDIR_SIZE aligned, say it's
> > +	 * 0xffff880080000000, and we have memory bigger than 512G. Then the
> > +	 * first 512G will cross two pgd entries. We need copy memory twice.
> > +	 * The 1st pud entry will be in the 3rd slot of pud table, so we copy
> > +	 * pud[2] to pud[511] of the 1st pud table pointed by the 1st pgd entry
> > +	 * firstly, then copy pud[0] to pud[1] of the 2nd pud table pointed by
> > +	 * 2nd pgd entry at the second time.
> > +	 */
> > +	for (i = 0; i < n_pgds; i++) {
> > +		save_pgd[i] = *pgd_offset_k(i * PGDIR_SIZE);
> > +
> > +		vaddr = (unsigned long)__va(i * PGDIR_SIZE);
> > +
> > +		/*
> > +		 * Though it may fail to allocate page in the middle, just
> > +		 * leave those allocated pages there since 1:1 mapping has
> > +		 * been built. And efi region could be located there, efi_call
> > +		 * still can work.
> > +		 */
> > +		pud = pud_alloc_one(NULL, 0);
> > +		if (!pud) {
> > +			pr_err("Failed to allocate page for %d-th pud table "
> > +				"to build 1:1 mapping!\n", i);
> > +			break;
> > +		}
> > +
> > +		pud_idx = pud_index(vaddr);
> > +		num_entries = PTRS_PER_PUD - pud_idx;
> > +		pud_k = pud_offset(pgd_offset_k(vaddr), vaddr);
> > +		memcpy(pud, pud_k, num_entries);
> > +		if (pud_idx > 0) {
> > +			left_vaddr = vaddr + (num_entries * PUD_SIZE);
> > +			pud_k = pud_offset(pgd_offset_k(left_vaddr),
> > +					   left_vaddr);
> > +			memcpy(pud + num_entries, pud_k, pud_idx);
> > +		}
> > +		pgd_populate(NULL, pgd_offset_k(i * PGDIR_SIZE), pud);
> >  	}
> >  out:
> >  	__flush_tlb_all();
> > @@ -106,6 +149,8 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
> >  	 */
> >  	int pgd_idx;
> >  	int nr_pgds;
> > +	pud_t *pud;
> > +	pgd_t *pgd;
> >  
> >  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
> >  		write_cr3((unsigned long)save_pgd);
> > @@ -115,8 +160,19 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
> >  
> >  	nr_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
> >  
> > -	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++)
> > +	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++) {
> > +		pgd = pgd_offset_k(pgd_idx * PGDIR_SIZE);
> > +
> > +		/*
> > +		 * We need check if the pud table was really allocated
> > +		 * successfully. Otherwise no need to free.
> > +		 * */
> > +		if (pgd_val(*pgd) != pgd_val(save_pgd[pgd_idx])) {
> > +			pud = (pud_t *)pgd_page_vaddr(*pgd);
> > +			pud_free(NULL, pud);
> > +		}
> >  		set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE), save_pgd[pgd_idx]);
> > +	}
> >  
> >  	kfree(save_pgd);
> 
> This seems like a lot of code for a really simple problem. Do other
> 1:1 users require this change? I'm thinking of the realmode trampoline
> code.
> 
> If the SGI folks think this looks OK then I'll apply it with Thomas'
> ACK.
