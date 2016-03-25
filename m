From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v7 01/17] Xen: ACPI: Hide UART used by Xen
Date: Fri, 25 Mar 2016 15:38:54 +0800
Message-ID: <56F4EB0E.4090009@huawei.com>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>	<1458830676-27075-2-git-send-email-shannon.zhao@linaro.org> <CAJZ5v0iGHj1Hb3s=uJ34j0m88+3xtBQhbX47got=z1Ah_=LrkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0iGHj1Hb3s=uJ34j0m88+3xtBQhbX47got=z1Ah_=LrkQ@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>, Shannon Zhao <shannon.zhao@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, stefano.stabellini@citrix.com, david.vrabel@citrix.com, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, julien.grall@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, ACPI <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org



On 2016/3/24 23:08, Rafael J. Wysocki wrote:
> On Thu, Mar 24, 2016 at 3:44 PM, Shannon Zhao <shannon.zhao@linaro.org> wrote:
>> > +static void acpi_get_spcr_uart_addr(void)
> static void __init acpi_get_spcr_uart_addr(void)
> 
> I suppose?
> 
> Apart from this it looks fine.
> 
Thanks, I'll update this one and resend it later.

-- 
Shannon

