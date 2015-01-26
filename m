From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFD] efi assisted kdump
Date: Mon, 26 Jan 2015 09:08:43 -0500
Message-ID: <20150126140843.GA25559@redhat.com>
References: <20150124132637.GB2139@darkstar.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150124132637.GB2139-4/PLUo9XfK/1wF9wiOj0lkEOCMrvLtNR@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Jan 24, 2015 at 09:26:37PM +0800, Dave Young wrote:
> Hi,
> 
> Kdump has several limitations currently such as kdump kernel reboot will bypass
> device shutdown path so device drivers should reset during initialization.
> 
> * One of such problem we encounter now is the iommu
> issue, 1st kernel's on fly DMA requests cause 2nd kernel hang. There's some effort
> on this area, Zhenhua Li posted patches to resolve the intel iommu issue which is
> under review. But that is just one case there's other possible problems in the future.
> 
> * There's no serial console on most machines in the market especially for desktop
> machines and laptops. kms enabled kernel need drm layer driver for framebuffer
> console, after kernel crashing we need a console to see the 2nd kernel output
> ideally a serial console because we can not switch back to VGA mode.
> 
> ppc64 has a feature "firmware assisted kdump", see below documentation:
> Documentation/powerpc/firmware-assisted-dump.txt
> 
> In case UEFI machines I wonder if we can do similar things, basic idea is doing
> minimum thing based on original kdump process.
> 
> kernel reserve crashkernel memory during early boot
>  -> user (kdump service) save necessary informations in some way so that second
>     kernel boot can access ie. efi runtime variables or in reserved memory
>     * crashkernel memory ranges infomation
>     * collect infomations and save elf notes for 2nd kernel vmcore initialization

I think anything related to vmcore initilization can be in memory
somewhere and should not be a problem.

But we do have to think about anything which is passed in bootparams or
command line to second kenrnel with current mechanism, how will it be
passed to second kernel.

Thanks
Vivek
