From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V6 6/8] Add EFI stub for ARM
Date: Tue, 14 Jan 2014 13:29:17 -0600
Message-ID: <CAL_JsqLDVBfYomiNpFRacku4pJ3TrFy4rKJKedGp+LPGQt4m0w@mail.gmail.com>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
	<1389371417-379-7-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389371417-379-7-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Linaro Patches <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave P Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 10, 2014 at 10:30 AM, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
> operates similarly to the x86 stub: it is a shim between the EFI firmware
> and the normal zImage entry point, and sets up the environment that the
> zImage is expecting.  This includes loading the initrd (optionaly) and
> device tree from the system partition based on the kernel command line.
> The stub updates the device tree as necessary, adding entries for EFI
> runtime services. The PE/COFF "MZ" header at offset 0 results in the
> first instruction being an add that corrupts r5, which is not used by
> the zImage interface.
>
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Acked-by: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---

[snip]

> +       /* Look up the base of DRAM from the device tree. */
> +       fdt = (void *)fdt_addr;
> +       node = fdt_subnode_offset(fdt, 0, "memory");
> +       region = fdt_getprop(fdt, node, "reg", NULL);
> +       if (region) {
> +               dram_base = fdt64_to_cpu(region->base);

This will not work if the address is 32-bit size.

> +       } else {
> +               /* There is no way to get amount or addresses of physical
> +                * memory installed using EFI calls.  If the device tree
> +                * we read from disk doesn't have this, there is no way
> +                * for us to construct this informaion.
> +                */
> +               pr_efi_err(sys_table, "No 'memory' node in device tree.\n");
> +               goto fail_free_fdt;

The current pc can't be used to determine the DRAM base like AUTO_ZRELADDR?

Rob
