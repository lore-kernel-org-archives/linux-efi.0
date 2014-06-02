From: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: Fix compiler warnings (unused, const, type)
Date: Mon, 2 Jun 2014 12:31:20 +0100
Message-ID: <CAL01qpuXkAw+87vZ-j4c3tu5qyj7sPdJXA+F4aP-O_XPpc=5JA@mail.gmail.com>
References: <1401705066-2808-1-git-send-email-catalin.marinas@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401705066-2808-1-git-send-email-catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2 June 2014 11:31, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> This patch fixes a few compiler warning in the efi code for unused
> variable, discarding const qualifier and wrong pointer type:
>
> drivers/firmware/efi/fdt.c|66 col 22| warning: unused variable =E2=80=
=98name=E2=80=99 [-Wunused-variable]
> drivers/firmware/efi/efi.c|368 col 3| warning: passing argument 3 of =
=E2=80=98of_get_flat_dt_prop=E2=80=99 from incompatible pointer type [e=
nabled by default]
> drivers/firmware/efi/efi.c|368 col 8| warning: assignment discards =E2=
=80=98const=E2=80=99 qualifier from pointer target type [enabled by def=
ault]
>
> Signed-off-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> ---
>
> Matt,
>
> Unless you have fixed these already, please consider applying (warnin=
gs in
> latest next/master branch).

Thanks, applied to arm64-efi.
