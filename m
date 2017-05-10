From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Correct ident mapping of efi old_map when
 kalsr enabled
Date: Wed, 10 May 2017 10:30:09 +0800
Message-ID: <20170510023009.GF21870@x1>
References: <1493294823-9315-1-git-send-email-bhe@redhat.com>
 <20170505204214.GB5225@codeblueprint.co.uk>
 <20170505233620.eka5md5mmnp4ituz@pd.tnic>
 <CACi5LpOJe+dpJBeuZxm80pd0dX9-V=DQv_R3TDzFmn4Q1XA1SA@mail.gmail.com>
 <20170508013649.GA2315@x1>
 <20170508152514.mc5j3lrhntd3qodj@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170508152514.mc5j3lrhntd3qodj-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 05/08/17 at 05:25pm, Borislav Petkov wrote:
> On Mon, May 08, 2017 at 09:36:49AM +0800, Baoquan He wrote:
> > Thanks for explaining, Bhupesh. 
> > 
> > BIOS issue of SGI uv1 is still not fixed. There's a quirk for uv1 to
> > use efi old map:
> > 
> > void __init efi_apply_memmap_quirks(void)
> > {
> > 	...
> > 	...
> >         /* UV2+ BIOS has a fix for this issue.  UV1 still needs the quirk. */
> >         if (dmi_check_system(sgi_uv1_dmi))
> >                 set_bit(EFI_OLD_MEMMAP, &efi.flags);
> > }
> > 
> > And because of some reasons, redhat also need efi old_map now.
> > 
> > Hi Matt,
> > 
> > This v2 patch works on my kvm guest, however there's still problem on
> > SGI system. I will post v3 later after it's handled. So nack this v2
> > patch.
> 

I have rewrote patch with p4d considered. Now with the patch applied,
nokaslr works, means the pud copying is right. While another crash
occured, from back trace it's different reason. Will arrange patch and
paste it with boot log.

Thanks
Baoquan
