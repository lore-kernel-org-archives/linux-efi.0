From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v10 11/17] ARM: XEN: Move xen_early_init() before
 efi_init()
Date: Wed, 6 Apr 2016 13:35:17 +0100
Message-ID: <57050285.90701@arm.com>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
 <1459525755-36968-12-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459525755-36968-12-git-send-email-shannon.zhao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>, linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com
Cc: david.vrabel@citrix.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, zhaoshenglong@huawei.com, Russell King <linux@arm.linux.org.uk>
List-Id: linux-efi@vger.kernel.org

Hi Shannon,

On 01/04/2016 16:49, Shannon Zhao wrote:
> Move xen_early_init() before efi_init(), then when calling efi_init()
> could initialize Xen specific UEFI.
>
> Check if it runs on Xen hypervisor through the flat dts.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Reviewed-by: Julien Grall <julien.grall@arm.com>

Regards,

-- 
Julien Grall
