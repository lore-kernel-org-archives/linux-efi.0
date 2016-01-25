From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 13/17] ARM: Xen: Document UEFI support on
 Xen ARM virtual platforms
Date: Mon, 25 Jan 2016 15:59:22 +0000
Message-ID: <20160125155921.GF27372@leverpostej>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
	<1453519184-11908-14-git-send-email-zhaoshenglong@huawei.com>
	<alpine.DEB.2.02.1601251539430.9687@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1601251539430.9687@kaball.uk.xensource.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, ian.campbell@citrix.com, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@citrix.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com, Shannon Zhao <zhaoshenglong@huawei.com>, peter.huangpeng@huawei.com, Rob Herring <robh@kernel.org>, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 25, 2016 at 03:50:52PM +0000, Stefano Stabellini wrote:
> On Sat, 23 Jan 2016, Shannon Zhao wrote:
> > From: Shannon Zhao <shannon.zhao@linaro.org>
> > 
> > Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
> > scan this to get the UEFI information.
> > 
> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> > Acked-by: Rob Herring <robh@kernel.org>
> > ---
> > CC: Rob Herring <robh@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/arm/xen.txt | 34 +++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
> > index 0f7b9c2..aa69405 100644
> > --- a/Documentation/devicetree/bindings/arm/xen.txt
> > +++ b/Documentation/devicetree/bindings/arm/xen.txt
> > @@ -15,6 +15,26 @@ the following properties:
> >  - interrupts: the interrupt used by Xen to inject event notifications.
> >    A GIC node is also required.
> >  
> > +To support UEFI on Xen ARM virtual platforms, Xen populates the FDT "uefi" node
> > +under /hypervisor with following parameters:
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
> >  
> >  Example (assuming #address-cells = <2> and #size-cells = <2>):
> >  
> > @@ -22,4 +42,18 @@ hypervisor {
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
> > +The format and meaning of these "xen,uefi-*" parameters are similar to those in
> > +Documentation/arm/uefi.txt which are used by normal UEFI. But to distinguish
> > +from normal UEFI, for Xen ARM virtual platforms it needs to introduce a Xen
> > +specific UEFI which requires Xen hypervisor to provide hypercalls for Dom0 to
> > +make use of the runtime services. Therefore, it defines these parameters under
> > +/hypervisor node.
> 
> Please replace the paragraph with the following which mentions
> include/xen/interface/platform.h and improves the wording:
> 
> "The format and meaning of the "xen,uefi-*" parameters are similar to
> those in Documentation/arm/uefi.txt, which are provided by the regular
> UEFI stub. However they differ because they are provided by the Xen
> hypervisor, together with a set of UEFI runtime services implemented via
> hypercalls, see include/xen/interface/platform.h."

I would prefer if we didn't refer to Linux paths here, for the usual
rationale of keeping bindings distinct from Linux implementation
details.

Could we either drop the "see include/xen/interface/platform.h" part, or
refer to some Xen documentation?

Thanks,
Mark.
