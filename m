From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/11] efi: Permanent runtime EFI memmap support
Date: Thu, 30 Jun 2016 10:34:31 -0400
Message-ID: <20160630143431.GA2818@dhcp-128-65.nay.redhat.com>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466681690-5850-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi, Matt

On 06/23/16 at 12:34pm, Matt Fleming wrote:
> This series adds support for keeping the EFI memory map around at
> runtime for x86 (ARM and arm64 already have this support).
> 
> Additionally, drivers can now reserve EFI boot services regions such
> that they are not released back to the kernel during
> efi_free_boot_services().
> 
> With these two features it becomes possible to pass things like the
> EFI System Resource Table data structures across kexec reboot.
> 
> This series also includes a whole bunch of refactoring and cleanups to
> move code out of arch or driver-specific files into generic places.
> 
> I've given these patches some light testing, but it would be good if
> others could provide more given that this series touches so many
> different code paths.

Tested kexec/kdump and the bgrt reservation with kexec and kexec_file
system call. But due to a crypto issue I can not test signature
verification of kexec_file, but I think that is a separate problem.

For these parts:
Tested-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks
Dave
