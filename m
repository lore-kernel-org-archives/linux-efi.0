From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] x86/efi: delay efi_esrt_init to efi_late_init
Date: Tue, 16 Aug 2016 17:36:53 -0700
Message-ID: <1471394213.2608.94.camel@ranerica-desktop>
References: <1470694104-9278-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
	 <20160811102955.GB30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160811102955.GB30909-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2016-08-11 at 11:29 +0100, Matt Fleming wrote:
> Actually Ricardo, there's a slight hiccup with this patch in that
> efi_esrt_init() is now being called at very different points during
> boot.
> 
> ARM/arm64 call it at efi_init() time and the early_memremap()
> calls in the ESRT driver make sense, but those calls don't make sense
> when invoked from efi_late_init() on x86. Look how the ACPI BGRT
> driver makes use of the standard memremap() API.

Ah, I just checked. Perhaps efi_late_init is too late. Also, one
question for my knowledge, why the ESRT driver uses eary_memremap()?
Can't it uses the regular memremap as the EFI BGRT driver? As far as I
can see, it only exposes ESRT objects in sysfs.
> 
> Instead, could you fold this call into the same location as
> efi_find_mirror() and co. in x86's setup_arch()?

Sure. I just sent a v2 with your suggestion.

Thanks and BR,
Ricardo
