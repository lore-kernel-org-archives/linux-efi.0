From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 06/13] Xen: ARM: Add support for mapping amba
 device mmio
Date: Wed, 18 Nov 2015 21:15:30 +0800
Message-ID: <564C79F2.6050708@linaro.org>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org> <1447754231-7772-7-git-send-email-shannon.zhao@linaro.org> <20151117144040.GI3003@char.us.oracle.com> <564C14CA.9080601@huawei.com> <564C6EBF.7010105@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564C6EBF.7010105-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julien Grall <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2015/11/18 20:27, Julien Grall wrote:
> On 18/11/15 06:03, Shannon Zhao wrote:
>>>
>>> What about the removal of a bus device? No need to handle that?
>>>
>> I have thought about removal before. I think there is little(or no)
>> chance for AMBA and platform bus devices to be removed. It's not like
>> the PCI devices which will be hot-unplug.
>> Maybe I'm not right. If so, it's fine to add a case to handle the removal.
>
> What about the platform device passthrough case?
>
No, it will add the platform passthrough device at booting step while 
it's only removed when Dom0 shutdowns unless it supports platform device 
hot-unplug.

> In anycase, if the AMBA platform provides a removal method, there is
> harmless to implement it.
>
Sure, as you said, it's harmless to add.

Thanks,
-- 
Shannon
