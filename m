From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 06/17] Xen: ARM: Add support for mapping platform
 device mmio
Date: Thu, 7 Apr 2016 09:37:01 +0800
Message-ID: <5705B9BD.1020403@huawei.com>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org> <1459525755-36968-7-git-send-email-shannon.zhao@linaro.org> <5704FE2C.5000902@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5704FE2C.5000902-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2016/4/6 20:16, Julien Grall wrote:
>> +            gpfns[j] = XEN_PFN_DOWN(r->start) + j;
>> +            idxs[j] = XEN_PFN_DOWN(r->start) + j;
>> +        }
>> +
>> +        xatp.domid = DOMID_SELF;
>> +        xatp.size = nr;
>> +        xatp.space = XENMAPSPACE_dev_mmio;
>> +
>> +        set_xen_guest_handle(xatp.gpfns, gpfns);
>> +        set_xen_guest_handle(xatp.idxs, idxs);
>> +        set_xen_guest_handle(xatp.errs, errs);
>> +
>> +        rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
>> +        kfree(gpfns);
>> +        kfree(idxs);
>> +        kfree(errs);
>> +        if (rc)
>> +            return rc;
> 
> Shouldn't we redo the mapping if the hypercall fails?
Hmm, why? If it fails again when we redo the mapping, what should we do
then? Redo again?
I think if it fails at the first time it will always fail no matter how
many times we do.

Thanks,
-- 
Shannon
