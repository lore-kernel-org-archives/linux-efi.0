From: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64: xen: Implement EFI reset_system callback
Date: Thu, 20 Apr 2017 19:09:29 +0100
Message-ID: <66b377bd-999f-9010-8257-95f663f4ebd2@arm.com>
References: <20170405181417.15985-1-julien.grall@arm.com>
 <e5b548be-2ec3-9b4f-a456-929d5fb881ab@oracle.com>
 <b8c9c6cd-906a-2360-ca9f-d34a45258567@suse.com>
 <3f6f5853-cd08-8afc-f71a-b0c1545c7564@arm.com>
 <20170406142710.GE4372@olila.local.net-space.pl>
 <ed7f64f4-17db-e2a5-f362-b382666cbc36@suse.com>
 <20170406152040.GH4372@olila.local.net-space.pl>
 <e449f220-8db7-d58c-bdbf-47ccd6dd014b@arm.com>
 <20170406160653.GJ4372@olila.local.net-space.pl>
 <c23a6d11-cde8-7690-9676-537b5f17b967@suse.com>
 <20170406164309.GM4372@olila.local.net-space.pl>
 <b6cd0d59-9569-2958-9cc7-c971139881f4@suse.com>
 <alpine.DEB.2.10.1704181135580.31486@sstabellini-ThinkPad-X260>
 <fcc5ac4b-ed82-b5dd-a848-9ac9a3572853@suse.com>
 <alpine.DEB.2.10.1704181145420.31486@sstabellini-ThinkPad-X260>
 <b9238471-6957-8720-9c98-37a5a32776d2@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b9238471-6957-8720-9c98-37a5a32776d2-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

On 18/04/17 19:51, Juergen Gross wrote:
> On 18/04/17 20:46, Stefano Stabellini wrote:
>> On Tue, 18 Apr 2017, Juergen Gross wrote:
>>> On 18/04/17 20:37, Stefano Stabellini wrote:
>>>> On Thu, 6 Apr 2017, Juergen Gross wrote:
>>>>> On 06/04/17 18:43, Daniel Kiper wrote:
>>>>>> On Thu, Apr 06, 2017 at 06:22:44PM +0200, Juergen Gross wrote:
>>>>>>> On 06/04/17 18:06, Daniel Kiper wrote:
>>>>>>>> Hi Julien,
>>>>>>>>
>>>>>>>> On Thu, Apr 06, 2017 at 04:39:13PM +0100, Julien Grall wrote:
>>>>>>>>> Hi Daniel,
>>>>>>>>>
>>>>>>>>> On 06/04/17 16:20, Daniel Kiper wrote:
>>>>>>>>>> On Thu, Apr 06, 2017 at 04:38:24PM +0200, Juergen Gross wrote:
>>>>>>>>>>> On 06/04/17 16:27, Daniel Kiper wrote:
>>>>>>>>>>>> On Thu, Apr 06, 2017 at 09:32:32AM +0100, Julien Grall wrote:
>>>>>>>>>>>>> Hi Juergen,
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 06/04/17 07:23, Juergen Gross wrote:
>>>>>>>>>>>>>> On 05/04/17 21:49, Boris Ostrovsky wrote:
>>>>>>>>>>>>>>> On 04/05/2017 02:14 PM, Julien Grall wrote:
>>>>>>>>>>>>>>>> The x86 code has theoritically a similar issue, altought EFI does not
>>>>>>>>>>>>>>>> seem to be the preferred method. I have left it unimplemented on x86 and
>>>>>>>>>>>>>>>> CCed Linux Xen x86 maintainers to know their view here.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> (+Daniel)
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> This could be a problem for x86 as well, at least theoretically.
>>>>>>>>>>>>>>> xen_machine_power_off() may call pm_power_off(), which is efi.reset_system.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> So I think we should have a similar routine there.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> +1
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I don't see any problem with such a routine added, in contrast to
>>>>>>>>>>>>>> potential "reboots" instead of power off without it.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> So I think this dummy xen_efi_reset_system() should be added to
>>>>>>>>>>>>>> drivers/xen/efi.c instead.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I will resend the patch during day with xen_efi_reset_system moved
>>>>>>>>>>>>> to common code and implement the x86 counterpart (thought, I will
>>>>>>>>>>>>> not be able to test it).
>>>>>>>>>>>>
>>>>>>>>>>>> I think that this is ARM specific issue. On x86 machine_restart() calls
>>>>>>>>>>>> xen_restart(). Hence, everything works. So, I think that it should be
>>>>>>>>>>>> fixed only for ARM. Anyway, please CC me when you send a patch.
>>>>>>>>>>>
>>>>>>>>>>> What about xen_machine_power_off() (as stated in Boris' mail)?
>>>>>>>>>>
>>>>>>>>>> Guys what do you think about that:
>>>>>>>>>>
>>>>>>>>>> --- a/drivers/firmware/efi/reboot.c
>>>>>>>>>> +++ b/drivers/firmware/efi/reboot.c
>>>>>>>>>> @@ -55,7 +55,7 @@ static void efi_power_off(void)
>>>>>>>>>>
>>>>>>>>>> static int __init efi_shutdown_init(void)
>>>>>>>>>> {
>>>>>>>>>> -       if (!efi_enabled(EFI_RUNTIME_SERVICES))
>>>>>>>>>> +       if (!efi_enabled(EFI_RUNTIME_SERVICES) || efi_enabled(EFI_PARAVIRT))
>>>>>>>>>>                return -ENODEV;
>>>>>>>>>>
>>>>>>>>>>        if (efi_poweroff_required())
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Julien, for ARM64 please take a look at arch/arm64/kernel/efi.c:efi_poweroff_required(void).
>>>>>>>>>>
>>>>>>>>>> I hope that tweaks for both files should solve our problem.
>>>>>>>>>
>>>>>>>>> This sounds good for power off (I haven't tried to power off DOM0
>>>>>>>>> yet). But this will not solve the restart problem (see
>>>>>>>>> machine_restart in arch/arm64/kernel/process.c) which call directly
>>>>>>>>> efi_reboot.
>>>>>>>>
>>>>>>>> Hmmm... It seems to me that efi.reset_system override with empty function
>>>>>>>> in arch/arm/xen/efi.c is the best solution. So, I see three patches here.
>>>>>>>> One for drivers/firmware/efi/reboot.c, one for arch/arm/xen/efi.c and one
>>>>>>>> for arch/arm64/kernel/efi.c. Does it make sense?
>>>>>>>
>>>>>>> I still think the empty function should be in drivers/xen/efi.c and we
>>>>>>> should use it in arch/x86/xen/efi.c, too.
>>>>>>
>>>>>> If you wish we can go that way too. Though I thing that we should fix
>>>>>> drivers/firmware/efi/reboot.c:efi_shutdown_init() too. Just in case.
>>>>>
>>>>> Sure, go ahead. I won't object.
>>>>
>>>> For the Xen on ARM side, the original patch that started this thread
>>>> (20170405181417.15985-1-julien.grall-5wv7dgnIgG8@public.gmane.org) is good to go, right?
>>>>
>>>
>>> As I said: the dummy xen_efi_reset_system() should be in
>>> drivers/xen/efi.c
>>
>> OK. Who is working on it?
>
> Didn't Julien say he would do it?

Yes. I looked at bit closer to the problem mention with power off. 
xen_efi_reset_system cannot be a NOP because there may not be fallback 
alternatives (see machine_power_off in arch/arm64/kernel/process.c)

So I think we would have to translate EFI_RESET* to Xen SHUTDOWN_* and 
then call HYPERVISOR_sched_op directly.

I will send a new version soon.

Cheers,

-- 
Julien Grall
