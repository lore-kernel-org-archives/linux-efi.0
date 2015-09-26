From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] arm64/efi: Don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Sat, 26 Sep 2015 08:01:59 +0200
Message-ID: <20150926060159.GB25877@gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-3-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443218539-7610-3-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> The new Properties Table feature introduced in UEFIv2.5 may split
> memory regions that cover PE/COFF memory images into separate code
> and data regions. Since these regions only differ in the type (runtime
> code vs runtime data) and the permission bits, but not in the memory
> type attributes (UC/WC/WT/WB), the spec does not require them to be
> aligned to 64 KB.
> 
> Since the relative offset of PE/COFF .text and .data segments cannot
> be changed on the fly, this means that we can no longer pad out those
> regions to be mappable using 64 KB pages.
> Unfortunately, there is no annotation in the UEFI memory map that
> identifies data regions that were split off from a code region, so we
> must apply this logic to all adjacent runtime regions whose attributes
> only differ in the permission bits.
> 
> So instead of rounding each memory region to 64 KB alignment at both
> ends, only round down regions that are not directly preceded by another
> runtime region with the same type attributes. Since the UEFI spec does
> not mandate that the memory map be sorted, this means we also need to
> sort it first.

So I think this is fundamentally wrong as well, similarly to the related x86 fix.

I think for compatibility reasons the whole 'EFI runtime image' should be mapped 
in a single go, as closely matching the EFI layouts and offsets as possible. We 
are not talking about gigabytes here, right?

Even if technically they are 'separate sections', the x86 bug shows that they 
aren't. So we should not pretend so on the Linux side either and we should not 
tear them apart (and then work hard to preserve the interdependencies, some 
declared, some hidden!).

If we allocate the EFI runtime as a single virtual memory block then issues like 
rounding between sections does not even come up as a problem: we map the original 
offsets and sizes byte by byte.

Thanks,

	Ingo
