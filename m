From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] arm64/efi: Don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Sun, 27 Sep 2015 09:06:44 +0200
Message-ID: <20150927070644.GC26125@gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-3-git-send-email-matt@codeblueprint.co.uk>
 <20150926060159.GB25877@gmail.com>
 <CAKv+Gu_JRCmx5qKq7SDDq73BegVs3LKZwe+OdvTKb4YD_CURyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_JRCmx5qKq7SDDq73BegVs3LKZwe+OdvTKb4YD_CURyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> > If we allocate the EFI runtime as a single virtual memory block then issues 
> > like rounding between sections does not even come up as a problem: we map the 
> > original offsets and sizes byte by byte.
> 
> Well, by that reasoning, we should not call SetVirtualAddressMap() in the first 
> place, and just use the 1:1 mapping UEFI uses natively. This is more than 
> feasible on arm64, and I actually fought hard against using 
> SetVirtualAddressMap() at all, but I was overruled by others. I think this is 
> also trivially possible on X64, since the 1:1 mapping is already active 
> alongside the VA mapping.

Could we please re-list all the arguments pro and contra of 1:1 physical mappings, 
in a post that also explains the background so that more people can chime in, not 
just people versed in EFI internals? It's very much possible that a bad decision 
was made.

Thanks,

	Ingo
