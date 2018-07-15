From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH 2/8] efi/x86: Use non-blocking SetVariable() for
 efi_delete_dummy_variable()
Date: Sun, 15 Jul 2018 23:49:37 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F46A3F83A@ORSMSX114.amr.corp.intel.com>
References: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
 <20180711094040.12506-3-ard.biesheuvel@linaro.org>
 <20180715223808.GB16209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180715223808.GB16209@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

> > diff --git a/arch/x86/platform/efi/quirks.c
> > b/arch/x86/platform/efi/quirks.c index 36c1f8b9f7e0..6af39dc40325
> > 100644
> > --- a/arch/x86/platform/efi/quirks.c
> > +++ b/arch/x86/platform/efi/quirks.c
> > @@ -105,12 +105,11 @@ early_param("efi_no_storage_paranoia",
> > setup_storage_paranoia);  */  void efi_delete_dummy_variable(void)  {
> > -	efi.set_variable((efi_char16_t *)efi_dummy_name,
> > -			 &EFI_DUMMY_GUID,
> > -			 EFI_VARIABLE_NON_VOLATILE |
> > -			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
> > -			 EFI_VARIABLE_RUNTIME_ACCESS,
> > -			 0, NULL);
> > +	efi.set_variable_nonblocking((efi_char16_t *)efi_dummy_name,
> > +				     &EFI_DUMMY_GUID,
> > +				     EFI_VARIABLE_NON_VOLATILE |
> > +				     EFI_VARIABLE_BOOTSERVICE_ACCESS |
> > +				     EFI_VARIABLE_RUNTIME_ACCESS, 0, NULL);
> >  }
> 
> Just wondering, what is the full stack trace of the splat? It sounds a bit surprising
> to me that such type of EFI code is used from the idle thread.

Sorry! for the confusing commit message. Kernel warns about scheduling from idle thread only when "efi_rts_wq" is
used to invoke efi_runtime_services(). So, presently, this doesn't happen on mainline kernel. Support for "efi_rts_wq"
is added by commit 3eb420e70d87 (efi: Use a work queue to invoke EFI Runtime Services).

With v4.18-rc5 kernel, the stack trace looks as below:
Please note that it's not just a warning but a kernel panic due to NULL pointer dereference.
If I remember correctly, I noticed "bad: scheduling from the idle thread!" warning during development phase (probably with v4.15 or v4.16 kernels).

[    0.075052] BUG: unable to handle kernel NULL pointer dereference at 00000000000001c2
[    0.076000] PGD 0 P4D 0 
[    0.076000] Oops: 0000 [#1] SMP PTI
[    0.076000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.18.0-rc5-efitest+ #216
[    0.076000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[    0.076000] RIP: 0010:__queue_work+0x41/0x5f0
[    0.076000] Code: fd 48 83 ec 10 8b 35 2e e2 79 01 89 7c 24 04 85 f6 74 17 65 48 8b 04 25 40 4f 01 00 8b 88 54 0c 00 00 85 c9 0f 84 b5 02 00 00 <41> f6 84 24 c2 01 00 00 01 0f 85 f7 03 00 00 48 bd eb 83 b5 80 46 
[    0.076000] RSP: 0000:ffffffff82603cf0 EFLAGS: 00010046
[    0.076000] RAX: ffffffff8262a7c0 RBX: 0000000000000246 RCX: 0000000000000000
[    0.076000] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000002000
[    0.076000] RBP: ffffffff82603da0 R08: 0000000000000000 R09: 0000000000000001
[    0.076000] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    0.076000] R13: 0000000000002000 R14: ffffffff82603da0 R15: 0000000000000000
[    0.076000] FS:  0000000000000000(0000) GS:ffff88007e000000(0000) knlGS:0000000000000000
[    0.076000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.076000] CR2: 00000000000001c2 CR3: 0000000005a24001 CR4: 00000000000606b0
[    0.076000] Call Trace:
[    0.076000]  queue_work_on+0x33/0x70
[    0.076000]  virt_efi_set_variable+0x11f/0x160
[    0.076000]  ? efi_call_virt_check_flags+0x80/0x80
[    0.076000]  efi_delete_dummy_variable+0x8c/0xb0
[    0.076000]  ? efi_enter_virtual_mode+0x42c/0x4e0
[    0.076000]  efi_enter_virtual_mode+0x42c/0x4e0
[    0.076000]  start_kernel+0x456/0x4f4
[    0.076000]  secondary_startup_64+0xa5/0xb0
[    0.076000] Modules linked in:
[    0.076000] CR2: 00000000000001c2
[    0.076000] ---[ end trace 5a03876c3be00272 ]---
[    0.076000] RIP: 0010:__queue_work+0x41/0x5f0
[    0.076000] Code: fd 48 83 ec 10 8b 35 2e e2 79 01 89 7c 24 04 85 f6 74 17 65 48 8b 04 25 40 4f 01 00 8b 88 54 0c 00 00 85 c9 0f 84 b5 02 00 00 <41> f6 84 24 c2 01 00 00 01 0f 85 f7 03 00 00 48 bd eb 83 b5 80 46 
[    0.076000] RSP: 0000:ffffffff82603cf0 EFLAGS: 00010046
[    0.076000] RAX: ffffffff8262a7c0 RBX: 0000000000000246 RCX: 0000000000000000
[    0.076000] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000002000
[    0.076000] RBP: ffffffff82603da0 R08: 0000000000000000 R09: 0000000000000001
[    0.076000] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    0.076000] R13: 0000000000002000 R14: ffffffff82603da0 R15: 0000000000000000
[    0.076000] FS:  0000000000000000(0000) GS:ffff88007e000000(0000) knlGS:0000000000000000
[    0.076000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.076000] CR2: 00000000000001c2 CR3: 0000000005a24001 CR4: 00000000000606b0
[    0.076000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.076000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

Regards,
Sai
