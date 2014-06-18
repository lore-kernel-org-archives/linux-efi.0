From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
Date: Wed, 18 Jun 2014 16:12:32 +0100
Message-ID: <20140618151232.GQ24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
 <20140618135229.GH24049@console-pimps.org>
 <53A1B726020000780001B6CF@mail.emea.novell.com>
 <alpine.DEB.2.02.1406181523340.13771@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406181523340.13771-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 18 Jun, at 03:30:25PM, Stefano Stabellini wrote:
> 
> I was thinking the same thing.
> 
> However this patch series doesn't add much code outside
> drivers/xen/efi.c and include/xen/interface/platform.h.
> I think it wouldn't be fair to ask Daniel to refactor the efi code
> currently under arch/x86 to an arch-independent location.
> Whoever comes in later and adds EFI Xen support for ARM can do that.

I agree that we shouldn't necessarily build tons of arch-independent
infrastructure when there's only one user, but it is wise to be careful
about the design decisions being made if you know there's another user
coming around the corner.

What we don't want to happen, is for the designs that we have now to
become set in stone such that they can never be changed, to the
deteriment of code duplication and maintenance.

I don't think that's happening in this patch series, but it's definitely
smart discussing this stuff upfront.

-- 
Matt Fleming, Intel Open Source Technology Center
