From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v4 13/17] ARM: Xen: Document UEFI support on Xen ARM
 virtual platforms
Date: Mon, 8 Feb 2016 11:31:23 +0000
Message-ID: <alpine.DEB.2.02.1602081130480.27008@kaball.uk.xensource.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
 <1454641552-12576-14-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454641552-12576-14-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ian.campbell@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, Rob Herring <robh@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 5 Feb 2016, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
> scan this to get the UEFI information.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> Acked-by: Rob Herring <robh@kernel.org>

Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


> CC: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/arm/xen.txt | 33 +++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
> index 0f7b9c2..6f83f76 100644
> --- a/Documentation/devicetree/bindings/arm/xen.txt
> +++ b/Documentation/devicetree/bindings/arm/xen.txt
> @@ -15,6 +15,26 @@ the following properties:
>  - interrupts: the interrupt used by Xen to inject event notifications.
>    A GIC node is also required.
>  
> +To support UEFI on Xen ARM virtual platforms, Xen populates the FDT "uefi" node
> +under /hypervisor with following parameters:
> +
> +________________________________________________________________________________
> +Name                      | Size   | Description
> +================================================================================
> +xen,uefi-system-table     | 64-bit | Guest physical address of the UEFI System
> +			  |	   | Table.
> +--------------------------------------------------------------------------------
> +xen,uefi-mmap-start       | 64-bit | Guest physical address of the UEFI memory
> +			  |	   | map.
> +--------------------------------------------------------------------------------
> +xen,uefi-mmap-size        | 32-bit | Size in bytes of the UEFI memory map
> +                          |        | pointed to in previous entry.
> +--------------------------------------------------------------------------------
> +xen,uefi-mmap-desc-size   | 32-bit | Size in bytes of each entry in the UEFI
> +                          |        | memory map.
> +--------------------------------------------------------------------------------
> +xen,uefi-mmap-desc-ver    | 32-bit | Version of the mmap descriptor format.
> +--------------------------------------------------------------------------------
>  
>  Example (assuming #address-cells = <2> and #size-cells = <2>):
>  
> @@ -22,4 +42,17 @@ hypervisor {
>  	compatible = "xen,xen-4.3", "xen,xen";
>  	reg = <0 0xb0000000 0 0x20000>;
>  	interrupts = <1 15 0xf08>;
> +	uefi {
> +		xen,uefi-system-table = <0xXXXXXXXX>;
> +		xen,uefi-mmap-start = <0xXXXXXXXX>;
> +		xen,uefi-mmap-size = <0xXXXXXXXX>;
> +		xen,uefi-mmap-desc-size = <0xXXXXXXXX>;
> +		xen,uefi-mmap-desc-ver = <0xXXXXXXXX>;
> +        };
>  };
> +
> +The format and meaning of the "xen,uefi-*" parameters are similar to those in
> +Documentation/arm/uefi.txt, which are provided by the regular UEFI stub. However
> +they differ because they are provided by the Xen hypervisor, together with a set
> +of UEFI runtime services implemented via hypercalls, see
> +http://xenbits.xen.org/docs/unstable/hypercall/x86_64/include,public,platform.h.html.
