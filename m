From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 06/17] Xen: ARM: Add support for mapping platform
 device mmio
Date: Thu, 7 Apr 2016 19:25:40 +0800
Message-ID: <570643B4.3070502@huawei.com>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org> <1459525755-36968-7-git-send-email-shannon.zhao@linaro.org> <5704FE2C.5000902@arm.com> <5705B9BD.1020403@huawei.com> <57063752.4020805@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57063752.4020805-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2016/4/7 18:32, Julien Grall wrote:
> Hi Shannon,
> 
> On 07/04/16 02:37, Shannon Zhao wrote:
>>
>>
>> On 2016/4/6 20:16, Julien Grall wrote:
>>>> +            gpfns[j] = XEN_PFN_DOWN(r->start) + j;
>>>> +            idxs[j] = XEN_PFN_DOWN(r->start) + j;
>>>> +        }
>>>> +
>>>> +        xatp.domid = DOMID_SELF;
>>>> +        xatp.size = nr;
>>>> +        xatp.space = XENMAPSPACE_dev_mmio;
>>>> +
>>>> +        set_xen_guest_handle(xatp.gpfns, gpfns);
>>>> +        set_xen_guest_handle(xatp.idxs, idxs);
>>>> +        set_xen_guest_handle(xatp.errs, errs);
>>>> +
>>>> +        rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
>>>> +        kfree(gpfns);
>>>> +        kfree(idxs);
>>>> +        kfree(errs);
>>>> +        if (rc)
>>>> +            return rc;
>>>
>>> Shouldn't we redo the mapping if the hypercall fails?
>> Hmm, why? If it fails again when we redo the mapping, what should we do
>> then? Redo again?
> 
> Because the device MMIO region is left half mapped in DOM0 address space.
> 
> After having another look to your patch, if an error occurs, the
> notifier will still return NOTIFY_OK. This will lead to random data
> abort when the driver is accessing the MMIO regions as the device will
> be considered fully functional.
> 
> However, even if the notifier return NOTIFY_BAD, the function device_add
> doesn't care about the return value of blocking_notifier_call_chain. I
> think this need to be fixed.
> 
>> I think if it fails at the first time it will always fail no matter how
>> many times we do.
> 
> I was speaking about the mappings that succeeded. They will unlikely
> fail during removal. If they ever fail you can just ignore the error.
Ok, I see. I thought you mean that it needs to map the regions again.
But what you really mean is undoing the mappings.

Thanks,
-- 
Shannon
