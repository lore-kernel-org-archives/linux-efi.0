From: Manoj Iyer <manoj.iyer-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [3/3] arm64: Add software workaround for Falkor erratum 1041
Date: Fri, 10 Nov 2017 11:49:22 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1711101146400.4353@lazy>
References: <1509679664-3749-4-git-send-email-shankerd@codeaurora.org> <alpine.DEB.2.20.1711081305310.26324@lazy> <5A04369A.2020405@arm.com> <alpine.DEB.2.20.1711090949110.15101@lazy> <alpine.DEB.2.20.1711091010570.15101@lazy>
 <alpine.DEB.2.20.1711091041180.15101@lazy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711091041180.15101@lazy>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: Manoj Iyer <manoj.iyer-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 9 Nov 2017, Manoj Iyer wrote:

>
> James,
>
> Looks like my VM test raised a false alarm. I retested stock Artful 4.13 
> kernel (No erratum 1041 patches applied).
>

James, an update on the crash (false alarm). We suspect this is a firmware 
crash due to a possible fw bug. Once this is addressed I will be able to 
send you the test results you requested on VM start/stop with the erratum 
1041 patches applied.


> Host: Ubuntu Artful 4.13 kernel with *no* erratum 1041 patches applied.
> Guest: Ubuntu Zesty (4.10) kernel.
>
> - Created 20 VMs one at a time
>
> In a loop:
> - Stop (virsh destroy) 20 VMs one at a time
> - Start (virsh start) 20 VMs one at a time.
>
> And, I am able to reproduce the system reset issue I previously reported. I 
> think the problem I reported with VMs might have nothing to do with the 
> erratum 1041 patches, and probably needs to be root caused seperately.
>
> With stock 4.13 kernel (no erratum 1041 patches applied):
>
> awrep6 login: [  461.881379] ACPI CPPC: PCC check channel failed. Status=0
> [  462.051194] ACPI CPPC: PCC check channel failed. Status=0
> [  462.223137] ACPI CPPC: PCC check channel failed. Status=0
> [  462.633790] ACPI CPPC: PCC check channel failed. Status=0
> [  463.231971] ACPI CPPC: PCC check channel failed. Status=0
> [  463.403163] ACPI CPPC: PCC check channel failed. Status=0
> [  463.822936] ACPI CPPC: PCC check channel failed. Status=0
> [  463.995222] ACPI CPPC: PCC check channel failed. Status=0
> [  464.130962] ACPI CPPC: PCC check channel failed. Status=0
> [  464.258973] ACPI CPPC: PCC check channel failed. Status=0
> [  465.283028] ACPI CPPC: PCC check channel failed. Status=0
>
>
> SYS_DBG: Running SDI image (immediate mode)
> SYS_DBG: Ram Dump Init
> SYS_DBG: Failed to init SD card
> SYS_DBG: Resetting system!
>
>
> On Thu, 9 Nov 2017, Manoj Iyer wrote:
>
>> 
>> 
>> 
>> On Thu, 9 Nov 2017, Manoj Iyer wrote:
>> 
>>> 
>>> James,
>>> 
>>> (sorry for top-posting)
>>> 
>>> Applied patch 3 patches to Ubuntu Artful Kernel ( 4.13.0-16-generic )
>>> 
>>> - Start 20 VMs one at a time
>>> 
>>> In a loop:
>>> - Stop (virsh destroy) 20 VMs one at a time
>>> - Start (virsh start) 20 VMs one at a time.
>> 
>> Fixing some confusion I might have introduced in my prev email.
>> 
>> - Applied all 3 patches to Ubuntu Artful Kernel ( 4.13.0-16-generic )
>> 
>> - Created 20 VMs one at a time
>> 
>> In a loop:
>> - Stop (virsh destroy) 20 VMs one at a time
>> - Start (virsh start) 20 VMs one at a time.
>> 
>>> 
>>> The system reset's itself after starting the last VM on the 1st loop 
>>> displaying the following:
>>> 
>>> awrep6 login: [ 603.349141] ACPI CPPC: PCC check channel failed. Status=0
>>> [ 603.765101] ACPI CPPC: PCC check channel failed. Status=0
>>> [ 603.937389] ACPI CPPC: PCC check channel failed. Status=0
>>> [ 608.285495] ACPI CPPC: PCC check channel failed. Status=0
>>> [ 608.289481] ACPI CPPC: PCC check channel failed. Status=0
>>> 
>>> SYS_DBG: Running SDI image (immediate mode)
>>> SYS_DBG: Ram Dump Init
>>> SYS_DBG: Failed to init SD card
>>> SYS_DBG: Resetting system!
>>> 
>>> Followed by the following messages on system reboot:
>>> [ 6.616891] BERT: Error records from previous boot:
>>> [ 6.621655] [Hardware Error]: event severity: fatal
>>> [ 6.626516] [Hardware Error]: imprecise tstamp: 0000-00-00 00:00:00
>>> [ 6.632851] [Hardware Error]: Error 0, type: fatal
>>> [ 6.637713] [Hardware Error]: section type: unknown, 
>>> d2e2621c-f936-468d-0d84-15a4ed015c8b
>>> [ 6.646045] [Hardware Error]: section length: 0x238
>>> [ 6.651082] [Hardware Error]: 00000000: 72724502 5220726f 6f736165 
>>> 6e55206e .Error Reason Un
>>> [ 6.659761] [Hardware Error]: 00000010: 776f6e6b 0000006e 00000000 
>>> 00000000 known...........
>>> [ 6.668442] [Hardware Error]: 00000020: 00000000 00000000 00000000 
>>> 00000000 ................
>>> [ 6.677122] [Hardware Error]: 00000030: 00000000 00000000 00000000 
>>> 00000000 ................
>>> 
>>> 
>>> On Thu, 9 Nov 2017, James Morse wrote:
>>> 
>>>> Hi Manoj,
>>>> 
>>>> On 08/11/17 19:05, Manoj Iyer wrote:
>>>>> On Thu, 2 Nov 2017, Shanker Donthineni wrote:
>>>>>> The ARM architecture defines the memory locations that are permitted
>>>>>> to be accessed as the result of a speculative instruction fetch from
>>>>>> an exception level for which all stages of translation are disabled.
>>>>>> Specifically, the core is permitted to speculatively fetch from the
>>>>>> 4KB region containing the current program counter and next 4KB.
>>>>>> 
>>>>>> When translation is changed from enabled to disabled for the running
>>>>>> exception level (SCTLR_ELn[M] changed from a value of 1 to 0), the
>>>>>> Falkor core may errantly speculatively access memory locations outside
>>>>>> of the 4KB region permitted by the architecture. The errant memory
>>>>>> access may lead to one of the following unexpected behaviors.
>>>> 
>>>>> I applied the 3 patches to Ubuntu 4.13.0-16-generic (Artful) kernel and
>>>>> ran stress-ng cpu tests on QDF2400 server
>>>> 
>>>> [...]
>>>> 
>>>>> Where stress-ng would spawn N workers and test cpu offline/online, 
>>>>> perform
>>>>> matrix operations, do rapid context switchs, and anonymous mmaps. 
>>>>> Although
>>>>> I was not able to reproduce the erratum on the stock 4.13 kernel using 
>>>>> the
>>>>> same test case, the patched kernel did not seem to introduce any
>>>>> regressions either. I ran the stress-ng tests for over 8hrs found the
>>>>> system to be stable.
>>>> 
>>>> 
>>>> Could you throw kexec and KVM into the mix? This issue only shows up when 
>>>> we
>>>> disable the MMU, which we almost never do.
>>>> 
>>>> For CPU offline/online we make the PSCI 'offline' call with the MMU 
>>>> enabled.
>>>> When the CPU comes back firmware has reset the EL2/EL1 SCTLR from a 
>>>> higher
>>>> exception level, so it won't hit this issue.
>>>> 
>>>> One place we do this is kexec, where we drop into purgatory with the MMU 
>>>> disabled.
>>>> 
>>>> The other is KVM unloading itself to return to the hyp stub. You can 
>>>> stress this
>>>> by starting and stopping a VM. When the number of VMs reaches 0 KVM 
>>>> should
>>>> unload via 'kvm_arch_hardware_disable()'.
>>>> 
>>>> 
>>>> Thanks,
>>>> 
>>>> James
>>>> 
>>>> 
>>> 
>>> --
>>> ============================
>>> Manoj Iyer
>>> Ubuntu/Canonical
>>> ARM Servers - Cloud
>>> ============================
>>> 
>>> 
>> 
>> --
>> ============================
>> Manoj Iyer
>> Ubuntu/Canonical
>> ARM Servers - Cloud
>> ============================
>> 
>> 
>
> --
> ============================
> Manoj Iyer
> Ubuntu/Canonical
> ARM Servers - Cloud
> ============================
>
>

--
============================
Manoj Iyer
Ubuntu/Canonical
ARM Servers - Cloud
============================
