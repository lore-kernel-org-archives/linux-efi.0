From: Alex Thorlton <athorlton@sgi.com>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Fri, 29 Apr 2016 10:41:19 -0500
Message-ID: <20160429154119.GI113599@stormcage.americas.sgi.com>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160428125711.GB9164@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, mike travis <travis@sgi.com>, Nathan Zimmer <nzimmer@sgi.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 28, 2016 at 02:57:11PM +0200, Borislav Petkov wrote:
> > After d2f7cbe7b26a74 ("x86/efi: Runtime services virtual mapping") was
> > introduced (I'm sure you remember the BIOS issue we had a while back) we
> > had to fall back to using EFI_OLD_MEMMAP, so for a while we relied on
> > efi_ioremap.
> 
> Hmm, but you see my confusion, right? Why is init_extra_mapping_uc()
> influenced by the EFI changes? It uses __init_extra_mapping() and it
> maps into init_mm's pgd.

I think the answer here is that the init_extra_mapping wasn't
necessarily affected by the EFI changes.  What happened is that the new
EFI changes in d2f7cbe7b26a74 mapped in the register for us, before
uv_system_init came along and tried to do it with the
init_extra_mapping.  When uv_system_init tried to do the extra mappings,
they fail because the register was already mapped by the EFI code.

> > Eventually we got a BIOS fix that allowed us to start using the new
> > memmap scheme, at which point we removed the init_extra_mapping_uc()s,
> > since the efi_map_region code appeared to be doing what we needed.
> 
> Why would you even do that? Why are you even mapping MMRs using EFI
> facilities?

I believe this was unintentional behavior.  Here's the order that I
think all this got mixed up in (the first step being what was actually
wrong in the first place):

1) From the very beginning, we've had the address space containing those
   registers tucked inside and EFI memory descriptor.  Initially this
   wasn't an issue, I believe because the efi_ioremap was putting them
   in ioremap space, so there was no collision when we went to do the
   init_extra_mapping.
2) EFI code changed in d2f7cbe7b26a74 to do stuff with efi_map_region,
   which then comes in and maps the register into the kernel 1:1 space,
   where our init_extra_mapping used to place it.
   * This caused our original issue, because the init_extra_mapping
     would blow up in uv_system_init when the registers were already
     mapped.
   * Note that we had one BIOS bug that initally prevented us from using
     the new mapping scheme at all.  We *thought* we had this cleared
     up, but it appears we may have missed something.
3) I removed the init_extra_mapping in d394f2d9d8e1 becausem, as
   described above, it was causing a crash during uv_system_init when we
   switched over to the new EFI memmap scheme.
   * Note that UV1 did not receive a BIOS fix, so it will eternally use
     EFI_OLD_MEMMAP.
4) The latest change came along, and pulled the 1:1 mappings out of the
   trampoline_pgd (and therefore out of the kernel page table) and here
   we are today.

> I'm more confused today.

It took me a about 3 entire days to wrap my head around all this :)

> So what I see from here is this:
> 
> * MMRs and EFI shouldn't have anything in common. Imagine there were an
> UV box without EFI (you probably are going to say there's no such thing
> but imagine anyway): how are you going to map the MMR space then?

Right - I'm beginning to see where we went wrong here :)

> * I think you should restore the old case where you mapped the MMRs
> using init_extra_mapping_uc().
> 
> And I think
> 
>   d394f2d9d8e1 ("x86/platform/UV: Remove EFI memmap quirk for UV2+")
> 
> was wrong in doing
> 
> +       if (is_uv1_hub())
> +               map_low_mmrs();
> 
> for the simple fact that MMRs mapping and EFI shouldn't depend on one
> another.

I agree here.

> So the proper fix would be to remove the if- check.
> 
> Or am I missing something here and MMRs need EFI?

I think this is partially correct, but in doing that, we find that we're
still missing something.  Watch what happens when I make this small
tweak to my kernel:

8<---
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c
b/arch/x86/kernel/apic/x2apic_uv_x.c
index 624db005..91ac029 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -891,7 +891,7 @@ void __init uv_system_init(void)
        pr_info("UV: Found %s hub\n", hub);
 
        /* We now only need to map the MMRs on UV1 */
-       if (is_uv1_hub())
+       //if (is_uv1_hub())
                map_low_mmrs();
 
        m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
--->8

Here's the result:

8<---
[    5.353656] BUG: unable to handle kernel paging request at ffff88006a1ab938
[    5.361448] IP: [<ffff88006a1ab938>] 0xffff88006a1ab938
[    5.367290] PGD 1f81067 PUD 87ffff067 PMD 87fff8067 PTE 0
[    5.373356] Oops: 0010 [#1] SMP 
[    5.376977] Modules linked in:
[    5.380395] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.5.0-rc2-uv4-comm-debug-fix+ #538
[    5.389428] Hardware name: SGI UV3000/UV3000, BIOS SGI UV 3000 series BIOS 01/15/2015
[    5.398169] task: ffff880867ec4040 ti: ffff880867ec8000 task.ti: ffff880867ec8000
[    5.406522] RIP: 0010:[<ffff88006a1ab938>]  [<ffff88006a1ab938>] 0xffff88006a1ab938
[    5.415080] RSP: 0000:ffff880867ecbc88  EFLAGS: 00010086
[    5.421006] RAX: 0000000000000000 RBX: 0000000000000282 RCX: 0000000000000001
[    5.428971] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88006a1ab938
[    5.436935] RBP: ffff880867ecbd58 R08: ffff880867ecbd68 R09: ffff880867ecbd70
[    5.444900] R10: ffffffffffffffda R11: 000000006a1ab938 R12: 0000000000000000
[    5.452864] R13: ffffffff81dcf0b8 R14: ffffffff81dcf0c0 R15: ffffffff81dcf0a0
[    5.460829] FS:  0000000000000000(0000) GS:ffff880878c00000(0000) knlGS:0000000000000000
[    5.469861] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.476274] CR2: ffff88006a1ab938 CR3: 0000000001a0a000 CR4: 00000000001406f0
[    5.484240] Stack:
[    5.486483]  ffffffff8105d7f8 0000000000000000 0000000000000006 0000000000000006
[    5.494777]  000000000000001e 0000000000000000 0000000000000000 ffff880867ecbd38
[    5.503074]  0000000080050033 0000000000000000 0000000000000000 0000000000000000
[    5.511368] Call Trace:
[    5.514098]  [<ffffffff8105d7f8>] ? efi_call+0x58/0x90
[    5.519834]  [<ffffffff8106033d>] ? uv_bios_call_irqsave+0x5d/0x80
[    5.526733]  [<ffffffff810603a0>] uv_bios_get_sn_info+0x40/0xb0
[    5.533344]  [<ffffffff81b6f824>] uv_system_init+0x772/0x104d
[    5.539751]  [<ffffffff810bd479>] ? vprintk_default+0x29/0x40
[    5.546159]  [<ffffffff81161cf8>] ? printk+0x4d/0x4f
[    5.551692]  [<ffffffff81b6ac75>] native_smp_prepare_cpus+0x299/0x2e4
[    5.558884]  [<ffffffff81b5c18e>] kernel_init_freeable+0xc3/0x21b
[    5.565680]  [<ffffffff815acd00>] ? rest_init+0x80/0x80
[    5.571502]  [<ffffffff815acd0e>] kernel_init+0xe/0xf0
[    5.577238]  [<ffffffff815b87cf>] ret_from_fork+0x3f/0x70
[    5.583264]  [<ffffffff815acd00>] ? rest_init+0x80/0x80
[    5.589093] Code:  Bad RIP value.
[    5.592812] RIP  [<ffff88006a1ab938>] 0xffff88006a1ab938
[    5.598748]  RSP <ffff880867ecbc88>
[    5.602638] CR2: ffff88006a1ab938
[    5.606339] ---[ end trace 3abaacb020c74a50 ]---
[    5.611487] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
--->8

You can see here that we've made it past the MMR read in uv_system_init,
but we die inside of our first EFI callback.  In this example, it looks
like we're using the kernel page table at the time of the failure, and I
believe that the failing address is somewhere in our EFI runtime code:

[    0.803396] efi: ATHORLTON EFI md dump:
[    0.803396]         type: 5
[    0.803396]         pad: 0
[    0.803396]         phys_addr: 6a0a6000
[    0.803396]         virt_addr: 0
[    0.803396]         num_pages: 184
[    0.803396]         attribute: 800000000000000f

So it looks like we're trying to read from EFI runtime space while using
the kernel page table, which fails, presumably because the space is also
not mapped into the kernel page table.  While I understand *why* it
fails, and why the address isn't mapped, I don't fully know how we
should handle fixing it.

It would appear after a good amount of investigation that we've been
skating by on some (perhaps not so subtle) undefined/unintentional
behvaior inside the EFI memory mapping code.

I will need to talk with our BIOS team about this to see what they
think.  Any input you guys might have on how we might remedy this
situation would be really valuable.  I think we have a good
understanding of what's going wrong here, but now we need to work out a
way to fix it.

Thanks for you help so far!

- Alex
