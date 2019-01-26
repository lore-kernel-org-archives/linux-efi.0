From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: arm/arm64: allow SetVirtualAddressMap() to be omitted
Date: Sat, 26 Jan 2019 16:03:55 +0100
Message-ID: <CAKv+Gu-0r=8uxtKM4WzumVYnNQj6AbUhrx_ct_MOqnymgeRwAg@mail.gmail.com>
References: <20190126102207.29488-1-ard.biesheuvel@linaro.org>
 <496259a6-f277-77b3-e5d2-7d45b4f515c7@gmx.de>
 <CAKv+Gu9Cz5AW6o_FWxaGOeWsTN_AveiuNQkMhiDT5U-mZ1r91g@mail.gmail.com>
 <47E85138-58E2-434B-8D78-525DF5A2E7E0@suse.de>
 <9f44bf5c-49ce-48ef-7857-74ce9fd87f17@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <9f44bf5c-49ce-48ef-7857-74ce9fd87f17@gmx.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Alexander Graf <agraf@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 26 Jan 2019 at 15:33, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
>
> On 1/26/19 1:34 PM, Alexander Graf wrote:
> >
> >
> >> Am 26.01.2019 um 13:28 schrieb Ard Biesheuvel <ard.biesheuvel@linaro.org>:
> >>
> >>> On Sat, 26 Jan 2019 at 13:27, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> >>>
> >>>> On 1/26/19 11:22 AM, Ard Biesheuvel wrote:
> >>>> The UEFI spec revision 2.7 errata A section 8.4 has the following to
> >>>> say about the virtual memory runtime services:
> >>>>
> >>>>  "This section contains function definitions for the virtual memory
> >>>>  support that may be optionally used by an operating system at runtime.
> >>>>  If an operating system chooses to make EFI runtime service calls in a
> >>>>  virtual addressing mode instead of the flat physical mode, then the
> >>>>  operating system must use the services in this section to switch the
> >>>>  EFI runtime services from flat physical addressing to virtual
> >>>>  addressing."
> >>>>
> >>>> So it is pretty clear that calling SetVirtualAddressMap() is entirely
> >>>> optional, and so there is no point in doing so unless it achieves
> >>>> anything useful for us.
> >>>>
> >>>> This is not the case for 64-bit ARM. The native mapping used by the OS
> >>>> is arbitrarily converted into another permutation of userland addresses
> >>>> (i.e., bits [63:48] cleared), and the runtime code could easily deal
> >>>> with the original layout in exactly the same way as it deals with the
> >>>> converted layout. However, due to constraints related to page size
> >>>> differences if the OS is not running with 4k pages, and related to
> >>>> systems that may expose the individual sections of PE/COFF runtime
> >>>> modules as different memory regions, creating the virtual layout is a
> >>>> bit fiddly, and requires us to sort the memory map and reason about
> >>>> adjacent regions with identical memory types etc etc.
> >>>>
> >>>> So the obvious fix is to stop calling SetVirtualAddressMap() altogether
> >>>> on arm64 systems. However, to avoid surprises, which are notoriously
> >>>> hard to diagnose when it comes to OS<->firmware interactions, let's
> >>>> start by making it an opt-out feature, and implement support for the
> >>>> 'efi=novamap' kernel command line parameter on ARM and arm64 systems.
> >>>>
> >>>> (Note that 32-bit ARM generally does require SetVirtualAddressMap() to be
> >>>> used, given that the physical memory map and the kernel virtual address
> >>>> map are not guaranteed to be non-overlapping like on arm64. However,
> >>>> having support for efi=novamap,noruntime on 32-bit ARM, combined with
> >>>> the recently proposed support for earlycon=efi, is likely to be useful
> >>>> to diagnose boot issues on such systems if they have no accessible serial
> >>>> port)
> >>>>
> >>>
> >>> NAK
> >>>
> >>
> >> Excuse me?
> >>
> >>> This patch breaks EFI booting with any known U-Boot release.
> >>>
> >>
> >> It does if you pass 'efi=novmap'. Otherwise, it works fine.
>
> It think it would be helpful to add this information to the commit message.
>

Did you read the commit message?

> If it is strictly opt-in, I have no concern.
>

Thanks.
