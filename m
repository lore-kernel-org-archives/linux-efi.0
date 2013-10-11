From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Date: Fri, 11 Oct 2013 09:08:14 +0200
Message-ID: <CAMuHMdV8rgy=_njpXcWuZ6zkB_Lox2k0tPJy7x1Vb7ZyGN-q5g@mail.gmail.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
	<20131010172844.GA26430@gmail.com>
	<20131010173710.GA18821@fenchurch.internal.datastacks.com>
	<20131010174521.GA27218@gmail.com>
	<20131010180937.GD18821@fenchurch.internal.datastacks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131010180937.GD18821-FS9oOTXHwv9t4tGkRPVz9tcb/sdHg95EuydrBrBl+0sAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 10, 2013 at 8:09 PM, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> INTN
> GetPixelElementSize (
> IN EFI_PIXEL_BITMASK *PixelBits
> )
> {
>         INTN HighestPixel = -1;
>         INTN BluePixel;
>         INTN RedPixel;
>         INTN GreenPixel;
>         INTN RsvdPixel;
>         BluePixel = FindHighestSetBit (PixelBits->BlueMask);
>         RedPixel = FindHighestSetBit (PixelBits->RedMask);
>         GreenPixel = FindHighestSetBit (PixelBits->GreenMask);
>         RsvdPixel = FindHighestSetBit (PixelBits->ReservedMask);
>         HighestPixel = max (BluePixel, RedPixel);
>         HighestPixel = max (HighestPixel, GreenPixel);
>         HighestPixel = max (HighestPixel, RsvdPixel);
>         return HighestPixel;
> }
> EFI_PHYSICAL_ADDRESS NewPixelAddress;
> EFI_PHYSICAL_ADDRESS CurrentPixelAddress;
> EFI_GRAPHICS_OUTPUT_MODE_INFORMATION OutputInfo;
> INTN PixelElementSize;
>
> switch (OutputInfo.PixelFormat) {
>         case PixelBitMask:
>                 PixelElementSize = GetPixelElementSize (&OutputInfo.PixelInformation);

So this can be less than 32.

>                 break;
>         case PixelBlueGreenRedReserved8BitPerColor:
>         case PixelRedGreenBlueReserved8BitPerColor:
>                 PixelElementSize = sizeof (EFI_GRAPHICS_OUTPUT_BLT_PIXEL);
>                 break;
> }
>
> Which makes this painfully clear.
>
>> Also, the main question would be, what is the typical value for
>> si->lfb_depth. 32 on almost all EFI systems? All around the map? Depends
>> on what graphics state the EFI bootloader passes us?
>
> Yes, 32 on almost all systems that implement a framebuffer console at
> all.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
