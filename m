From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH V7 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Tue, 24 Jan 2017 17:55:32 +0000
Message-ID: <58879514.1020501@arm.com>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org> <1484244924-24786-6-git-send-email-tbaicar@codeaurora.org> <587F80A7.10008@arm.com> <3de443d7-2c68-f179-daae-bc8f851470b7@codeaurora.org> <5880FDFC.7060304@arm.com> <8b9d254a-5450-d841-baf7-5819a88043e4@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8b9d254a-5450-d841-baf7-5819a88043e4-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, Suzuki.Po
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 20/01/17 20:58, Baicar, Tyler wrote:
> On 1/19/2017 10:57 AM, James Morse wrote:
>> On 18/01/17 23:51, Baicar, Tyler wrote:
>>> On 1/18/2017 7:50 AM, James Morse wrote:
>>>> On 12/01/17 18:15, Tyler Baicar wrote:
>>>>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c

>> There are two other things that need changing to make the in_nmi() code path
>> work on arm64.
>> Always reserve the virtual-address-space forcing GHES_IOREMAP_PAGES to be 2
>> regardless of CONFIG_HAVE_ACPI_APEI_NMI. This is almost revert of
>> 594c7255dce7a13cac50cf2470cc56e2c3b0494e (but that did a few other things too).

> Looks simple enough, should I force it to 2 in all cases, or add a check for
> CONFIG_HAVE_ACPI_APEI_SEA
> similar to the check for CONFIG_HAVE_ACPI_APEI_NMI?

Its just address space not actual memory it is reserving right? I think just
reserve two pages all the time to save eye-sore #ifdefs!


>> We also need to fix ghes_ioremap_pfn_nmi() to use arch_apei_get_mem_attribute()
>> and not assume PAGE_KERNEL.

> So just change the call to ioremap_page_range to:
> 
> ioremap_page_range(vaddr, vaddr + PAGE_SIZE, pfn << PAGE_SHIFT,
> arch_apei_get_mem_attribute());

(you need to give arch_apei_get_mem_attribute() the address...) copying whatever
ghes_ioremap_pfn_irq() does a few lines down is probably best.


Thanks,

James
