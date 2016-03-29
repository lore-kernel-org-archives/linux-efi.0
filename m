From: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v7 13/17] ARM: Xen: Document UEFI support on Xen ARM
 virtual platforms
Date: Tue, 29 Mar 2016 18:21:35 +0100
Message-ID: <56FAB99F.5030606@arm.com>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
 <1458830676-27075-14-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458830676-27075-14-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Shannon,

On 24/03/16 14:44, Shannon Zhao wrote:
> Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
> scan this to get the UEFI information.
>
> CC: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
> ---
>   Documentation/devicetree/bindings/arm/xen.txt | 33 +++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
> index 0f7b9c2..6f83f76 100644
> --- a/Documentation/devicetree/bindings/arm/xen.txt
> +++ b/Documentation/devicetree/bindings/arm/xen.txt
> @@ -15,6 +15,26 @@ the following properties:
>   - interrupts: the interrupt used by Xen to inject event notifications.
>     A GIC node is also required.

You need to update the recent of the document based on the changes you 
made in the Xen one. See [1].

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
>   Example (assuming #address-cells = <2> and #size-cells = <2>):
>
> @@ -22,4 +42,17 @@ hypervisor {
>   	compatible = "xen,xen-4.3", "xen,xen";
>   	reg = <0 0xb0000000 0 0x20000>;
>   	interrupts = <1 15 0xf08>;
> +	uefi {
> +		xen,uefi-system-table = <0xXXXXXXXX>;
> +		xen,uefi-mmap-start = <0xXXXXXXXX>;
> +		xen,uefi-mmap-size = <0xXXXXXXXX>;
> +		xen,uefi-mmap-desc-size = <0xXXXXXXXX>;
> +		xen,uefi-mmap-desc-ver = <0xXXXXXXXX>;
> +        };
>   };
> +
> +The format and meaning of the "xen,uefi-*" parameters are similar to those in
> +Documentation/arm/uefi.txt, which are provided by the regular UEFI stub. However
> +they differ because they are provided by the Xen hypervisor, together with a set
> +of UEFI runtime services implemented via hypercalls, see
> +http://xenbits.xen.org/docs/unstable/hypercall/x86_64/include,public,platform.h.html.
>

Regards,

[1] 
http://lists.xenproject.org/archives/html/xen-devel/2016-03/msg03413.html

-- 
Julien Grall
