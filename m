From: Jeffrey Hugo <jhugo@codeaurora.org>
Subject: Re: [PATCH] efi: arm/arm64: allow SetVirtualAddressMap() to be omitted
Date: Mon, 28 Jan 2019 11:04:41 -0700
Message-ID: <abc36cf9-4fa1-da12-bb94-34d850ae34ec@codeaurora.org>
References: <20190126102207.29488-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190126102207.29488-1-ard.biesheuvel@linaro.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com, Heinrich Schuchardt <xypron.glpk@gmx.de>, will.deacon@arm.com, Alexander Graf <agraf@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, james.morse@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On 1/26/2019 3:22 AM, Ard Biesheuvel wrote:
> The UEFI spec revision 2.7 errata A section 8.4 has the following to
> say about the virtual memory runtime services:
> 
>    "This section contains function definitions for the virtual memory
>    support that may be optionally used by an operating system at runtime.
>    If an operating system chooses to make EFI runtime service calls in a
>    virtual addressing mode instead of the flat physical mode, then the
>    operating system must use the services in this section to switch the
>    EFI runtime services from flat physical addressing to virtual
>    addressing."
> 
> So it is pretty clear that calling SetVirtualAddressMap() is entirely
> optional, and so there is no point in doing so unless it achieves
> anything useful for us.
> 
> This is not the case for 64-bit ARM. The native mapping used by the OS
> is arbitrarily converted into another permutation of userland addresses
> (i.e., bits [63:48] cleared), and the runtime code could easily deal
> with the original layout in exactly the same way as it deals with the
> converted layout. However, due to constraints related to page size
> differences if the OS is not running with 4k pages, and related to
> systems that may expose the individual sections of PE/COFF runtime
> modules as different memory regions, creating the virtual layout is a
> bit fiddly, and requires us to sort the memory map and reason about
> adjacent regions with identical memory types etc etc.
> 
> So the obvious fix is to stop calling SetVirtualAddressMap() altogether
> on arm64 systems. However, to avoid surprises, which are notoriously
> hard to diagnose when it comes to OS<->firmware interactions, let's
> start by making it an opt-out feature, and implement support for the
> 'efi=novamap' kernel command line parameter on ARM and arm64 systems.
> 
> (Note that 32-bit ARM generally does require SetVirtualAddressMap() to be
> used, given that the physical memory map and the kernel virtual address
> map are not guaranteed to be non-overlapping like on arm64. However,
> having support for efi=novamap,noruntime on 32-bit ARM, combined with
> the recently proposed support for earlycon=efi, is likely to be useful
> to diagnose boot issues on such systems if they have no accessible serial
> port)
> 
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
> Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Cc: Leif Lindholm <leif.lindholm@linaro.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---

I threw this at msm8998 (arm64), and it seem to work fine as far as I 
can tell.

For what it's worth:
Tested-by: Jeffrey Hugo <jhugo@codeaurora.org>

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
