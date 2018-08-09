From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] x86, kdump: Fix efi=noruntime NULL pointer dereference
Date: Thu, 9 Aug 2018 17:13:33 +0800
Message-ID: <20180809091333.GA8008@dhcp-128-65.nay.redhat.com>
References: <1533737025.4936.3.camel@gmx.de>
 <20180809042153.GA4377@dhcp-128-65.nay.redhat.com>
 <1533800010.5087.71.camel@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1533800010.5087.71.camel@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Baoquan He <bhe@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, lkml <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org, linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org

On 08/09/18 at 09:33am, Mike Galbraith wrote:
> On Thu, 2018-08-09 at 12:21 +0800, Dave Young wrote:
> > Hi Mike,
> > 
> > Thanks for the patch!
> > On 08/08/18 at 04:03pm, Mike Galbraith wrote:
> > > When booting with efi=noruntime, we call efi_runtime_map_copy() while
> > > loading the kdump kernel, and trip over a NULL efi.memmap.map.  Avoid
> > > that and a useless allocation when the only mapping we can use (1:1)
> > > is not available.
> > 
> > At first glance, efi_get_runtime_map_size should return 0 in case
> > noruntime.
> 
> What efi does internally at unmap time is to leave everything except
> efi.mmap.map untouched, setting it to NULL and turning off EFI_MEMMAP,
> rendering efi.mmap.map accessors useless/unsafe without first checking
> EFI_MEMMAP.

Probably the x86 efi_init should reset nr_map to zero in case runtime is
disabled.  But let's see how Ard thinks about this and cc linux-efi.

As for efi_get_runtime_map_size, it was introduced for x86 kexec use.
for copying runtime maps,  so I think it is reasonable this function
return zero in case no runtime.

Thanks
Dave
