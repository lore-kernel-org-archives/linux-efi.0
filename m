From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v5 3/7] xen: Define EFI related stuff
Date: Mon, 16 Jun 2014 11:54:04 +0100
Message-ID: <539ECCCC.4030601@citrix.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com> <1402678823-24589-4-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402678823-24589-4-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 13/06/14 18:00, Daniel Kiper wrote:
> Define constants and structures which are needed to properly
> execute EFI related hypercall in Xen dom0.
> 
> This patch is based on Jan Beulich and Tang Liang work.
> 
> v5 - suggestions/fixes:

This version information should be after a '---' marker.

> +	struct {
> +		GUEST_HANDLE(void) name;  /* UCS-2/UTF-16 string */
> +		xen_ulong_t size;
> +		GUEST_HANDLE(void) data;
> +		struct xenpf_efi_guid {
> +			uint32_t data1;
> +			uint16_t data2;
> +			uint16_t data3;
> +			uint8_t data4[8];
> +			} vendor_guid;

Indentation looks all messed up here and in many other places.

David
