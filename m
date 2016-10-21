From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: 4.9-rc1 boot regression, ambiguous bisect result
Date: Fri, 21 Oct 2016 16:41:29 +0100
Message-ID: <20161021154129.GH27807@codeblueprint.co.uk>
References: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
 <20161020122931.GD19876@codeblueprint.co.uk>
 <CAPcyv4hT+yQvnQzfb49FP-+vVaVKHTYEj1EjNd9Xvu0Wr8T+Bg@mail.gmail.com>
 <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 20 Oct, at 12:37:16PM, Dan Williams wrote:
> 
> I am able to build a kernel and boot the platform with the following
> set of reverts:
> 
>       Revert "x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE"
>       Revert "x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data"
>       Revert "efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()"
>       Revert "efi: Allow drivers to reserve boot services forever"

FYI, I've been able to reproduce some crash when using your EFI memory
map layout under Qemu and forcing the ESRT driver to reserve the space.

It looks like the new EFI memmap we allocate as part of the
reservation is smaller than the old one - which is backwards.

Still debugging...
