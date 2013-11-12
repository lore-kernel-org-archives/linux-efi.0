From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Tue, 12 Nov 2013 10:58:42 -0800
Message-ID: <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384222558-38527-1-git-send-email-jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jerry Hoemann <jerry.hoemann-VXdhtT5mjnY@public.gmane.org>, rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The problem with the crashkernel is that it by default has to sit very low in memory because the tools don't know if the crashkernel is me enough to sit anywhere.  That is the real fix.

Jerry Hoemann <jerry.hoemann-VXdhtT5mjnY@public.gmane.org> wrote:
>Some platform have firmware that violates UEFI spec and access boot
>service
>code or data segments after the system has called Exit Boot Services.
>The call to efi_reserve_boot_services in setup_arch is a work around to
>avoid using boot service memory until after the kernel has done
>Set Virtual Map.
>
>However, this reservation fragments memory which can cause
>large allocations early in boot (e.g. crash kernel) to fail.
>
>This patch set extends the add_efi_memmap with an optional
>argument to specify that firmware "correctly" doesn't resuse
>boot services memory after Exit Boot Services.
>
>With this information, setup_arch avoids calling
>efi_reserve_boot_services and fragmenting memory.
>
>
>Jerry Hoemann (3):
>  efi: Early use of boot service memory
>  x86: avoid efi_reserve_boot_services
>  x86, efi: Early use of boot service memory
>
> Documentation/kernel-parameters.txt |  8 ++++++++
> arch/x86/kernel/setup.c             |  2 +-
> arch/x86/platform/efi/efi.c         | 13 +++++++++++--
> include/linux/efi.h                 |  1 +
> 4 files changed, 21 insertions(+), 3 deletions(-)

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
