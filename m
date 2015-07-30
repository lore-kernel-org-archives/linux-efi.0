From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions
 to different starting virtual address
Date: Thu, 30 Jul 2015 00:53:42 -0700
Message-ID: <55B9D806.7030705@zytor.com>
References: <1438230757-30840-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438230757-30840-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 07/29/2015 09:32 PM, Lee, Chun-Yi wrote:
> When testing hibernate, I found the EFI runtime services was broken
> on some old EFI machines on my hand, Intel DQ57TM development board
> and Acer Gateway Z5WT2 notebook.
> 
> After printing the EFI memmap and virtual address mapping on -4G area,
> found those issue machines keep the physical address of Runtime
> Data/Code regions unchanged but not Boot Data/Code. The logs were
> attached on openSUSE bug:
>     https://bugzilla.suse.com/show_bug.cgi?id=939979
> 
> Due to Boot Data/Code can be used by OS as available memory regions,
> so those old EFI BIOS do not keep the physical address of Boot regions
> unchanged. But, address of Runtime regions are the same.
> 
> On Intel DQ57TM, sometimes the order of EFI Boot regions changed. On
> Acer Gateway Z5WT2, the amount of EFI Boot regions changed.
> 
> The above changing of EFI Boot regions causes the EFI Runtime Data/Code
> may not mapping to constant virtual address, that's because the EFI Boot
> and Runtime regions are interleaved and EFI va mapping applied PMD
> 2M-aligned logic.
> 
> A workaround of this situation is mapping Boot and Runtime regions to
> different starting virtual address. Then the changing of Boot Data/Code
> regions will not affect to the virtual address mapping to Runtime
> Data/Code.
> 
> This patch adds codes for mapping Boot Data/Code regions start from
> 0xffff_ffff_0000_0000, has 1G space. And mapping Runtime Data/Code
> regions start from 0xffff_fffe_c000_0000 that has 63G space.
> 

This changelog is at least partially incomprehensive.  It also seems
more than a bit aggressive to expect that 1 GB will be sufficient forever.

	-hpa
