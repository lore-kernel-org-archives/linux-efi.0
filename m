From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 07/13] ARM: Xen: Document UEFI support on Xen ARM virtual
 platforms
Date: Wed, 18 Nov 2015 14:24:22 +0800
Message-ID: <564C1996.80806@huawei.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org> <1447754231-7772-8-git-send-email-shannon.zhao@linaro.org> <20151117204457.GA31871@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151117204457.GA31871@rob-hp-laptop>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 2015/11/18 4:44, Rob Herring wrote:
> On Tue, Nov 17, 2015 at 05:57:05PM +0800, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
>> scan this to get the UEFI information.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  Documentation/devicetree/bindings/arm/xen.txt | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
>> index 0f7b9c2..c375d67 100644
>> --- a/Documentation/devicetree/bindings/arm/xen.txt
>> +++ b/Documentation/devicetree/bindings/arm/xen.txt
>> @@ -15,6 +15,24 @@ the following properties:
>>  - interrupts: the interrupt used by Xen to inject event notifications.
>>    A GIC node is also required.
>>  
>> +To support UEFI on Xen ARM virtual platforms, Xen pupulates the FDT "uefi" node
>> +under /hypervisor with following parameters:
>> +
>> +________________________________________________________________________________
>> +Name                      | Size   | Description
>> +================================================================================
>> +xen,uefi-system-table     | 64-bit | Physical address of the UEFI System Table.
>> +--------------------------------------------------------------------------------
>> +xen,uefi-mmap-start       | 64-bit | Physical address of the UEFI memory map.
>> +--------------------------------------------------------------------------------
>> +xen,uefi-mmap-size        | 32-bit | Size in bytes of the UEFI memory map
>> +                          |        | pointed to in previous entry.
>> +--------------------------------------------------------------------------------
>> +xen,uefi-mmap-desc-size   | 32-bit | Size in bytes of each entry in the UEFI
>> +                          |        | memory map.
>> +--------------------------------------------------------------------------------
>> +xen,uefi-mmap-desc-ver    | 32-bit | Version of the mmap descriptor format.
>> +--------------------------------------------------------------------------------
> 
> Why aren't you using what is already populated by UEFI as defined in 
> Documentation/arm/uefi.txt? Seems to be about the same thing.
> 

Yes, the parameters are similar. But since we can't find a good way to
use normal UEFI for Xen Dom0 on ARM(there are some aspects which are not
consistent with the UEFI spec), we have to introduce a Xen specific
UEFI. Then we want to separate this from the normal UEFI completely and
don't affect the normal use. So we add these parameter under Xenia
specific node /hypervisor.

For details of the previous discussion, look at below link:

http://lists.xenproject.org/archives/html/xen-devel/2015-09/msg03295.html

Thanks,
-- 
Shannon
