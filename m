From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v4 01/17] Xen: ACPI: Hide UART used by Xen
Date: Sat, 6 Feb 2016 11:23:07 +0100
Message-ID: <CAJZ5v0id-035AtyQ_SccPuCxD7+pa6GCgj3WBAojM+rFqssGQQ@mail.gmail.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
	<1454641552-12576-2-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454641552-12576-2-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, julien.grall@citrix.com, xen-devel@lists.xen.org, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ian.campbell@citrix.com, Shannon Zhao <shannon.zhao@linaro.org>, peter.huangpeng@huawei.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "open list:ACPI" <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 5, 2016 at 4:05 AM, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
>
> ACPI 6.0 introduces a new table STAO to list the devices which are used
> by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
> UART is used by Xen. So here it hides UART from Dom0.
>
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Well, this doesn't look right to me.

We need to find a nicer way to achieve what you want.

Thanks,
Rafael
