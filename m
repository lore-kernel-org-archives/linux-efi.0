From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v2 12/16] ARM: Xen: Document UEFI support on Xen ARM
 virtual platforms
Date: Mon, 18 Jan 2016 17:34:38 +0000
Message-ID: <alpine.DEB.2.02.1601181710270.9400@kaball.uk.xensource.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-13-git-send-email-zhaoshenglong@huawei.com>
 <20160118105115.GD21067@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160118105115.GD21067@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Jan Beulich <JBeulich-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, Ian Campbell <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 18 Jan 2016, Mark Rutland wrote:
> On Fri, Jan 15, 2016 at 02:55:25PM +0800, Shannon Zhao wrote:
> > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > 
> > Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
> > scan this to get the UEFI information.
> > 
> > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  Documentation/devicetree/bindings/arm/xen.txt | 42 +++++++++++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
> > index 0f7b9c2..fbc17ae 100644
> > --- a/Documentation/devicetree/bindings/arm/xen.txt
> > +++ b/Documentation/devicetree/bindings/arm/xen.txt
> > @@ -15,6 +15,36 @@ the following properties:
> >  - interrupts: the interrupt used by Xen to inject event notifications.
> >    A GIC node is also required.
> >  
> > +To support UEFI on Xen ARM virtual platforms, Xen pupulates the FDT "uefi" node
> > +under /hypervisor with following parameters:
> 
> s/pupulates/populates/
> 
> > +
> > +________________________________________________________________________________
> > +Name                      | Size   | Description
> > +================================================================================
> > +xen,uefi-system-table     | 64-bit | Guest physical address of the UEFI System
> > +			  |	   | Table.
> > +--------------------------------------------------------------------------------
> > +xen,uefi-mmap-start       | 64-bit | Guest physical address of the UEFI memory
> > +			  |	   | map.
> > +--------------------------------------------------------------------------------
> > +xen,uefi-mmap-size        | 32-bit | Size in bytes of the UEFI memory map
> > +                          |        | pointed to in previous entry.
> > +--------------------------------------------------------------------------------
> > +xen,uefi-mmap-desc-size   | 32-bit | Size in bytes of each entry in the UEFI
> > +                          |        | memory map.
> > +--------------------------------------------------------------------------------
> > +xen,uefi-mmap-desc-ver    | 32-bit | Version of the mmap descriptor format.
> > +--------------------------------------------------------------------------------
> > +
> > +Below is the format of the mmap descriptor.
> > +typedef struct {
> > +	u32 type;
> > +	u32 pad;
> > +	u64 phys_addr;
> > +	u64 virt_addr;
> > +	u64 num_pages;
> > +	u64 attribute;
> > +} efi_memory_desc_t;
> 
> I don't think we should describe this here, as it duplicates the UEFI
> spec, and is techincally incorrect the above is only guaranteed to be
> the prefix of each memory descriptor -- that's why the
> uefi-mmap-desc-size property exists.
> 
> We don't do this in Documentation/arm/uefi.txt, and I don't see why we
> should do so here.
> 
> Does Xen handle arbitrary size memory map descriptors? I'm not sure what
> new information might be passed in future additions to the descriptor
> format, and I'm not sure what should happen in the Dom0 case.

Xen passes to Dom0 the memory map in the same format as the native
memory map.


> >  Example (assuming #address-cells = <2> and #size-cells = <2>):
> >  
> > @@ -22,4 +52,16 @@ hypervisor {
> >  	compatible = "xen,xen-4.3", "xen,xen";
> >  	reg = <0 0xb0000000 0 0x20000>;
> >  	interrupts = <1 15 0xf08>;
> > +	uefi {
> > +		xen,uefi-system-table = <0xXXXXXXXX>;
> > +		xen,uefi-mmap-start = <0xXXXXXXXX>;
> > +		xen,uefi-mmap-size = <0xXXXXXXXX>;
> > +		xen,uefi-mmap-desc-size = <0xXXXXXXXX>;
> > +		xen,uefi-mmap-desc-ver = <0xXXXXXXXX>;
> > +        };
> >  };
> > +
> > +These "xen,uefi-*" parameters are similar to those in Documentation/arm/uefi.txt
> > +which are used by normal UEFI. But to Xen ARM virtual platforms, it needs to
> > +introduce a Xen specific UEFI and it doesn't want to mix with normal UEFI.
> > +Therefore, it defines these parameters under /hypervisor node.
> 
> Could we please describe what that actual difference is?
> 
> I know that the OS must handle a system table differently under Xen, but
> this doesn't describe what it should do.

For a reference, the hypercall interface is described in not so many words here:

include/xen/interface/platform.h
http://xenbits.xen.org/gitweb/?p=xen.git;a=blob_plain;f=xen/include/public/platform.h;hb=HEAD

However it is clear that platform.h also contains some x86 specific
calls, for example xenpf_set_processor_pminfo. It might be a good idea
to list the calls that are available on ARM64.


> I assume that the OS can handle the memory map in an identical fashion
> to when it is native. Is that true?
 
Yes, I think that's true.
