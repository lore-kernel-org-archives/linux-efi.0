From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V6 0/8] Add ARM EFI stub
Date: Mon, 13 Jan 2014 15:07:35 +0000
Message-ID: <20140113150735.GF3256@console-pimps.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389371417-379-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Jan, at 08:30:09AM, Roy Franz wrote:
> This patch series adds EFI stub support for the ARM architecture.  The 
> stub for ARM is implemented in a similar manner to x86 in that it is a 
> shim layer between EFI and the normal zImage/bzImage boot process, and 
> that an image with the stub configured is bootable as both a zImage and 
> EFI application.  This patchset adds common code that is shared with
> the ARM64 EFI stub.
> 
> This patch depends on Leif Lindholm's ARM v7 runtime services patchset, which 
> in turn depends on Mark Salter's early_io_remap() patchset.  This EFI stub 
> patchset can be tested without those by simply modifying the Kconfig for 
> EFI_STUB to not depend on EFI.  The kernel will boot using the stub, 
> however no EFI support will be available in the kernel.
> 
> I have addressed all the feedback I have recieved to date, and I am hoping 
> that this patchset is acceptable for merging into 3.14.  It has been 
> functionally stable for some time, and provides useful functionality.  
> Further consolidation of the ARM/ARM64 stubs planned as part of the 
> ongoing development of the stubs and supporting tools for both 
> architectures (getting the FDT from a UEFI configuration table, using UEFI 
> memory map instead of FDT for memory description.) 

Is this going to Linus via one of the ARM maintainer trees?

-- 
Matt Fleming, Intel Open Source Technology Center
