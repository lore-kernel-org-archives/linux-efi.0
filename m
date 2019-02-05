From: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Subject: RE: [PATCH 10/10] acpi: bgrt: parse BGRT to obtain BMP address before
 it gets clobbered
Date: Tue, 5 Feb 2019 19:07:07 +0000
Message-ID: <BN7PR12MB259308A068895E416766F8DEF86E0@BN7PR12MB2593.namprd12.prod.outlook.com>
References: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
 <20190202094119.13230-11-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202094119.13230-11-ard.biesheuvel@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> owner@vger.kernel.org> On Behalf Of Ard Biesheuvel
> Sent: Saturday, February 2, 2019 3:41 AM
> To: linux-efi@vger.kernel.org; Ingo Molnar <mingo@kernel.org>; Thomas
> Gleixner <tglx@linutronix.de>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-kernel@vger.kernel.=
org;
> AKASHI Takahiro <takahiro.akashi@linaro.org>; Alexander Graf
> <agraf@suse.de>; Bjorn Andersson <bjorn.andersson@linaro.org>; Borislav
> Petkov <bp@alien8.de>; Heinrich Schuchardt <xypron.glpk@gmx.de>; Jeffrey
> Hugo <jhugo@codeaurora.org>; Lee Jones <lee.jones@linaro.org>; Leif
> Lindholm <leif.lindholm@linaro.org>; Linus Torvalds <torvalds@linux-
> foundation.org>; Peter Jones <pjones@redhat.com>; Peter Zijlstra
> <peterz@infradead.org>; Sai Praneeth Prakhya
> <sai.praneeth.prakhya@intel.com>
> Subject: [PATCH 10/10] acpi: bgrt: parse BGRT to obtain BMP address befor=
e it
> gets clobbered
>=20
> The bitmap left in the framebuffer by the firmware is described by an
> ACPI table called "BGRT", which describes the size, pixel format and
> the address of a BMP image in memory. While the BGRT ACPI table is
> guaranteed to reside in a "ACPI reclaim" memory region, which is
> never touched by Linux. The BMP image, however, typically resides
> in EFI Boot Services Memory, which may have been overwritten by the
> time the BGRT discovery routine runs.
>=20
> So instead, drop the handling from the ACPI init code, and call the
> BGRT parsing code immediately after going over the EFI configuration
> table array, at which time no memory has been touched yet except for
> the .data/.bss regions covered by the static kernel image.
>=20
> Unfortunately, this involves a non-trivial amount of ACPI entry
> point and root table parsing, but we cannot rely on the normal
> ACPI infrastructure yet this early in the boot.
>=20
> Also note that we cannot take the 'acpi_disabled' global variable
> into account, since it may not have assumed the correct value yet
> (on arm64, the default value is '1' which is overridden to '0' if
> no DT description has been made available by the firmware)
>=20
> Cc: Peter Jones <pjones@redhat.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---

Hi Ard, et. al.,

I'm trying out tip/master and I find that my system panics early during boo=
t. Reverting
this patch seems to resolve the issue. Please see the trace below.

I've started debugging, but I'm not familiar with this code. Please let me =
know if you
have any ideas or if there's anything you'd like me to try.

Thanks,
Yazen

[    0.000000] Kernel panic - not syncing: ERROR: Failed to allocate 0x0000=
000000000b40 bytes below 0x0000000000000000.
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.0.0-rc5-merged-bas=
es+ #101
[    0.000000] Call Trace:
[    0.000000]  dump_stack+0x63/0x85
[    0.000000]  panic+0xfe/0x2a4
[    0.000000]  memblock_alloc_base+0x33/0x35
[    0.000000]  memblock_phys_alloc+0x10/0x12
[    0.000000]  efi_memmap_alloc+0x62/0x65
[    0.000000]  efi_arch_mem_reserve+0x10e/0x194
[    0.000000]  efi_mem_reserve+0x31/0x36
[    0.000000]  ? efi_mem_reserve+0x31/0x36
[    0.000000]  efi_bgrt_init+0x2c6/0x2e0
[    0.000000]  efi_config_parse_tables+0x1b2/0x1dd
[    0.000000]  efi_config_init+0x7b/0x9f
[    0.000000]  ? efi_config_init+0x7b/0x9f
[    0.000000]  efi_init+0x366/0x465
[    0.000000]  ? 0xffffffff87800000
[    0.000000]  setup_arch+0x42f/0xcc9
[    0.000000]  ? printk+0x52/0x6e
[    0.000000]  start_kernel+0x6c/0x516
[    0.000000]  x86_64_start_reservations+0x24/0x26
[    0.000000]  x86_64_start_kernel+0x74/0x77
[    0.000000]  secondary_startup_64+0xa4/0xb0
[    0.000000] ---[ end Kernel panic - not syncing: ERROR: Failed to alloca=
te 0x0000000000000b40 bytes below 0x0000000000000000. ]---
