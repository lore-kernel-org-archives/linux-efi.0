From: Dave Young <dyoung@redhat.com>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Fri, 10 Mar 2017 09:39:45 +0800
Message-ID: <20170310013945.GA2995@dhcp-128-65.nay.redhat.com>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
 <CAKv+Gu-gRmt=Vq=QCcT5ETY9DwLzJe0f4gHR_9sFMKX7-vK++w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-gRmt=Vq=QCcT5ETY9DwLzJe0f4gHR_9sFMKX7-vK++w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Omar Sandoval <osandov@osandov.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 03/09/17 at 12:53pm, Ard Biesheuvel wrote:
> On 9 March 2017 at 10:54, Omar Sandoval <osandov@osandov.com> wrote:
> > On Thu, Mar 09, 2017 at 02:38:06PM +0800, Dave Young wrote:
> >> Add efi/kexec list.
> >>
> >> On 03/08/17 at 12:16pm, Omar Sandoval wrote:
> >
> > [snip]
> >
> >> I have no more clue yet from your provided log, but the runtime value is
> >> odd to me. It is set in below code:
> >>
> >> arch/x86/platform/efi/efi.c: efi_systab_init()
> >>       efi_systab.runtime = data ?
> >>                            (void *)(unsigned long)data->runtime :
> >>                            (void *)(unsigne long)systab64->runtime;
> >>
> >> Here data is the setup_data passed by kexec-tools from normal kernel to
> >> kexec kernel, efi_setup_data structure is like below:
> >> struct efi_setup_data {
> >>         u64 fw_vendor;
> >>         u64 runtime;
> >>         u64 tables;
> >>         u64 smbios;
> >>         u64 reserved[8];
> >> };
> >>
> >> kexec-tools get the runtime address from /sys/firmware/efi/runtime
> >>
> >> So can you do some debuggin on your side, eg. see the sysfs runtime
> >> value is correct or not. And add some printk in efi init path etc.
> >
> > The attached patch fixes this for me.
> 
> Hi Omar,
> 
> Thanks for tracking this down.
> 
> I wonder if this is an unintended side effect of the way we repurpose
> the EFI_MEMORY_RUNTIME attribute in efi_arch_mem_reserve(). AFAIUI,
> splitting memory map entries should only be necessary for regions that
> are not runtime memory regions to begin with, and so whether their
> virtual mapping address makes sense or not should be irrelevant.

In this case the esrt chunk are Runtime Data which is not necessary to
be reserved explicitly. I think efi_arch_mem_reserve are for boot areas.

Probably there could be esrt data which belongs to boot data? If we are
sure they are all runtime, the better fix may be just dropping the
efi_mem_reserve in esrt.c

> 
> Perhaps this only illustrates my lack of understanding of the x86 way
> of doing this, so perhaps Matt can shed some light on this?
> 
> Thanks,
> Ard.

Thanks
Dave
