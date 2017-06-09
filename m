From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi: fix boot panic because of invalid bgrt image address
Date: Fri, 9 Jun 2017 08:35:25 +0000
Message-ID: <CAKv+Gu8vZBakJoqGs=z4LYZh-xudTcf3QnmsCKPhBK2OQfcAKg@mail.gmail.com>
References: <20170609082400.GA9879@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170609082400.GA9879-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 9 June 2017 at 08:24, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Maniaxx <tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> reported a kernel boot failure of below:
> (emulated the panic by using same invalid phys addr in code)
> There are also a bug in bugzilla.kernel.org:
> https://bugzilla.kernel.org/show_bug.cgi?id=195633
>
> The reported panic happens after below commit:
> 7b0a911 efi/x86: Move the EFI BGRT init code to early init code
>
> The root cause is the firmware on those machines provides invalid bgrt
> image addresses.
>
> In a kernel before above commit bgrt initializes late and use ioremap
> to map the image address. Ioremap validate the address, if it is not a
> valid physical address ioremap just fails and returns. However in current
> kernel efi bgrt initializes early and uses early_memremap which does not
> validate the image address, and kernel panic happens.
>
> According to ACPI spec the BGRT image address should fall into
> EFI_BOOT_SERVICES_DATA, see the section 5.2.22.4 of below document:
> http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf
>
> Fix this issue by validating the image address in efi_bgrt_init(). If the
> image address does not fall into any EFI_BOOT_SERVICES_DATA areas we just
> bail out.
>
> [    0.000000] BUG: unable to handle kernel paging request at ffffffffff280001
> [    0.000000] IP: efi_bgrt_init+0xfb/0x153
> [    0.000000] PGD 6e00b067
> [    0.000000] P4D 6e00b067
> [    0.000000] PUD 6e00d067
> [    0.000000] PMD 6e221067
> [    0.000000] PTE 8a08e01800000163
> [    0.000000]
> [    0.000000] Oops: 0009 [#1] SMP
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.12.0-rc4+ #135
> [    0.000000] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> [    0.000000] task: ffffffff9840f4c0 task.stack: ffffffff98400000
> [    0.000000] RIP: 0010:efi_bgrt_init+0xfb/0x153
> [    0.000000] RSP: 0000:ffffffff98403d50 EFLAGS: 00010082
> [    0.000000] RAX: ffffffffff280001 RBX: 0000000000000000 RCX: 0000000000000006
> [    0.000000] RDX: 0a08e01800001000 RSI: 8a08e01800000163 RDI: 000000000000057e
> [    0.000000] RBP: ffffffff98403d68 R08: 0000000000000041 R09: 0000000000000002
> [    0.000000] R10: 0000000000000000 R11: ffff8c063cff8fc6 R12: ffffffff981d1fb2
> [    0.000000] R13: ffffffff986b4fa0 R14: 0000000000000010 R15: 0000000000000000
> [    0.000000] FS:  0000000000000000(0000) GS:ffffffff984db000(0000) knlGS:0000000000000000
> [    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.000000] CR2: ffffffffff280001 CR3: 000000006e00a000 CR4: 00000000000406b0
> [    0.000000] Call Trace:
> [    0.000000]  ? bgrt_init+0xbc/0xbc
> [    0.000000]  acpi_parse_bgrt+0xe/0x12
> [    0.000000]  acpi_table_parse+0x89/0xb8
> [    0.000000]  acpi_boot_init+0x445/0x4e2
> [    0.000000]  ? acpi_parse_x2apic+0x79/0x79
> [    0.000000]  ? dmi_ignore_irq0_timer_override+0x33/0x33
> [    0.000000]  setup_arch+0xb63/0xc82
> [    0.000000]  ? early_idt_handler_array+0x120/0x120
> [    0.000000]  start_kernel+0xb7/0x443
> [    0.000000]  ? early_idt_handler_array+0x120/0x120
> [    0.000000]  x86_64_start_reservations+0x29/0x2b
> [    0.000000]  x86_64_start_kernel+0x154/0x177
> [    0.000000]  secondary_startup_64+0x9f/0x9f
> [    0.000000] Code: 3f ff eb 6c 48 bf 01 00 00 00 18 e0 08 0a be 06 00 00 00 e8 ef 2b fe ff 48 85 c0 75 0e 48 c7 c7 88 09 22 98 e8 e1 31 3f ff eb 45 <66> 44 8b 20 be 06 00 00 00 48 89 c7 8b 58 02 e8 91 2c fe ff 66
> [    0.000000] RIP: efi_bgrt_init+0xfb/0x153 RSP: ffffffff98403d50
> [    0.000000] CR2: ffffffffff280001
> [    0.000000] ---[ end trace 9843d3b7cbcab26a ]---
> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
>
> Fixes: 7b0a911 efi/x86: Move the EFI BGRT init code to early init code
> Reported-by: Maniaxx <tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> v1->v2: Ard: move EFI_MEMMAP checking out and improve the patchlog.

Thanks Dave. We'll get this queued as a fix.

>  drivers/firmware/efi/efi-bgrt.c |   26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>
> --- linux-x86.orig/drivers/firmware/efi/efi-bgrt.c
> +++ linux-x86/drivers/firmware/efi/efi-bgrt.c
> @@ -27,6 +27,26 @@ struct bmp_header {
>         u32 size;
>  } __packed;
>
> +static bool efi_bgrt_addr_valid(u64 addr)
> +{
> +       efi_memory_desc_t *md;
> +
> +       for_each_efi_memory_desc(md) {
> +               u64 size;
> +               u64 end;
> +
> +               if (md->type != EFI_BOOT_SERVICES_DATA)
> +                       continue;
> +
> +               size = md->num_pages << EFI_PAGE_SHIFT;
> +               end = md->phys_addr + size;
> +               if (addr >= md->phys_addr && addr < end)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
>  void __init efi_bgrt_init(struct acpi_table_header *table)
>  {
>         void *image;
> @@ -36,7 +56,7 @@ void __init efi_bgrt_init(struct acpi_ta
>         if (acpi_disabled)
>                 return;
>
> -       if (!efi_enabled(EFI_BOOT))
> +       if (!efi_enabled(EFI_MEMMAP))
>                 return;
>
>         if (table->length < sizeof(bgrt_tab)) {
> @@ -65,6 +85,10 @@ void __init efi_bgrt_init(struct acpi_ta
>                 goto out;
>         }
>
> +       if (!efi_bgrt_addr_valid(bgrt->image_address)) {
> +               pr_notice("Ignoring BGRT: invalid image address\n");
> +               goto out;
> +       }
>         image = early_memremap(bgrt->image_address, sizeof(bmp_header));
>         if (!image) {
>                 pr_notice("Ignoring BGRT: failed to map image header memory\n");
