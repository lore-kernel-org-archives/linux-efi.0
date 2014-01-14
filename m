From: Roy Franz <roy.franz@linaro.org>
Subject: Re: [PATCH V6 0/8] Add ARM EFI stub
Date: Tue, 14 Jan 2014 11:39:40 -0800
Message-ID: <CAFECyb_EoHQSLaRcr1W0ScpnGTAS9UT0jN8DNsSELqYrLqCcNA@mail.gmail.com>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
	<20140113150735.GF3256@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140113150735.GF3256@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Matt Fleming <matt.fleming@intel.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Grant Likely <grant.likely@linaro.org>, Dave Martin <dave.martin@arm.com>, Mark Salter <msalter@redhat.com>, Patch Tracking <patches@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 13, 2014 at 7:07 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 10 Jan, at 08:30:09AM, Roy Franz wrote:
>> This patch series adds EFI stub support for the ARM architecture.  The
>> stub for ARM is implemented in a similar manner to x86 in that it is a
>> shim layer between EFI and the normal zImage/bzImage boot process, and
>> that an image with the stub configured is bootable as both a zImage and
>> EFI application.  This patchset adds common code that is shared with
>> the ARM64 EFI stub.
>>
>> This patch depends on Leif Lindholm's ARM v7 runtime services patchset, which
>> in turn depends on Mark Salter's early_io_remap() patchset.  This EFI stub
>> patchset can be tested without those by simply modifying the Kconfig for
>> EFI_STUB to not depend on EFI.  The kernel will boot using the stub,
>> however no EFI support will be available in the kernel.
>>
>> I have addressed all the feedback I have recieved to date, and I am hoping
>> that this patchset is acceptable for merging into 3.14.  It has been
>> functionally stable for some time, and provides useful functionality.
>> Further consolidation of the ARM/ARM64 stubs planned as part of the
>> ongoing development of the stubs and supporting tools for both
>> architectures (getting the FDT from a UEFI configuration table, using UEFI
>> memory map instead of FDT for memory description.)
>
> Is this going to Linus via one of the ARM maintainer trees?
>
> --
> Matt Fleming, Intel Open Source Technology Center

Hi Matt,

    Yes, this is planned to go through one of the ARM trees.  Given
that this relies on the early_io_remap
patchsets that have not been accepted yet, I don't see this being
accepted for 3.14.

Roy
