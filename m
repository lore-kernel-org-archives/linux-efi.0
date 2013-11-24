From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 0/4 v3] kexec-tools: efi runtime support
Date: Sun, 24 Nov 2013 11:12:28 +0800
Message-ID: <20131124031228.GA1754@dhcp-16-126.nay.redhat.com>
References: <20131121064043.969000753@dhcp-16-126.nay.redhat.com>
 <1385159448.1791.161.camel@misato.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385159448.1791.161.camel-RbGIw1UOYPVo/CpIj0byZw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/22/13 at 03:30pm, Toshi Kani wrote:
> On Thu, 2013-11-21 at 14:40 +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > Hi,
> > 
> > This is the v3 patchset for adding efi runtime support on kexec kernel
> > kernel patches was sent a while ago, not yet updated in archive. 
> > 
> > in kexec-tools, this patchset will do below:
> > 1. retrieve efi_info from sysfs boot_params, and fill the
> > x86 setup header. If kernel does not export sysfs boot_params,
> > still try to find them in debugfs.
> > 
> > 2. collect data efi runtime needed:
> > /sys/firmware/efi/systab: smbios
> > /sys/firmware/efi/fw_vendor
> > /sys/firmware/efi/runtime
> > /sys/firmware/efi/config_table
> > 
> > /sys/firmware/efi/runtime-map/*, the phys-virt mappings in 1st kernel
> > 
> > 3. assemble setup_data based on data get in 2) then pass it to 2nd kernel
> > 
> > Tested on OVMF, dell laptop, lenovo laptop and HP workstation
> 
> Tested on an HP EFI-based 60-way server (prototype).  For the series:

Hi, Toshi

Thanks for the testing, during my own testing this weekend I found two
issues I need to fix and improve:
1. print original memmap #ifdef EFI_DEBUG does not make sense, will add
   a patch to only print runtime maps we saved in case kexec.

2. move e820_reserve_setup_data late after parse early param and setup
   the runtime mapping, otherwise kdump kernel will complains about
   ioremap a normal ram region.

3. should change the phys_to_virt to ioremap in parse_efi_setup, also
   should fix the arch/x86/kernel/kdebugfs.c, move __va to ioremap as
   well, because kexec does not works for using memmap=exactmap in
   1st kernel, bug like below:

[    0.153726] BUG: unable to handle kernel paging request at ffff880000100008
[    0.156666] IP: [<ffffffff817beb54>] arch_kdebugfs_init+0x11a/0x201
[    0.156666] PGD 7e149067 PUD 7e14a067 PMD 7e14b067 PTE 0
[    0.156666] Oops: 0000 [#1] PREEMPT SMP 
[    0.156666] Modules linked in:
[    0.156666] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0+ #103
[    0.156666] task: ffff880037032000 ti: ffff88003706a000 task.ti: ffff88003706a000
[    0.156666] RIP: 0010:[<ffffffff817beb54>]  [<ffffffff817beb54>] arch_kdebugfs_init+0x11a/0x201
[    0.156666] RSP: 0000:ffff88003706be30  EFLAGS: 00010286
[    0.156666] RAX: ffff880037002a00 RBX: ffff880037002a00 RCX: 0000000000000b90
[    0.156666] RDX: 0000000000000000 RSI: ffffffff81673a10 RDI: ffff88003706be50
[    0.156666] RBP: ffff88003706be90 R08: ffff880037002a00 R09: ffff880037002a10
[    0.156666] R10: 0000000000000000 R11: ffffffff817beb2a R12: ffff8800364033e0
[    0.156666] R13: 0000000000100000 R14: ffff880036403000 R15: ffff880000100000
[    0.156666] FS:  0000000000000000(0000) GS:ffff880037400000(0000) knlGS:0000000000000000
[    0.156666] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.156666] CR2: ffff880000100008 CR3: 000000007d6fb000 CR4: 00000000000006f0
[    0.156666] Stack:
[    0.156666]  ffffffff8176b0b0 ffff8800364030f8 ffff8800364031f0 0000000000000000
[    0.156666]  ffff88003706be60 ffffffff8148e41d 00000000733b54fc ffffffff817bea3a
[    0.156666]  ffffffff81868d90 0000000000000000 0000000000000000 0000000000000000
[    0.156666] Call Trace:
[    0.156666]  [<ffffffff8148e41d>] ? mutex_unlock+0x9/0xb
[    0.156666]  [<ffffffff817bea3a>] ? topology_init+0x36/0x36
[    0.156666]  [<ffffffff81000296>] do_one_initcall+0xae/0x158
[    0.156666]  [<ffffffff8107750a>] ? parameq+0x1d/0x1f
[    0.156666]  [<ffffffff81077768>] ? parse_args+0x25c/0x33a
[    0.156666]  [<ffffffff817b8e96>] kernel_init_freeable+0x115/0x19b
[    0.156666]  [<ffffffff817b873d>] ? do_early_param+0x88/0x88
[    0.156666]  [<ffffffff8147bfa9>] ? rest_init+0xbd/0xbd
[    0.156666]  [<ffffffff8147bfb2>] kernel_init+0x9/0xcc
[    0.156666]  [<ffffffff81491d8c>] ret_from_fork+0x7c/0xb0
[    0.156666]  [<ffffffff8147bfa9>] ? rest_init+0xbd/0xbd
[    0.156666] Code: ff 48 85 c0 48 89 c3 0f 84 b9 00 00 00 49 bf 00 00 00 00 00 88 ff ff 4c 89 28 8b 55 bc 48 8d 7d c0 4d 01 ef 48 c7 c6 10 3a 67 81 <41> 8b 47 08 89 43 08 41 8b 47 0c 89 43 0c 31 c0 e8 2c 50 a7 ff 
[    0.156666] RIP  [<ffffffff817beb54>] arch_kdebugfs_init+0x11a/0x201
[    0.156666]  RSP <ffff88003706be30>
[    0.156666] CR2: ffff880000100008
[    0.156666] ---[ end trace 2c6f39ce0b3f50b3 ]---
[    0.156738] swapper/0 (1) used greatest stack depth: 5240 bytes left
[    0.160061] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    0.160061] 
	

I think these should be all the remain issue, I will fix them in next version.
Appreciate your testing.

Thanks
Dave
