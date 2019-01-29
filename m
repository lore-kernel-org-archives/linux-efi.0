From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v2 2/2] efi: x86: convert x86 EFI earlyprintk into generic
 earlycon implementation
Date: Tue, 29 Jan 2019 14:37:05 +0100
Message-ID: <0ea153fd-1c2b-c4e6-54d9-e31189f1b90c@suse.de>
References: <20190129092150.15184-1-ard.biesheuvel@linaro.org>
 <20190129092150.15184-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190129092150.15184-3-ard.biesheuvel@linaro.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org
Cc: graeme.gregory@linaro.org, linux-doc@vger.kernel.org, pjones@redhat.com, corbet@lwn.net, leif.lindholm@linaro.org, mingo@redhat.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On 01/29/2019 10:21 AM, Ard Biesheuvel wrote:
> Move the x86 EFI earlyprintk implementation to a shared location under
> drivers/firmware and tweak it slightly so we can expose it as an earlycon
> implementation (which is generic) rather than earlyprintk (which is only
> implemented for a few architectures)
>
> This also involves switching to write-combine mappings by default (which
> is required on ARM since device mappings lack memory semantics, and so
> memcpy/memset may not be used on them), and adding support for shared
> memory framebuffers on cache coherent non-x86 systems (which do not
> tolerate mismatched attributes)
>
> Note that 32-bit ARM does not populate its struct screen_info early
> enough for earlycon=efifb to work, so it is disabled there.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>   Documentation/admin-guide/kernel-parameters.txt |   8 +-
>   arch/x86/Kconfig.debug                          |  10 -
>   arch/x86/include/asm/efi.h                      |   1 -
>   arch/x86/kernel/early_printk.c                  |   4 -
>   arch/x86/platform/efi/Makefile                  |   1 -
>   arch/x86/platform/efi/early_printk.c            | 240 --------------------
>   drivers/firmware/efi/Kconfig                    |   6 +
>   drivers/firmware/efi/Makefile                   |   1 +
>   drivers/firmware/efi/earlycon.c                 | 208 +++++++++++++++++
>   9 files changed, 222 insertions(+), 257 deletions(-)
>

[...]

> +static int __init efi_earlycon_setup(struct earlycon_device *device,
> +				     const char *opt)
> +{
> +	struct screen_info *si;
> +	u16 xres, yres;
> +	u32 i;
> +
> +	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
> +		return -ENODEV;
> +
> +	fb_base = screen_info.lfb_base;
> +	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> +		fb_base |= (u64)screen_info.ext_lfb_base << 32;
> +
> +	if (opt && !strcmp(opt, "ram"))
> +		fb_prot = PAGE_KERNEL;
> +	else
> +		fb_prot = pgprot_writecombine(PAGE_KERNEL);

Can you determine the default from the UEFI memory map?

Also, doesn't the current logic map it as WC on x86 too? Is that 
intentional?


Alex

> +
> +	si = &screen_info;
> +	xres = si->lfb_width;
> +	yres = si->lfb_height;
> +
> +	/*
> +	 * efi_earlycon_write_char() implicitly assumes a framebuffer with
> +	 * 32-bits per pixel.
> +	 */
> +	if (si->lfb_depth != 32)
> +		return -ENODEV;
> +
> +	font = get_default_font(xres, yres, -1, -1);
> +	if (!font)
> +		return -ENODEV;
> +
> +	efi_y = rounddown(yres, font->height) - font->height;
> +	for (i = 0; i < (yres - efi_y) / font->height; i++)
> +		efi_earlycon_scroll_up();
> +
> +	device->con->write = efi_earlycon_write;
> +	return 0;
> +}
> +EARLYCON_DECLARE(efifb, efi_earlycon_setup);
