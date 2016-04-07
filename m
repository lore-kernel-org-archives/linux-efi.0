From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v10 06/17] Xen: ARM: Add support for mapping platform
 device mmio
Date: Thu, 7 Apr 2016 11:32:50 +0100
Message-ID: <57063752.4020805@arm.com>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
 <1459525755-36968-7-git-send-email-shannon.zhao@linaro.org>
 <5704FE2C.5000902@arm.com> <5705B9BD.1020403@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5705B9BD.1020403@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, Shannon Zhao <shannon.zhao@linaro.org>, linux-arm-kernel@lists.infradead.org, sstabellini@kernel.org
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, peter.huangpeng@huawei.com, david.vrabel@citrix.com, xen-devel@lists.xen.org
List-Id: linux-efi@vger.kernel.org

Hi Shannon,

On 07/04/16 02:37, Shannon Zhao wrote:
>
>
> On 2016/4/6 20:16, Julien Grall wrote:
>>> +            gpfns[j] = XEN_PFN_DOWN(r->start) + j;
>>> +            idxs[j] = XEN_PFN_DOWN(r->start) + j;
>>> +        }
>>> +
>>> +        xatp.domid = DOMID_SELF;
>>> +        xatp.size = nr;
>>> +        xatp.space = XENMAPSPACE_dev_mmio;
>>> +
>>> +        set_xen_guest_handle(xatp.gpfns, gpfns);
>>> +        set_xen_guest_handle(xatp.idxs, idxs);
>>> +        set_xen_guest_handle(xatp.errs, errs);
>>> +
>>> +        rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
>>> +        kfree(gpfns);
>>> +        kfree(idxs);
>>> +        kfree(errs);
>>> +        if (rc)
>>> +            return rc;
>>
>> Shouldn't we redo the mapping if the hypercall fails?
> Hmm, why? If it fails again when we redo the mapping, what should we do
> then? Redo again?

Because the device MMIO region is left half mapped in DOM0 address space.

After having another look to your patch, if an error occurs, the 
notifier will still return NOTIFY_OK. This will lead to random data 
abort when the driver is accessing the MMIO regions as the device will 
be considered fully functional.

However, even if the notifier return NOTIFY_BAD, the function device_add 
doesn't care about the return value of blocking_notifier_call_chain. I 
think this need to be fixed.

> I think if it fails at the first time it will always fail no matter how
> many times we do.

I was speaking about the mappings that succeeded. They will unlikely 
fail during removal. If they ever fail you can just ignore the error.

Regards,

-- 
Julien Grall
