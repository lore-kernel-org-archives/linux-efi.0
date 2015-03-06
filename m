From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Fri, 6 Mar 2015 09:49:25 -0800
Message-ID: <CAE9FiQVux0j=3MOj1V-hAfVtbPGUCtAyzBpkQyjr8iUchFBmOg@mail.gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
	<1425456048-16236-5-git-send-email-yinghai@kernel.org>
	<20150304101649.GA3663@pd.tnic>
	<CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
	<20150304200000.GB6276@gmail.com>
	<CAE9FiQXJ-ujbhpw8phk5iQM8QFw=9QxDrXK6AdyXqDxmch_bbw@mail.gmail.com>
	<20150306133312.GC4259@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150306133312.GC4259-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 6, 2015 at 5:33 AM, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org> wrote:
> Please use checkpatch before submitting patches:
>
> WARNING: please, no spaces at the start of a line
> #71: FILE: arch/x86/kernel/setup.c:433:
> +    unsigned char *data;$
>
> WARNING: please, no spaces at the start of a line
> #72: FILE: arch/x86/kernel/setup.c:434:
> +    unsigned long offset = sizeof(struct setup_data);$
>
> WARNING: please, no spaces at the start of a line
> #74: FILE: arch/x86/kernel/setup.c:436:
> +    data = early_memremap(pa_data, offset + 1);$
>
> WARNING: please, no spaces at the start of a line
> #75: FILE: arch/x86/kernel/setup.c:437:
> +    if (!data) {$
>
> ERROR: code indent should use tabs where possible
> #76: FILE: arch/x86/kernel/setup.c:438:
> +        kaslr_enabled = true;$
>
> WARNING: please, no spaces at the start of a line
> #76: FILE: arch/x86/kernel/setup.c:438:
> +        kaslr_enabled = true;$
>
> ERROR: code indent should use tabs where possible
> #77: FILE: arch/x86/kernel/setup.c:439:
> +        return;$
>
> WARNING: please, no spaces at the start of a line
> #77: FILE: arch/x86/kernel/setup.c:439:
> +        return;$
>
> WARNING: please, no spaces at the start of a line
> #78: FILE: arch/x86/kernel/setup.c:440:
> +    }$
>
> WARNING: please, no spaces at the start of a line
> #80: FILE: arch/x86/kernel/setup.c:442:
> +    kaslr_enabled = *(data + offset);$
>
> WARNING: please, no spaces at the start of a line
> #81: FILE: arch/x86/kernel/setup.c:443:
> +    early_memunmap(data, offset + 1);$
>
> total: 2 errors, 9 warnings, 19 lines checked
>
> NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
>       scripts/cleanfile
>
> Your patch has style problems, please review.
>
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
>

That is "copy and paste" instead of attachment for easy review.
but gmail web client convert tab to spaces.
