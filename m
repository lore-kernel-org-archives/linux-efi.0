From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 12/16] ARM: Xen: Document UEFI support on Xen ARM
 virtual platforms
Date: Tue, 19 Jan 2016 10:47:48 +0000
Message-ID: <20160119104747.GB25024@leverpostej>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-13-git-send-email-zhaoshenglong@huawei.com>
 <20160118105115.GD21067@leverpostej>
 <alpine.DEB.2.02.1601181710270.9400@kaball.uk.xensource.com>
 <569E0F15.8090001@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <569E0F15.8090001@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, ard.biesheuvel@linaro.org, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, Jan Beulich <JBeulich@novell.com>, Ian Campbell <Ian.Campbell@citrix.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 19, 2016 at 06:25:25PM +0800, Shannon Zhao wrote:
> 
> 
> On 2016/1/19 1:34, Stefano Stabellini wrote:
> > On Mon, 18 Jan 2016, Mark Rutland wrote:
> >> On Fri, Jan 15, 2016 at 02:55:25PM +0800, Shannon Zhao wrote:
> >>> From: Shannon Zhao <shannon.zhao@linaro.org>
> >>>
> >>> Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
> >>> scan this to get the UEFI information.
> >>>
> >>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> >>> ---
> >>>  Documentation/devicetree/bindings/arm/xen.txt | 42 +++++++++++++++++++++++++++
> >>>  1 file changed, 42 insertions(+)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
> >>> index 0f7b9c2..fbc17ae 100644
> >>> --- a/Documentation/devicetree/bindings/arm/xen.txt
> >>> +++ b/Documentation/devicetree/bindings/arm/xen.txt
> >>> @@ -15,6 +15,36 @@ the following properties:
> >>>  - interrupts: the interrupt used by Xen to inject event notifications.
> >>>    A GIC node is also required.
> >>>  
> >>> +To support UEFI on Xen ARM virtual platforms, Xen pupulates the FDT "uefi" node
> >>> +under /hypervisor with following parameters:
> >>
> >> s/pupulates/populates/
> >>
> >>> +
> >>> +________________________________________________________________________________
> >>> +Name                      | Size   | Description
> >>> +================================================================================
> >>> +xen,uefi-system-table     | 64-bit | Guest physical address of the UEFI System
> >>> +			  |	   | Table.
> >>> +--------------------------------------------------------------------------------
> >>> +xen,uefi-mmap-start       | 64-bit | Guest physical address of the UEFI memory
> >>> +			  |	   | map.
> >>> +--------------------------------------------------------------------------------
> >>> +xen,uefi-mmap-size        | 32-bit | Size in bytes of the UEFI memory map
> >>> +                          |        | pointed to in previous entry.
> >>> +--------------------------------------------------------------------------------
> >>> +xen,uefi-mmap-desc-size   | 32-bit | Size in bytes of each entry in the UEFI
> >>> +                          |        | memory map.
> >>> +--------------------------------------------------------------------------------
> >>> +xen,uefi-mmap-desc-ver    | 32-bit | Version of the mmap descriptor format.
> >>> +--------------------------------------------------------------------------------
> >>> +
> >>> +Below is the format of the mmap descriptor.
> >>> +typedef struct {
> >>> +	u32 type;
> >>> +	u32 pad;
> >>> +	u64 phys_addr;
> >>> +	u64 virt_addr;
> >>> +	u64 num_pages;
> >>> +	u64 attribute;
> >>> +} efi_memory_desc_t;
> >>
> >> I don't think we should describe this here, as it duplicates the UEFI
> >> spec, and is techincally incorrect the above is only guaranteed to be
> >> the prefix of each memory descriptor -- that's why the
> >> uefi-mmap-desc-size property exists.
> >>
> Oh, this format is suggested to describe here at previous patch set.

We can describe it by referring to the definition in the UEFI
specification (i.e. state the properties represent the return values of
EFI_BOOT_SERVICES.GetMemoryMap()).

If that's necessary at all, fix that in the usual
Documentation/arm/uefi.txt, and state here that the format and meaning
of each property here follows its unprefixed cousin, with the caveat
that Xen-specific assumptions also apply (e.g. runtime services must be
indirected via hypercalls).

Anything else is redundant and risks being wrong.

> >> We don't do this in Documentation/arm/uefi.txt, and I don't see why we
> >> should do so here.
> >>
> >> Does Xen handle arbitrary size memory map descriptors? I'm not sure what
> >> new information might be passed in future additions to the descriptor
> >> format, and I'm not sure what should happen in the Dom0 case.
> > 
> > Xen passes to Dom0 the memory map in the same format as the native
> > memory map.

Does Xen parse or modify the EFI memory map in any way?

Does it pass the raw values returned by EFI_BOOT_SERVICES.GetMemoryMap()
through to the xen,uefi-* properties, or does is make any static
assumptions about what the values will be?

I'm trying to get a feeling for what the behaviour will be if/when a
version of the EFI spec expands the memory map format.

> >>>  Example (assuming #address-cells = <2> and #size-cells = <2>):
> >>>  
> >>> @@ -22,4 +52,16 @@ hypervisor {
> >>>  	compatible = "xen,xen-4.3", "xen,xen";
> >>>  	reg = <0 0xb0000000 0 0x20000>;
> >>>  	interrupts = <1 15 0xf08>;
> >>> +	uefi {
> >>> +		xen,uefi-system-table = <0xXXXXXXXX>;
> >>> +		xen,uefi-mmap-start = <0xXXXXXXXX>;
> >>> +		xen,uefi-mmap-size = <0xXXXXXXXX>;
> >>> +		xen,uefi-mmap-desc-size = <0xXXXXXXXX>;
> >>> +		xen,uefi-mmap-desc-ver = <0xXXXXXXXX>;
> >>> +        };
> >>>  };
> >>> +
> >>> +These "xen,uefi-*" parameters are similar to those in Documentation/arm/uefi.txt
> >>> +which are used by normal UEFI. But to Xen ARM virtual platforms, it needs to
> >>> +introduce a Xen specific UEFI and it doesn't want to mix with normal UEFI.
> >>> +Therefore, it defines these parameters under /hypervisor node.
> >>
> >> Could we please describe what that actual difference is?
> >>
> >> I know that the OS must handle a system table differently under Xen, but
> >> this doesn't describe what it should do.
> > 
> > For a reference, the hypercall interface is described in not so many words here:
> > 
> > include/xen/interface/platform.h
> > http://xenbits.xen.org/gitweb/?p=xen.git;a=blob_plain;f=xen/include/public/platform.h;hb=HEAD
> > 
> > However it is clear that platform.h also contains some x86 specific
> > calls, for example xenpf_set_processor_pminfo. It might be a good idea
> > to list the calls that are available on ARM64.
> > 
> As Stefano said, I think the difference is that for Xen Dom0 the runtime
> services are worked through hypercalls not the RuntimeServices under the
> system table.

So just state that Xen-specific hypercalls are required for Dom0 to make
use of the runtime services.

That makes it clear what the major diffence is between the native case
and the Dom0 case, even if it's light on detail.

Thanks,
Mark.
