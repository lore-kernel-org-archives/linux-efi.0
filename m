From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH v1 2/2] firmware: dmi_scan: Pass dmi_entry_point to
 kexec'ed kernel
Date: Sat, 17 Dec 2016 18:57:21 +0800
Message-ID: <20161217105721.GB6922@dhcp-128-65.nay.redhat.com>
References: <20161202195416.58953-1-andriy.shevchenko@linux.intel.com>
 <20161202195416.58953-3-andriy.shevchenko@linux.intel.com>
 <20161215122856.7d24b7a8@endymion>
 <20161216023213.GA4505@dhcp-128-65.nay.redhat.com>
 <1481890738.9552.70.camel@linux.intel.com>
 <20161216143330.69e9c8ee@endymion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161216143330.69e9c8ee@endymion>
Sender: linux-kernel-owner@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kexec@lists.infradead.org, Mika Westerberg <mika.westerberg@linux.intel.com>, Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org

Ccing efi people.

On 12/16/16 at 02:33pm, Jean Delvare wrote:
> On Fri, 16 Dec 2016 14:18:58 +0200, Andy Shevchenko wrote:
> > On Fri, 2016-12-16 at 10:32 +0800, Dave Young wrote:
> > > On 12/15/16 at 12:28pm, Jean Delvare wrote:
> > > > I am no kexec expert but this confuses me. Shouldn't the second
> > > > kernel have access to the EFI systab as the first kernel does? It
> > > > includes many more pointers than just ACPI and DMI tables, and it
> > > > would seem inconvenient to have to pass all these addresses
> > > > individually explicitly.
> > > 
> > > Yes, in modern linux kernel, kexec has the support for EFI, I think it
> > > should work naturally at least in x86_64.
> > 
> > Thanks for this good news!
> > 
> > Unfortunately Intel Galileo is 32-bit platform.
> 
> If it was done for X86_64 then maybe it can be generalized to X86?

For X86_64, we have a new way for efi runtime memmory mapping, in i386
code it still use old ioremap way. It is impossible to use same way as
the X86_64 since the virtual address space is limited.

But maybe for 32bit, kexec kernel can run in physical mode, but I'm not
sure, I would suggest Andy to do a test first with efi=noruntime for
kexec 2nd kernel.

Thanks
Dave

> 
> -- 
> Jean Delvare
> SUSE L3 Support
