From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86, kdump: Fix efi=noruntime NULL pointer dereference
Date: Tue, 21 Aug 2018 15:39:04 +0200
Message-ID: <CAKv+Gu8KKwNkUdx7tSxEosRvydxmQ2yaasHRJn_LcHPs7p2UYQ@mail.gmail.com>
References: <1533737025.4936.3.camel@gmx.de> <20180809042153.GA4377@dhcp-128-65.nay.redhat.com>
 <1533800010.5087.71.camel@gmx.de> <20180809091333.GA8008@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180809091333.GA8008@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Baoquan He <bhe@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, lkml <linux-kernel@vger.kernel.org>, Kexec Mailing List <kexec@lists.infradead.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 9 August 2018 at 11:13, Dave Young <dyoung@redhat.com> wrote:
> On 08/09/18 at 09:33am, Mike Galbraith wrote:
>> On Thu, 2018-08-09 at 12:21 +0800, Dave Young wrote:
>> > Hi Mike,
>> >
>> > Thanks for the patch!
>> > On 08/08/18 at 04:03pm, Mike Galbraith wrote:
>> > > When booting with efi=noruntime, we call efi_runtime_map_copy() while
>> > > loading the kdump kernel, and trip over a NULL efi.memmap.map.  Avoid
>> > > that and a useless allocation when the only mapping we can use (1:1)
>> > > is not available.
>> >
>> > At first glance, efi_get_runtime_map_size should return 0 in case
>> > noruntime.
>>
>> What efi does internally at unmap time is to leave everything except
>> efi.mmap.map untouched, setting it to NULL and turning off EFI_MEMMAP,
>> rendering efi.mmap.map accessors useless/unsafe without first checking
>> EFI_MEMMAP.
>
> Probably the x86 efi_init should reset nr_map to zero in case runtime is
> disabled.  But let's see how Ard thinks about this and cc linux-efi.
>
> As for efi_get_runtime_map_size, it was introduced for x86 kexec use.
> for copying runtime maps,  so I think it is reasonable this function
> return zero in case no runtime.
>

I don't see the patch in the context so I cannot comment in great detail.

In any case, it is better to decouple EFI_MEMMAP from EFI_RUNTIME
dependencies. On x86, one may imply the other, but this is not
generally the case.

That means that efi_get_runtime_map_size() should probably check the
EFI_RUNTIME flag, and return 0 if it is cleared. Perhaps there are
other places where EFI_MEMMAP flag checks are missing, but I consider
that a separate issue.
