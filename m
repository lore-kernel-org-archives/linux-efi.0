From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v2 14/16] Xen: EFI: Parse DT parameters for
 Xen specific UEFI
Date: Tue, 19 Jan 2016 21:46:00 +0800
Message-ID: <569E3E18.2040003@linaro.org>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com> <1452840929-19612-15-git-send-email-zhaoshenglong@huawei.com> <alpine.DEB.2.02.1601181533010.16178@kaball.uk.xensource.com> <569E37C9.6040700@linaro.org> <20160119134318.GB26545@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119134318.GB26545@leverpostej>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2016/1/19 21:43, Mark Rutland wrote:
> On Tue, Jan 19, 2016 at 09:19:05PM +0800, Shannon Zhao wrote:
>>
>>
>> On 2016/1/18 23:41, Stefano Stabellini wrote:
>>> CC'ing Matt Fleming
>>>
>>> On Fri, 15 Jan 2016, Shannon Zhao wrote:
>>>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>> @@ -520,15 +531,28 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>>>>   				       int depth, void *data)
>>>>   {
>>>>   	struct param_info *info = data;
>>>> +	struct params *dt_params;
>>>> +	unsigned int size;
>>>>   	const void *prop;
>>>>   	void *dest;
>>>>   	u64 val;
>>>>   	int i, len;
>>>>
>>>> -	if (depth != 1 || strcmp(uname, "chosen") != 0)
>>>> -		return 0;
>>>> +	if (efi_enabled(EFI_PARAVIRT)) {
>>>> +		if (depth != 2 || strcmp(uname, "uefi") != 0)
>>>
>>> You are already introducing this check in the previous patch when
>>> setting EFI_PARAVIRT, why do this again now?  But if we need to do this
>>> check again, then, like Mark suggested, it should be done against the
>>> full path.
>>>
>> This check just wants to confirm that the current node is the "uefi"
>> node and we can parse it with xen_fdt_params now.
>
> There is no single "uefi" node as many nodes can share that name. There
> is at most a single, /hypervisor/uefi node, as that is qualified by a
> full path.
>
Sure, I will check it by full path.

> Checking the leaf node name, as above, is insufficient. For example, the
> below will be accepted:
>
> * /chosen/uefi
> * /foo/uefi
> * /not-a-hypervisor/uefi
>
> Any of these could exist in addition to a /hypervisor/uefi node, and
> could appear ealier or later in the DTB.
>
> There may be reasons to add such nodes in future, and regardless we
> should not read properties from an invalid/wrong node.
>
> Thanks,
> Mark.
>

-- 
Shannon
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
