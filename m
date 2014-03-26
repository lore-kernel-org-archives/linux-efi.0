From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v3 4/5] xen: Define EFI related stuff
Date: Wed, 26 Mar 2014 15:34:30 +0000
Message-ID: <alpine.DEB.2.02.1403261534210.2747@kaball.uk.xensource.com>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com> <1395781076-12000-5-git-send-email-daniel.kiper@oracle.com> <alpine.DEB.2.02.1403261452160.2747@kaball.uk.xensource.com> <5332FF6C02000078000027A5@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5332FF6C02000078000027A5-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Tang Liang <liang.tang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 26 Mar 2014, Jan Beulich wrote:
> >>> On 26.03.14 at 15:58, <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org> wrote:
> >> +struct xenpf_efi_runtime_call {
> >> +	uint32_t function;
> >> +    /*
> >> +     * This field is generally used for per sub-function flags (defined
> >> +     * below), except for the XEN_EFI_get_next_high_monotonic_count case,
> >> +     * where it holds the single returned value.
> >> +     */
> >> +	uint32_t misc;
> >> +	unsigned long status;
> > 
> > I realize that this is just the same as xen/include/public/platform.h,
> > but this field should be xen_ulong_t.
> 
> Care to supply a patch to the canonical header?

I will.
