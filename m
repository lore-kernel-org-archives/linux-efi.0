From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH 06/13] Xen: ARM: Add support for mapping amba
 device mmio
Date: Tue, 17 Nov 2015 16:36:24 +0000
Message-ID: <564B5788.2070008@citrix.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
 <1447754231-7772-7-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1447754231-7772-7-git-send-email-shannon.zhao@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: shannon.zhao@linaro.org, ian.campbell@citrix.com, stefano.stabellini@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@citrix.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, hangaohuai@huawei.com, linux-efi@vger.kernel.org, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, zhaoshenglong@huawei.com, christoffer.dall@linaro.org
List-Id: linux-efi@vger.kernel.org

On 17/11/15 09:57, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add a bus_notifier for AMBA bus device in order to map the device
> mmio regions when DOM0 booting with ACPI.
[...]
> +static int xen_map_amba_device_mmio(struct amba_device *adev)
> +{
> +	int rc = 0;
> +	struct resource *r = &adev->res;
> +
> +	if (resource_type(r) == IORESOURCE_MEM)
> +	{

Haven't I seen something like this before...?

This is (almost) identical to the code added for platform devices.  This
needs to be generic.

David
