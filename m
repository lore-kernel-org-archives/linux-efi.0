From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/bgrt: skip efi_bgrt_init in case non-efi boot
Date: Thu, 18 May 2017 11:12:00 +0100
Message-ID: <CAKv+Gu8xz562QbOeLL=KRgLWckQkeYGCD=fmc4XfkXLKzqhOWg@mail.gmail.com>
References: <20170516004347.GA31461@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170516004347.GA31461-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sd-y1jBWg8GRStKuXlAQpz2QA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 16 May 2017 at 01:43, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Sabrina Dubroca reported an early panic below, it was introduced by
> commit 7b0a911478c7 ("efi/x86: Move the EFI BGRT init code to early init code")
> The cause is on this machine even for legacy boot firmware still provide
> the ACPI BGRT table which should be EFI only. Thus the garbage bgrt data
> caused the efi_bgrt_init panic.
>
> Add a checking to skip efi_bgrt_init in case non EFI booting solves this
> problem.
>
> BUG: unable to handle kernel paging request at ffffffffff240001
> IP: efi_bgrt_init+0xdc/0x134
> PGD 1ac0c067
> PUD 1ac0e067
> PMD 1aee9067
> PTE 9380701800000163
>
> Oops: 0009 [#1] SMP
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper Not tainted 4.10.0-rc5-00116-g7b0a911 #19
> Hardware name: Hewlett-Packard HP Z220 CMT Workstation/1790, BIOS K51 v01.02 05/03/2012
> task: ffffffff9fc10500 task.stack: ffffffff9fc00000
> RIP: 0010:efi_bgrt_init+0xdc/0x134
> RSP: 0000:ffffffff9fc03d58 EFLAGS: 00010082
> RAX: ffffffffff240001 RBX: 0000000000000000 RCX: 1380701800000006
> RDX: 8000000000000163 RSI: 9380701800000163 RDI: 00000000000005be
> RBP: ffffffff9fc03d70 R08: 1380701800001000 R09: 0000000000000002
> R10: 000000000002d000 R11: ffff98a3dedd2fc6 R12: ffffffff9f9f22b6
> R13: ffffffff9ff49480 R14: 0000000000000010 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffffff9fd20000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffff240001 CR3: 000000001ac09000 CR4: 00000000000406b0
> Call Trace:
>  ? acpi_parse_ioapic+0x98/0x98
>  acpi_parse_bgrt+0x9/0xd
>  acpi_table_parse+0x7a/0xa9
>  acpi_boot_init+0x3c7/0x4f9
>  ? acpi_parse_x2apic+0x74/0x74
>  ? acpi_parse_x2apic_nmi+0x46/0x46
>  setup_arch+0xb4b/0xc6f
>  ? printk+0x52/0x6e
>  start_kernel+0xb2/0x47b
>  ? early_idt_handler_array+0x120/0x120
>  x86_64_start_reservations+0x24/0x26
>  x86_64_start_kernel+0xf7/0x11a
>  start_cpu+0x14/0x14
> Code: 48 c7 c7 10 16 a0 9f e8 4e 94 40 ff eb 62 be 06 00 00 00 e8 f9 ff 00 00 48 85 c0 75 0e 48
> c7 c7 40 16 a0 9f e8 31 94 40 ff eb 45 <66> 44 8b 20 be 06 00 00 00 48 89 c7 8b 58 02 e8 87 00
> 01 00 66
> RIP: efi_bgrt_init+0xdc/0x134 RSP: ffffffff9fc03d58
> CR2: ffffffffff240001
> ---[ end trace f68728a0d3053b52 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
>
> Fixes: 7b0a911478c7 ("efi/x86: Move the EFI BGRT init code to early init code")
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: Sabrina Dubroca <sd-y1jBWg8GRStKuXlAQpz2QA@public.gmane.org>
> ---
>  drivers/firmware/efi/efi-bgrt.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
> index 04ca876..8bf2732 100644
> --- a/drivers/firmware/efi/efi-bgrt.c
> +++ b/drivers/firmware/efi/efi-bgrt.c
> @@ -36,6 +36,9 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
>         if (acpi_disabled)
>                 return;
>
> +       if (!efi_enabled(EFI_BOOT))
> +               return;
> +
>         if (table->length < sizeof(bgrt_tab)) {
>                 pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
>                        table->length, sizeof(bgrt_tab));
> --
> 2.10.2
>

Applied, thanks.
