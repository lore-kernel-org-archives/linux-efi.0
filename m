From: Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH v2 1/5] ia64: add early_memremap() alias for early_ioremap()
Date: Mon, 5 Aug 2013 09:10:19 -0700
Message-ID: <CA+8MBbJwU-Wc7eHG9bqqWenkSzsv9pV5DXaU_mLkdhja1vF34g@mail.gmail.com>
References: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
	<1375462582-16423-2-git-send-email-leif.lindholm@linaro.org>
	<20130805105620.GO2515@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130805105620.GO2515@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, patches@linaro.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 5, 2013 at 3:56 AM, Matt Fleming <matt@console-pimps.org> wrote:
>> @@ -424,6 +424,7 @@ extern void __iomem * ioremap(unsigned long offset, unsigned long size);
>>  extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
>>  extern void iounmap (volatile void __iomem *addr);
>>  extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
>> +#define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
>>  extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
>>  static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
>
> Tony, can I get your Acked-by for this?

Acked-by: Tony Luck <tony.luck@intel.com>

[Cut & paste this ack to other parts of the series that touch ia64]

-Tony
