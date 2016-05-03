From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Mon, 2 May 2016 19:10:36 -0500
Message-ID: <20160503001036.GX113599@stormcage.americas.sgi.com>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
 <20160502100222.GB25669@pd.tnic>
 <20160502222719.GW113599@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160502222719.GW113599-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 02, 2016 at 05:27:19PM -0500, Alex Thorlton wrote:
> Thanks for the help.  I'll get back to you when I know a bit more about
> what's happening with our runtime callbacks!

I've made a bit of progress here.  I was able to switch over to a very
slightly modified version of efi_call_virt and then tweak uv_bios_call
just a bit, and that (along with the re-introduction of the map_low_mmrs
calls) got my machine to boot:

8<---
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c
b/arch/x86/kernel/apic/x2apic_uv_x.c
index 8f4942e..82aa6a7 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -892,7 +892,7 @@ void __init uv_system_init(void)
        pr_info("UV: Found %s hub\n", hub);
 
        /* We now only need to map the MMRs on UV1 */
-       if (is_uv1_hub())
+       //if (is_uv1_hub())
                map_low_mmrs();
 
        m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 53748c4..0c4d347 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -48,6 +48,16 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
        __s;                                                            \
 })
 
+#define uv_call_virt(f, args...) \
+({                                                                     \
+       efi_status_t __s;                                               \
+       kernel_fpu_begin();                                             \
+       __s = ((efi_##f##_t __attribute__((regparm(0)))*)               \
+               f)(args);                                               \
+       kernel_fpu_end();                                               \
+       __s;                                                            \
+})
+
 /* Use this macro if your virtual call does not return any value */
 #define __efi_call_virt(f, args...) \
 ({                                                                     \
@@ -104,6 +114,32 @@ struct efi_scratch {
        __s;                                                            \
 })
 
+#define uv_call_virt(f, ...)                                           \
+({                                                                     \
+       efi_status_t __s;                                               \
+                                                                       \
+       efi_sync_low_kernel_mappings();                                 \
+       preempt_disable();                                              \
+       __kernel_fpu_begin();                                           \
+                                                                       \
+       if (efi_scratch.use_pgd) {                                      \
+               efi_scratch.prev_cr3 = read_cr3();                      \
+               write_cr3((unsigned long)efi_scratch.efi_pgt);          \
+               __flush_tlb_all();                                      \
+       }                                                               \
+                                                                       \
+       __s = efi_call((void *)f, __VA_ARGS__); \
+                                                                       \
+       if (efi_scratch.use_pgd) {                                      \
+               write_cr3(efi_scratch.prev_cr3);                        \
+               __flush_tlb_all();                                      \
+       }                                                               \
+                                                                       \
+       __kernel_fpu_end();                                             \
+       preempt_enable();                                               \
+       __s;                                                            \
+})
+
 /*
  * All X86_64 virt calls return non-void values. Thus, use non-void call for
  * virt calls that would be void on X86_32.

diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 1584cbe..6e99f81 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -39,8 +39,8 @@ s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
                 */
                return BIOS_STATUS_UNIMPLEMENTED;
 
-       ret = efi_call((void *)__va(tab->function), (u64)which,
-                       a1, a2, a3, a4, a5);
+       ret = uv_call_virt(tab->function, (u64)which, a1, a2, a3, a4, a5);
+
        return ret;
 }
 EXPORT_SYMBOL_GPL(uv_bios_call);
--->8

Note that the only change I made to efi_call_virt was to change
efi.systab->runtime->f to simply f in the efi_call line.  This works up
until we try to do callbacks from a loaded module.  When we try that we
hit this:

[   56.232086] BUG: unable to handle kernel paging request at ffffffff8106148f
[   56.239880] IP: [<fffffffedbb408ce>] 0xfffffffedbb408ce
[   56.245721] PGD 8698e0067 PUD 1a08063 PMD 10001e1 
[   56.251102] Oops: 0003 [#1] SMP 
[   56.254725] Modules linked in: hwperf(OE+) af_packet(E) iscsi_ibft(E) iscsi_boot_sysfs(E) msr(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) nl
s_iso8859_1(E) nls_cp437(E) irqbypass(E) vfat(E) crct10dif_pclmul(E) fat(E) crc32_pclmul(E) ghash_clmulni_intel(E) drbg(E) ansi_cprng(E) aesni_intel(E) aes_x86_64(E) lrw(E) igb(E) iTCO_wdt(E) 
gf128mul(E) glue_helper(E) iTCO_vendor_support(E) sb_edac(E) ablk_helper(E) ptp(E) edac_core(E) dm_mod(E) cryptd(E) pcspkr(E) lpc_ich(E) pps_core(E) i2c_i801(E) mfd_core(E) mei_me(E) ioatdma(E
) mei(E) shpchp(E) wmi(E) dca(E) processor(E) button(E) efivarfs(E) xfs(E) libcrc32c(E) sd_mod(E) mgag200(E) i2c_algo_bit(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) xhci_p
ci(E) fb_sys_fops(E) ahci(E) ehci_pci(E) ttm(E) xhci_hcd(E) ehci_hcd(E) crc32c_intel(E) libahci(E) ata_generic(E) drm(E) usbcore(E) libata(E) usb_common(E) sg(E) scsi_mod(E) autofs4(E)
[   56.348094] CPU: 12 PID: 7515 Comm: modprobe Tainted: G           OE   4.6.0-rc5-maplow-uvcall+ #552
[   56.358290] Hardware name: SGI UV3000/UV3000, BIOS SGI UV 3000 series BIOS 01/15/2015
[   56.367032] task: ffff8808650a1100 ti: ffff8808647ac000 task.ti: ffff8808647ac000
[   56.375385] RIP: 0010:[<fffffffedbb408ce>]  [<fffffffedbb408ce>] 0xfffffffedbb408ce
[   56.383941] RSP: 0018:ffff8808647afad0  EFLAGS: 00010246
[   56.389869] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff8106148f
[   56.397833] RDX: 0000000000000003 RSI: 0000000000000002 RDI: 0000000000000000
[   56.405797] RBP: ffff8808647afc78 R08: 0000000000000002 R09: 0000000000000002
[   56.413760] R10: 000000006a1b8540 R11: 0000000000000000 R12: 0000000000000002
[   56.421724] R13: 0000000000000000 R14: 0000000000010000 R15: 0000000000000003
[   56.429688] FS:  00007f6cf45c2700(0000) GS:ffff880878d80000(0000) knlGS:0000000000000000
[   56.438720] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   56.445131] CR2: ffffffff8106148f CR3: 00000008698df000 CR4: 00000000001406e0
[   56.453096] Stack:
[   56.455337]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   56.463632]  ffff8808673ace78 ffff8808673ace60 0000000000000000 0000000000000003
[   56.471928]  ffff8808647afb20 ffffffff81094402 ffff8808647afb68 ffffffff810abbb5
[   56.480225] Call Trace:
[   56.482958]  [<ffffffff81094402>] ? default_wake_function+0x12/0x20
[   56.489953]  [<ffffffff810abbb5>] ? __wake_up_common+0x55/0x90
[   56.496466]  [<ffffffff8106148f>] ? uv_bios_call+0x6f/0x110
[   56.502686]  [<ffffffff8105ea3c>] ? efi_call+0x5c/0x90
[   56.508425]  [<ffffffff8130c751>] ? vsnprintf+0x251/0x4b0
[   56.514449]  [<ffffffff8106148f>] ? uv_bios_call+0x6f/0x110
[   56.520667]  [<ffffffff8106148f>] uv_bios_call+0x6f/0x110
[   56.526693]  [<ffffffffa0296850>] ? uv_hwperf_deregister_procfs+0x90/0x90 [hwperf]
[   56.535143]  [<ffffffffa0296948>] uv_hwperf_entry+0xf8/0x200 [hwperf]
[   56.542334]  [<ffffffff810003dd>] do_one_initcall+0xad/0x1e0
[   56.548646]  [<ffffffff81167ad2>] ? do_init_module+0x27/0x1da
[   56.555058]  [<ffffffff81167b0b>] do_init_module+0x60/0x1da
[   56.561279]  [<ffffffff810ef0f2>] load_module+0x1402/0x1ae0
[   56.567500]  [<ffffffff810eb970>] ? __symbol_put+0x40/0x40
[   56.573623]  [<ffffffff810ef9d9>] SYSC_finit_module+0xa9/0xd0
[   56.580035]  [<ffffffff810efa1e>] SyS_finit_module+0xe/0x10
[   56.586257]  [<ffffffff815c7432>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[   56.593444] Code: 49 83 f9 02 0f 82 67 03 00 00 b9 01 00 00 00 e8 6d 12 00 00 ba 03 00 00 00 48 8b c8 e8 d0 12 00 00 48 8b 8c 24 d0 00 00 00 33 ff <66> 89 01 48 81 39 3f 42 0f 00 ba fe 00 0
0 00 48 0f 44 fa 48 8b 
[   56.615234] RIP  [<fffffffedbb408ce>] 0xfffffffedbb408ce
[   56.621173]  RSP <ffff8808647afad0>
[   56.625063] CR2: ffffffff8106148f
[   56.628763] ---[ end trace fee09972b1382958 ]---
[   56.633914] Kernel panic - not syncing: Fatal exception
[   56.639767] Kernel Offset: disabled
[   56.643659] ---[ end Kernel panic - not syncing: Fatal exception

The bad paging request here appears to be on the:

if (efi_scratch.use_pgd)

Line of uv_call_virt.  It looks like it's having trouble accessing the
efi_scratch struct using the EFI page table.  I'm not sure why this
is an issue with callbacks from modules and not with the ones in
uv_system_init and friends.

I'll keep investigating the module issue.  Looks like we're getting
closer to sorting this out!

Let me know if you have thoughts about the way I'm getting stuff
working.  I'm thinking there's probably a better way to do this than by
copying the whole efi_call_virt macro - this was a quick and dirty
solution.

- Alex
