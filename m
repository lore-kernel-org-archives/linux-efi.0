From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] efi/libstub: Retry ExitBootServices if map key is invalid
Date: Thu, 30 Jun 2016 18:47:02 +0200
Message-ID: <CAKv+Gu_PLqOVZQC4i3v75M0a-Z9tuE86DSU4v=Vg_pBj-5Y1WQ@mail.gmail.com>
References: <1467300933-3991-1-git-send-email-jhugo@codeaurora.org> <20160630162751.GC29700@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160630162751.GC29700@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Jeff Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 30 June 2016 at 18:27, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi,
>
> [Adding Ard and Leif]
>
> On Thu, Jun 30, 2016 at 09:35:33AM -0600, Jeff Hugo wrote:
>> From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> There exists a race condition between when the efi stub grabs the me=
mory
>> map, and when ExitBootServices is called at which point the EFI can =
process
>> an event which causes the memory map to be invalidated.
>
> For reference, do you have a particular example of such an event?
>
> Do these events cause the memory map to grow?
>

Events are typically allowed to allocate or free memory, unless they
have the EVT_SIGNAL_EXIT_BOOT_SERVICES=EF=80=A0 attribute. Whether they=
 cause
the memory map to grow is hard to predict, so one must assume yes.

>> According to the UEFI spec, ExitBootServices will return
>> EFI_INVALID_PARAMETER if this occurs, at which point the efi stub is
>> expected to obtain the new memory map, and retry the call to
>> ExitBootServices.
>>
>> Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>
>> I'm not particularly happy with the current state of this fix, but I=
 feel like
>> this issue is somewhat unsolvable.  Currently I've based this soluti=
on upon
>> arch/x86/boot/compressed/eboot.c however it has two primary issues I=
'd like
>> feedback upon-
>>
>> First issue-
>> efi_get_memory_map() performs an allocation as it attempts to create=
 a
>> minimal sized buffer to hold the map.  Per my understanding of the U=
EFI spec,
>> allocations are not permitted after a call to ExitBootServices:
>>
>> "A UEFI OS loader should not make calls to any boot service function=
 other than
>> GetMemoryMap() after the first call to ExitBootServices()."
>
> I see that appears on page 222 of the EFI 2.6 spec. To sve others fro=
m
> digging, the relevant paragraph reads:
>
>         A UEFI OS loader must ensure that it has the system=E2=80=99s=
 current
>         memory map at the time it calls ExitBootServices(). This is d=
one
>         by passing in the current memory map=E2=80=99s MapKey value a=
s returned
>         by EFI_BOOT_SERVICES.GetMemoryMap(). Care must be taken to
>         ensure that the memory map does not change between these two
>         calls. It is suggested that GetMemoryMap()be called immediate=
ly
>         before calling ExitBootServices(). If MapKey value is incorre=
ct,
>         ExitBootServices() returns EFI_INVALID_PARAMETER and
>         GetMemoryMap() with ExitBootServices() must be called again.
>         Firmware implementation may choose to do a partial shutdown o=
f
>         the boot services during the first call to ExitBootServices()=
=2E A
>         UEFI OS loader should not make calls to any boot service
>         function other than GetMemoryMap() after the first call to
>         ExitBootServices().
>
> That "partial shutdown" also means that giving up after a failed
> ExitBootServices() call is difficult. We can't log anything, and
> whatever we return to can't call any boot services.
>

This is the unfortunate part: we lost our console so there is nothing
we can do except hang, or proceed without a memory map. Since we have
already allocated space for the static kernel image in this case, it
may be better to proceed so we can at least die loudly on earlycon
enabled configurations.

>> However the only alternative I can think of it to allocate a suffice=
ntly large
>> buffer so that it can be reused to hold the modified memory map.  Th=
ere doesn't
>> seem to be any limit to the new map, so any buffer space value I wou=
ld choose
>> would be arbitrary, and there would be some chance that it would be =
insufficent.
>> efi_get_memory_map() would need to be modified to "return" the origi=
onal size
>> of the allocated buffer as well, so I feel like this solution makes =
a mess of
>> the code, reduces the value of the efi_get_memory_map() helper funct=
ion, and for
>> all that effort, we still can't fully address this race condition.
>>
>> I guess the question is, where do we draw the line at "good enough" =
for
>> addressing this issue?  Do we use efi_get_memory_map() since it appe=
ars to be
>> cleaner and does not seem to cause a problem today, despite violatin=
g the spec?
>
> We shouldn't be knowingly violating the UEFI spec.
>
> At the very least, this should be raised with the USWG. This feels li=
ke
> a specification bug, given that it's impossible (rather than simply
> difficult) to solve the issue.
>

efi_get_memory_map() is the linux wrapper around the GetMemoryMap()
boot service, and the latter does not perform any allocations. The
spec also clearly states that GetMemoryMap() can be called after EBS()
has failed.

> Ideally, we have the rules regarding a failed call to ExitBootService=
s()
> tightened such that other boot services calls are valid. The current
> wording appears to result in a number of unsolvable issues.
>

The only unsolvable issue is that we may find that we did not allocate
sufficient slack to cover the updated memory map. Typically, a
periodic event that happens to allocate and/or free some memory in its
handler may result in one or two entries to be added, but it is
bounded in practice even if the spec does not spell it out explicitly.

So allocating a couple of entries' worth of slack should be sufficient
in virtually all cases.

>> Second issue-
>> When do we give up if we cannot get a good memory map to use with
>> ExitBootServices?  Currently there is an infinite loop in my patch. =
 I noticed
>> arch/x86/boot/compressed/eboot.c only retrys after the first failure=
=2E  I think
>> a single retry is insufficent, we could do better, but I'm aware tha=
t an
>> infinite loop is generally a bad idea.  Any strong opinions on when =
to quit?
>> 100 attempts?  Either way, it seems the system will require a hard r=
eboot if
>> the retry(s) ever end up failing.
>
> I think this depends on what the problematic events are.
>

The wording of the spec suggests that two attempts at the most covers
all cases, and the EDK2 implementation confirms that: the first thing
it does is disarm the timer, and since all asynchronous processing in
UEFI is event based (no interrupts except for the timer or for debug),
this guarantees that the race condition that hit us the first time
does not exist anymore the second time around.

I know this is all a bit hand wavy, but I never experienced the issue
in practice (to my knowledge) and I don't think it makes a huge lot of
sense to complicate this code too much only to cater for theoretical
spec violations.

--=20
Ard.

>>
>>  drivers/firmware/efi/libstub/fdt.c | 45 +++++++++++++++++++++++++++=
+++--------
>>  1 file changed, 36 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/e=
fi/libstub/fdt.c
>> index e58abfa..d3e70b0 100644
>> --- a/drivers/firmware/efi/libstub/fdt.c
>> +++ b/drivers/firmware/efi/libstub/fdt.c
>> @@ -250,16 +250,43 @@ efi_status_t allocate_new_fdt_and_exit_boot(ef=
i_system_table_t *sys_table,
>>               }
>>       }
>>
>> -     /*
>> -      * Update the memory map with virtual addresses. The function =
will also
>> -      * populate @runtime_map with copies of just the EFI_MEMORY_RU=
NTIME
>> -      * entries so that we can pass it straight into SetVirtualAddr=
essMap()
>> -      */
>> -     efi_get_virtmap(memory_map, map_size, desc_size, runtime_map,
>> -                     &runtime_entry_count);
>> +     do {
>> +             /*
>> +              * We should not free and/or allocate after calling
>> +              * ExitBootServices, but this avoids the issue of gues=
sing how
>> +              * large of a buffer we need to store an updated memor=
y map,
>> +              * and its common for the implementation of ExitBootSe=
rvices to
>> +              * first check if the map key is current, and error ou=
t early
>> +              * leaving all other services active.
>> +              */
>> +             sys_table->boottime->free_pool(memory_map);
>> +             status =3D efi_get_memory_map(sys_table, &memory_map, =
&map_size,
>> +                                         &desc_size, &desc_ver, &mm=
ap_key);
>> +             if (status !=3D EFI_SUCCESS) {
>> +                     pr_efi_err(sys_table, "Unable to grab memory m=
ap for ExitBootServices.\n");
>> +                     break;
>> +             }
>> +             /*
>> +              * Update the memory map with virtual addresses. The f=
unction
>> +              * will also populate @runtime_map with copies of just=
 the
>> +              * EFI_MEMORY_RUNTIME entries so that we can pass it s=
traight
>> +              * into SetVirtualAddressMap()
>> +              */
>> +             efi_get_virtmap(memory_map, map_size, desc_size, runti=
me_map,
>> +                             &runtime_entry_count);
>> +
>> +             /* Now we are ready to exit_boot_services.*/
>> +             status =3D sys_table->boottime->exit_boot_services(han=
dle,
>> +                                                              mmap_=
key);
>> +             /*
>> +              * EFI_INVALID_PARAMETER means our memory map key does=
 not
>> +              * match the current map, likely because some event su=
ch as an
>> +              * interrupt caused an allocation ourside of our contr=
ol.  Thus
>> +              * we need to get the updated map, and try again.  Our=
 FDT
>> +              * allocation from above remains valid, so no need to =
redo that.
>> +              */
>> +     } while (status =3D=3D EFI_INVALID_PARAMETER);
>>
>> -     /* Now we are ready to exit_boot_services.*/
>> -     status =3D sys_table->boottime->exit_boot_services(handle, mma=
p_key);
>>
>>       if (status =3D=3D EFI_SUCCESS) {
>>               efi_set_virtual_address_map_t *svam;
>> --
>> Qualcomm Innovation Center, Inc.
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>> a Linux Foundation Collaborative Project.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-efi"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
