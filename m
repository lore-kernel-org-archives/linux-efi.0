From: lijiang <lijiang@redhat.com>
Subject: Re: [PATCH 2/5 V6] x86/ioremap: strengthen the logic in
 early_memremap_pgprot_adjust() to adjust encryption mask
Date: Wed, 5 Sep 2018 22:04:49 +0800
Message-ID: <a09a3a21-9156-ce96-b7ef-9f7e7cda12b3@redhat.com>
References: <20180831081930.31561-1-lijiang@redhat.com>
 <20180831081930.31561-3-lijiang@redhat.com>
 <20180903024512.GA2568@dhcp-128-65.nay.redhat.com>
 <d2229538-51d5-ead7-c7e5-f4afe5b53693@redhat.com>
 <20180904004417.GA9842@dhcp-128-65.nay.redhat.com>
 <20180904012902.GB9842@dhcp-128-65.nay.redhat.com>
 <20180904015131.GA10877@dhcp-128-65.nay.redhat.com>
 <3a9ae246-0c3a-753a-41e2-f2788a882c50@redhat.com>
 <20180905064658.GA10310@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905064658.GA10310@dhcp-128-65.nay.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, ebiederm@xmission.com, joro@8bytes.org, thomas.lendacky@amd.com, kexec@lists.infradead.org, iommu@lists.linux-foundation.org, bhe@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

在 2018年09月05日 14:46, Dave Young 写道:
> [snip]
>>
>> As previously mentioned, there are also many differences between kexec and kdump. In general,
>> kexec needs to look at all of available physical memory, but kdump doesn't need.
>>
>> For kexec, kexec-tools will read /sys/firmware/memmap and recreate the e820 ranges for the 2nd
>> kernel. If it fails, will use /proc/iomem.
>>
>> For kdump, kexec-tools will read /proc/iomem and recreate the e820 ranges for kdump kernel.
>> BTW: we can not get the range of persistent memory from /proc/iomem. So e820 ranges don't contain
>> the persistent memory in kdump kernel, this is the real reason why i need to strengthen the logic
>> of adjusting memory encryption mask.
> 
> "persistent memory" is different, I think you meant about some reserved
> memory instead
> 
>>
>> If kexec-tools also use /sys/firmware/memmap for kdump(like kexec), kdump kernel can also work
>> without a fix, but the kexec-tools will have to be modified. Are you sure that you want me to
>> fix kexec-tools instead of kernel?
> 
> Yes, please fix kexec-tools to pass reserved ranges in e820, you will
> not need this patch then.
> 

This might be a kexec-tools bug, i have posted a patch for kexec-tools(please check kexec@lists.infradead.org).
Thanks.

> Thanks
> Dave
> 
