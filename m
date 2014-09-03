From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/5] beautify EFI memmap logs
Date: Wed, 3 Sep 2014 15:01:31 +0200
Message-ID: <CAKv+Gu_Yk-q0gf+EHc3EYQ=obLT2nj6Kj6qPTk678ASFEW+ZFQ@mail.gmail.com>
References: <1409743943-16934-1-git-send-email-lersek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409743943-16934-1-git-send-email-lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 3 September 2014 13:32, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> changes in v2:
> - explain with examples how the log's appearance changes, in patches 3-5
>   [Ingo]
>
> v1 blurb:
>
>> It's a pain to analyze EFI memmap logs while debugging, especially to
>> verify the memory types (an enum) and the memory attributes (a
>> bitmap). This series renders those columns human-readable, and unifies
>> their formatting between x86, ia64 and arm64.
>

Tested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
(on arm64 only)

+1 for aligning between architectures
+1 for cleaning up the output to make it more readable

The only thing I am not entirely convinced about is printing all those
memory attributes: is it really so interesting to know that region X
/can/ be configured as writeback, write through, write combining etc
etc, as most regions seem to support most attributes, yet it tells you
nothing about what the kernel ends up doing with that information. In
the arm64 case, for instance, all MEMORY_WB ranges are mapped
writeback cached, and everything else is mapped uncached.

-- 
Ard.


> Laszlo Ersek (5):
>   efi: add macro for EFI_MEMORY_UCE memory attribute
>   efi: introduce efi_md_typeattr_format()
>   x86: efi: format EFI memory type & attrs with efi_md_typeattr_format()
>   ia64: efi: format EFI memory type & attrs with
>     efi_md_typeattr_format()
>   arm64: efi: format EFI memory type & attrs with
>     efi_md_typeattr_format()
>
>  include/linux/efi.h         |  8 +++++++
>  arch/arm64/kernel/efi.c     | 26 +++++----------------
>  arch/ia64/kernel/efi.c      |  6 +++--
>  arch/x86/platform/efi/efi.c |  7 ++++--
>  drivers/firmware/efi/efi.c  | 57 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 80 insertions(+), 24 deletions(-)
>
> --
> 1.8.3.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
