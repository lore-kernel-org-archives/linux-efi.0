From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH] efifb: Add support for 64-bit frame buffer addresses
Date: Mon, 31 Aug 2015 22:24:31 +0200
Message-ID: <CAMuHMdU146p_vs9bfgV9n_tTkH_545hRb1qsEza=dLO=C-y69A@mail.gmail.com>
References: <1440763939-17027-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440763939-17027-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Fbdev development list <linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pete Hawkins <pete.hawkins-ZTdz3wlHnvg@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Chad Page <chad.page-ZTdz3wlHnvg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 28, 2015 at 2:12 PM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -624,7 +624,7 @@ setup_pixel_info(struct screen_info *si, u32 pixels_per_scan_line,
>  static efi_status_t
>  __gop_query32(struct efi_graphics_output_protocol_32 *gop32,
>               struct efi_graphics_output_mode_info **info,
> -             unsigned long *size, u32 *fb_base)
> +             unsigned long *size, u64 *fb_base)

phys_addr_t instead of u64?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
