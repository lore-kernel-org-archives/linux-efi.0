From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 0/2] Fix crash in cper_estatus_check()
Date: Tue, 19 Feb 2019 11:00:49 +0100
Message-ID: <2534482.fmfRlZkPUo@aspire.rjw.lan>
References: <20190128100424.30278-1-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128100424.30278-1-ross.lagerwall@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Lagerwall <ross.lagerwall@citrix.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>, Huang Ying <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

On Monday, January 28, 2019 11:04:22 AM CET Ross Lagerwall wrote:
> v2 changes:
> - Address Boris's comments.
> 
> ---
> 
> I recently encountered a crash in cper_estatus_check() when called by
> bert_init(). Patches follow to fix the problem. Note that I cannot fully
> test the patches since the hardware error record on that machine has
> been cleared.
> 
> The crash log:
> 
> [  125.666350] BUG: unable to handle kernel paging request at ffffc9004046d02c
> [  125.666503] PGD 1f6dce067 P4D 1f6dce067 PUD 1e6532067 PMD 1e3d11067 PTE 0
> [  125.666696] Oops: 0000 [#1] SMP KASAN NOPTI
> [  125.666837] CPU: 7 PID: 1 Comm: swapper/0 Not tainted 4.19.0+0 #1
> [  125.666983] Hardware name: Dell Inc. PowerEdge M520/0DW6GX, BIOS 1.8.6 08/30/2013
> [  125.667171] RIP: e030:cper_estatus_check+0x7e/0xf0
> [  125.667315] Code: 41 29 c5 48 98 48 01 c3 48 89 d8 4c 29 e0 48 39 e8 7d 4a 48 8d 7b 18 be 04 00 00 00 e8 bb 6f 9f ff 48 8d 7b 14 be 02 00 00 00 <44> 8b 73 18 e8 a9 6f 9f ff 0f b6 4b 15 44 89 ee 66 83 f9 03 19 d2
> [  125.667554] RSP: e02b:ffff8881e65efce0 EFLAGS: 00010246
> [  125.667699] RAX: fffff5200808da06 RBX: ffffc9004046d014 RCX: ffffffff8192bf25
> [  125.667849] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffc9004046d028
> [  125.668009] RBP: 0000000000000700 R08: fffff5200808da06 R09: fffff5200808da06
> [  125.668207] R10: 0000000000000001 R11: fffff5200808da05 R12: ffffc9004046cc14
> [  125.668358] R13: 0000000000000300 R14: 00000000000000c0 R15: ffffc9004046cc00
> [  125.668519] FS:  0000000000000000(0000) GS:ffff8881e77c0000(0000) knlGS:0000000000000000
> [  125.668698] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  125.668844] CR2: ffffc9004046d02c CR3: 000000000260c000 CR4: 0000000000042660
> [  125.668999] Call Trace:
> [  125.669139]  bert_init+0x21c/0x362
> [  125.669279]  ? setup_bert_disable+0x12/0x12
> [  125.669420]  ? pci_get_dev_by_id+0x57/0x70
> [  125.669560]  ? pci_get_device+0x86/0xc0
> [  125.669738]  ? pci_create_sysfs_dev_files+0x1a6/0x330
> [  125.669883]  ? setup_bert_disable+0x12/0x12
> [  125.670026]  ? set_debug_rodata+0x11/0x11
> [  125.670166]  ? do_one_initcall+0x8b/0x253
> [  125.670306]  do_one_initcall+0x8b/0x253
> [  125.670447]  ? perf_trace_initcall_level+0x250/0x250
> [  125.670592]  ? __wake_up_common+0x140/0x1d0
> [  125.670736]  ? kasan_unpoison_shadow+0x30/0x40
> [  125.670879]  ? kasan_unpoison_shadow+0x30/0x40
> [  125.671023]  ? set_debug_rodata+0x11/0x11
> [  125.671164]  kernel_init_freeable+0x269/0x304
> [  125.671346]  ? rest_init+0xc0/0xc0
> [  125.671485]  kernel_init+0xf/0x130
> [  125.671623]  ? rest_init+0xc0/0xc0
> [  125.671761]  ? rest_init+0xc0/0xc0
> [  125.671901]  ret_from_fork+0x35/0x40
> [  125.672063] Modules linked in:
> [  125.672201] CR2: ffffc9004046d02c
> [  125.672349] ---[ end trace a17cd87742b2c49e ]---
> [  125.683693] RIP: e030:cper_estatus_check+0x7e/0xf0
> [  125.683840] Code: 41 29 c5 48 98 48 01 c3 48 89 d8 4c 29 e0 48 39 e8 7d 4a 48 8d 7b 18 be 04 00 00 00 e8 bb 6f 9f ff 48 8d 7b 14 be 02 00 00 00 <44> 8b 73 18 e8 a9 6f 9f ff 0f b6 4b 15 44 89 ee 66 83 f9 03 19 d2
> [  125.684103] RSP: e02b:ffff8881e65efce0 EFLAGS: 00010246
> [  125.684247] RAX: fffff5200808da06 RBX: ffffc9004046d014 RCX: ffffffff8192bf25
> [  125.684397] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffc9004046d028
> [  125.684548] RBP: 0000000000000700 R08: fffff5200808da06 R09: fffff5200808da06
> [  125.684699] R10: 0000000000000001 R11: fffff5200808da05 R12: ffffc9004046cc14
> [  125.684850] R13: 0000000000000300 R14: 00000000000000c0 R15: ffffc9004046cc00
> [  125.685009] FS:  0000000000000000(0000) GS:ffff8881e77c0000(0000) knlGS:0000000000000000
> [  125.685224] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  125.685371] CR2: ffffc9004046d02c CR3: 000000000260c000 CR4: 0000000000042660
> [  125.685566] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> 
> Thanks,
> 
> Ross Lagerwall (2):
>   acpi/apei: Fix possible out-of-bounds access to BERT region
>   efi/cper: Fix possible out-of-bounds access
> 
>  drivers/acpi/apei/bert.c    | 23 ++++++++++-------------
>  drivers/firmware/efi/cper.c | 13 +++++++++----
>  2 files changed, 19 insertions(+), 17 deletions(-)
> 
> 

Boris, any comments here?
