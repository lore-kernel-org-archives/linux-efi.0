From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Correct ident mapping of efi old_map when
 kalsr enabled
Date: Mon, 8 May 2017 00:07:18 +0530
Message-ID: <CACi5LpOJe+dpJBeuZxm80pd0dX9-V=DQv_R3TDzFmn4Q1XA1SA@mail.gmail.com>
References: <1493294823-9315-1-git-send-email-bhe@redhat.com>
 <20170505204214.GB5225@codeblueprint.co.uk> <20170505233620.eka5md5mmnp4ituz@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170505233620.eka5md5mmnp4ituz-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, May 6, 2017 at 5:06 AM, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> On Fri, May 05, 2017 at 09:42:14PM +0100, Matt Fleming wrote:
>> (Including the folks from SGI since this was hit on a UV system)
>
> Wasn't there a BIOS fix supplied at some point which obviated the need
> to boot with efi=old_map on SGI boxes?
>

AFAICR, the bios fixes were provided only for SGI boxes with BIOS
version greater than or equal to UV2 (so upstream with recent bios
works on UV2, UV3, and UV4 hardware platforms, both with old and new
mapping, with new mapping being the default), however the UV1
platforms still use efi=old_map

Also as mentioned above since commit
caef78b6cdeddf4ad364f95910bba6b43b8eb9bf fixed the efi=old_map support
on UV systems even with new bios, they should ideally all boot up
properly in upstream both with 'nokaslr' and without 'nokaslr' in the
bootargs when efi=old_map is used.

Regards,
Bhupesh
