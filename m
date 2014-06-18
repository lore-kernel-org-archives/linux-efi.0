From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v5 0/7] xen: Add EFI support
Date: Wed, 18 Jun 2014 15:15:41 +0100
Message-ID: <20140618141541.GM24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1402678823-24589-1-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 13 Jun, at 07:00:16PM, Daniel Kiper wrote:
> Hey,
> 
> This patch series adds EFI support for Xen dom0 guests.
> It is based on Jan Beulich and Tang Liang work. I was
> trying to take into account all previous comments,
> however, if I missed something sorry for that.
> 
> Daniel
> 
>  arch/x86/kernel/setup.c          |    4 +-
>  arch/x86/platform/efi/efi.c      |   77 ++++++++++-------
>  arch/x86/xen/enlighten.c         |   24 ++++++
>  drivers/firmware/efi/efi.c       |   26 +++---
>  drivers/xen/Kconfig              |    4 +
>  drivers/xen/Makefile             |    3 +
>  drivers/xen/efi.c                |  374 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h              |    3 +-
>  include/xen/interface/platform.h |  123 +++++++++++++++++++++++++++
>  9 files changed, 595 insertions(+), 43 deletions(-)

FWIW I'm much happier with this version than v4. There's nothing that
jumps out at me as being obviously wrong. Just a few minor cleanups
needed.

Which tree is this intended to go through? I'm more than happy to take
it through the EFI tree, particularly since it touches
include/linux/efi.h and drivers/firmware/efi/efi.c which is the core EFI
interface for all platforms.

But if it's going through the Xen tree or something, I can supply my
Acked-by's (once the aforementioned minor cleanups are taken care of).

-- 
Matt Fleming, Intel Open Source Technology Center
