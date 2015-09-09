From: joeyli <jlee@suse.com>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 9 Sep 2015 08:33:07 +0800
Message-ID: <20150909003307.GJ2266@linux-rxt1.site>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
 <20150907040752.GW13182@linux-rxt1.site>
 <20150908204147.GC2854@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150908204147.GC2854@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, LeifLindholm@linux-rxt1.site, leif.lindholm@linaro.org, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@Odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

On Tue, Sep 08, 2015 at 09:41:47PM +0100, Matt Fleming wrote:
> On Mon, 07 Sep, at 12:07:52PM, joeyli wrote:
> > 
> > This patch works to me on Intel S1200V3RPS to fix issue:
> > DMI: Intel Corporation (uefidk.com) Intel Server Board S1200V3RPS UEFI Development Kit/ROMLEY, BIOS 2.0
> > 
> > Tested-by: Lee, Chun-Yi <jlee@suse.com>
> 
> When you say "fix issue", do you mean that your machine has the
> EFI_PROPERTIES_TABLE feature enabled, and that it doesn't boot without
> this patch?
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

Yes, the machine on my hand has EFI_PROPERTIES_TABLE enabled, and it doesn't
boot without your patch.

I captured similar kernel oops through serial port:

[    0.037745] ACPI: All ACPI Tables successfully acquired
[    0.044666] BUG: unable to handle kernel paging request at fffffffef0e5d450
[    0.052451] IP: [<fffffffef0e5d450>] 0xfffffffef0e5d450
[    0.058291] PGD 1c0d067 PUD 17fcfd063 PMD 17fd6f063 PTE 0
[    0.064355] Oops: 0010 [#1] SMP 
[    0.067972] Modules linked in:
[    0.071388] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.2.0-rc8-2.gc02428d-default #1
[    0.080121] Hardware name: Intel Corporation (uefidk.com) Intel Server Board S1200V3RPS UEFI Development Kit/ROMLEY, BIOS 2.0 
[    0.092827] task: ffffffff81c114c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[    0.101172] RIP: 0010:[<fffffffef0e5d450>]  [<fffffffef0e5d450>] 0xfffffffef0e5d450
[    0.109724] RSP: 0000:ffffffff81c03d38  EFLAGS: 00010082
[    0.115647] RAX: fffffffef0c5d100 RBX: fffffffef1d66040 RCX: fffffffef0c5d100
[    0.123604] RDX: 00000000be366018 RSI: 0000000000000000 RDI: ffffffff81c38b00
[    0.131560] RBP: 000000000000000c R08: ffffffff81c03d70 R09: ffffffff81c38b0b
[    0.139517] R10: 0000000000000078 R11: 0000000000000002 R12: 0000000000000296
[    0.147475] R13: ffffffff81c03eb8 R14: 0000000000000030 R15: 0000000000000007
[    0.155432] FS:  0000000000000000(0000) GS:ffff88042e600000(0000) knlGS:0000000000000000
[    0.164457] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.170864] CR2: fffffffef0e5d450 CR3: 000000000009b000 CR4: 00000000000406b0
[    0.178819] Stack:
[    0.181059]  fffffffef10574c9 0000000000000002 0000000000000000 0000000000000000
[    0.189351]  ffffffff81c38b00 0000000000000000 fffffffef1057a4b 0000000000000058
[    0.197645]  000000078000203c 000000000009b000 ffff8801ffd70000 000000000009b000
[    0.205939] Call Trace:
[    0.208669]  [<ffffffff8105dd9e>] ? efi_call+0x7e/0x100
[    0.214497]  [<ffffffff81523006>] ? virt_efi_set_variable+0x66/0x90
[    0.221487]  [<ffffffff8105cd67>] ? efi_delete_dummy_variable+0x77/0x90
[    0.228866]  [<ffffffff81d41ff5>] ? efi_enter_virtual_mode+0x3ac/0x3bb
[    0.236147]  [<ffffffff81d26f24>] ? start_kernel+0x3f4/0x484
[    0.242459]  [<ffffffff81d26120>] ? early_idt_handler_array+0x120/0x120
[    0.249835]  [<ffffffff81d26315>] ? x86_64_start_reservations+0x2a/0x2c
[    0.257212]  [<ffffffff81d26452>] ? x86_64_start_kernel+0x13b/0x14a
[    0.264200] Code:  Bad RIP value.
[    0.267916] RIP  [<fffffffef0e5d450>] 0xfffffffef0e5d450
[    0.273851]  RSP <ffffffff81c03d38>
[    0.277739] CR2: fffffffef0e5d450
[    0.281436] ---[ end trace 19be7a419bfa9401 ]---
[    0.286575] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.294049] Rebooting in 90 seconds..
[    0.299184] ACPI MEMORY or I/O RESET_REG.


Thanks a lot!
Joey Lee
