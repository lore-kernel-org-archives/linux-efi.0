From: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Wed, 13 Nov 2013 15:45:03 -0700
Message-ID: <20131113224503.GB25344@anatevka.fc.hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
Reply-To: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 12, 2013 at 10:58:42AM -0800, H. Peter Anvin wrote:
> The problem with the crashkernel is that it by default has to sit very low in memory because the tools don't know if the crashkernel is me enough to sit anywhere.  That is the real fix.


The changes in 3.9 to allow crash kernel to be allocated high helps. 
But as you say, the default is still to allocate crash kernel low and
still susceptible to this problem.  So, a kdump expert can work around it.
But, not everyone is a kdump expert.

So, we can work to change the default, or encourage the distros
to always allocate high.  Or, we change the call to efi_reserve_boot_services
not apply to all platforms.

The problems for pre 3.9 based distros is worse as they don't have
ability to allocate crash kernel high.


Jerry


> 
> Jerry Hoemann <jerry.hoemann-VXdhtT5mjnY@public.gmane.org> wrote:
> >Some platform have firmware that violates UEFI spec and access boot
> >service
> >code or data segments after the system has called Exit Boot Services.
> >The call to efi_reserve_boot_services in setup_arch is a work around to
> >avoid using boot service memory until after the kernel has done
> >Set Virtual Map.
> >
> >However, this reservation fragments memory which can cause
> >large allocations early in boot (e.g. crash kernel) to fail.
> >
> >This patch set extends the add_efi_memmap with an optional
> >argument to specify that firmware "correctly" doesn't resuse
> >boot services memory after Exit Boot Services.
> >
> >With this information, setup_arch avoids calling
> >efi_reserve_boot_services and fragmenting memory.
> >
> >
> >Jerry Hoemann (3):
> >  efi: Early use of boot service memory
> >  x86: avoid efi_reserve_boot_services
> >  x86, efi: Early use of boot service memory
> >
> > Documentation/kernel-parameters.txt |  8 ++++++++
> > arch/x86/kernel/setup.c             |  2 +-
> > arch/x86/platform/efi/efi.c         | 13 +++++++++++--
> > include/linux/efi.h                 |  1 +
> > 4 files changed, 21 insertions(+), 3 deletions(-)
> 
> -- 
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann-VXdhtT5mjnY@public.gmane.org
----------------------------------------------------------------------------
