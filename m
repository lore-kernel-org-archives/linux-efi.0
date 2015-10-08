From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] UEFI stub FDT handling fixes
Date: Wed, 7 Oct 2015 19:25:57 -0700
Message-ID: <CAFECyb9MdmH=0_9JA-1c=-ggTGLR_A8d0p5T2NUwGGzhDc_XAA@mail.gmail.com>
References: <1444206929-13374-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444206929-13374-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 7, 2015 at 1:35 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This is an alternative approach to some of the issues addressed by my series
> 'arm64 UEFI early FDT handling', of which the latest version (v3) can be found
> here: http://thread.gmane.org/gmane.linux.kernel.efi/6334
>
> The issues that are addressed by the original series are:
> - when booting via UEFI, memreserve entries are removed from the device tree but
>   the /reserved-memory node is not
> - memory nodes are removed from the device tree in a way that is not officially
>   supported by the libfdt API (i.e., you cannot delete nodes while traversing
>   the tree)
> - removal of memory nodes may discard annotations (such as NUMA topology) that
>   should ideally be retained, or may corrupt the tree by discarding nodes
>   referenced by phandles.
>
> After having discussed this offline between Grant, Leif and myself, we have come
> to the [preliminary] conclusion that discarding the /reserved-memory is not the
> way to go, and we will be far better off honoring those reservations to the
> extent possible. At the same time, the /memory node binding does not contain any
> annotations, so discarding those prevents more issues than it creates as long as
> we do it cautiously.
So if/when NUMA annotations are added to the memory node, we will need
to revisit this?

>
> This series addresses both issues: it it sanity check the /reserved-memory node
> to ensure that it does not contain any reservations we will not be able to
> honor (patch #1, #2) and updates the /memory removal loop to restart from the
> root of the tree each time a /memory node is found and removed (patch #3)
>
> Ard Biesheuvel (3):
>   efi/libstub: move FDT sanity check out of allocation loop
>   efi/libstub: sanity check the /reserved-memory DT node
>   efi/libstub: fix deletion of FDT memory nodes
>
>  drivers/firmware/efi/libstub/fdt.c | 187 ++++++++++++++++++--
>  1 file changed, 169 insertions(+), 18 deletions(-)
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
