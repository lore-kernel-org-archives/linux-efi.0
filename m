From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [x86] [EFI stub] Changing the kernel command line in the efi
 application, without recompiling the kernel.
Date: Mon, 16 Nov 2015 09:30:41 +0000
Message-ID: <20151116093041.GA2817@codeblueprint.co.uk>
References: <CAC_FEN0qfR47ST4xewf2hc7vgH7eNm1_d-K-ZMwJWd-yNo58jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAC_FEN0qfR47ST4xewf2hc7vgH7eNm1_d-K-ZMwJWd-yNo58jg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stoppa, Igor" <igor.stoppa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 04 Nov, at 01:35:16PM, Stoppa, Igor wrote:
> Hi,
> 
> I'm currently building a combo efi application comprised of
> 
> * uefi stub from gummiboot
> * linux kernel
> * kernel command line
> * microcode + initramfs
> 
> using the approach from mkrescue-uefi.sh [1]
> 
> However I'd like to replace the gummiboot stub with the one coming
> with the kernel, and get rid of one dependency (gummiboot).
> But it seems that the command line is handled differently:
> 
> * in the gummiboot way I can change the command line without having to
> recompile the kernel, because it is contained in a separate section of
> the application.
> 
> * in the kernel-only way, it is contained in the field "load_options"
> from efi_loaded_image_t [2]
> So for what I can understand, I would have to rebuild the kernel, to
> change the command line of the combo application.
> 
> 
> Is that correct?

Nope, you don't need to rebuild your kernel image. You can simply
change the paramters passed in your EFI BootXXXX variable by the EFI
boot manager, see efibootmgr(8).

However, if you're not using the load options argument and instead are
relying on CONFG_CMDLINE, then yes, you will need to rebuild your
kernel.
