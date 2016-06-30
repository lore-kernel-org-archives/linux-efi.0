From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] efi/libstub: Retry ExitBootServices if map key is invalid
Date: Thu, 30 Jun 2016 20:31:04 +0200
Message-ID: <CAKv+Gu8N3ORp_tg80wxJAgyYbNNPtfw2h-Hxy3DMkDcM6MQbAg@mail.gmail.com>
References: <1467300933-3991-1-git-send-email-jhugo@codeaurora.org>
 <20160630162751.GC29700@leverpostej> <CAKv+Gu_PLqOVZQC4i3v75M0a-Z9tuE86DSU4v=Vg_pBj-5Y1WQ@mail.gmail.com>
 <36dc8c28-e659-7d93-d705-ccc7734fd3d2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <36dc8c28-e659-7d93-d705-ccc7734fd3d2-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 30 June 2016 at 19:56, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> On 6/30/2016 10:47 AM, Ard Biesheuvel wrote:
>>
>> On 30 June 2016 at 18:27, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>>>
>>> Hi,
>>>
>>> [Adding Ard and Leif]
>>>
>>> On Thu, Jun 30, 2016 at 09:35:33AM -0600, Jeff Hugo wrote:
>>>>
>>>> From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>>>
>>>> There exists a race condition between when the efi stub grabs the =
memory
>>>> map, and when ExitBootServices is called at which point the EFI ca=
n
>>>> process
>>>> an event which causes the memory map to be invalidated.
>>>
>>>
>>> For reference, do you have a particular example of such an event?
>>>
>>> Do these events cause the memory map to grow?
>>>
>>
>> Events are typically allowed to allocate or free memory, unless they
>> have the EVT_SIGNAL_EXIT_BOOT_SERVICES=EF=80=A0 attribute. Whether t=
hey cause
>> the memory map to grow is hard to predict, so one must assume yes.
>>
>>>> According to the UEFI spec, ExitBootServices will return
>>>> EFI_INVALID_PARAMETER if this occurs, at which point the efi stub =
is
>>>> expected to obtain the new memory map, and retry the call to
>>>> ExitBootServices.
>>>>
>>>> Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>>> ---
>>>>
>>>> I'm not particularly happy with the current state of this fix, but=
 I
>>>> feel like
>>>> this issue is somewhat unsolvable.  Currently I've based this solu=
tion
>>>> upon
>>>> arch/x86/boot/compressed/eboot.c however it has two primary issues=
 I'd
>>>> like
>>>> feedback upon-
>>>>
>>>> First issue-
>>>> efi_get_memory_map() performs an allocation as it attempts to crea=
te a
>>>> minimal sized buffer to hold the map.  Per my understanding of the=
 UEFI
>>>> spec,
>>>> allocations are not permitted after a call to ExitBootServices:
>>>>
>>>> "A UEFI OS loader should not make calls to any boot service functi=
on
>>>> other than
>>>> GetMemoryMap() after the first call to ExitBootServices()."
>>>
>>>
>>> I see that appears on page 222 of the EFI 2.6 spec. To sve others f=
rom
>>> digging, the relevant paragraph reads:
>>>
>>>         A UEFI OS loader must ensure that it has the system=E2=80=99=
s current
>>>         memory map at the time it calls ExitBootServices(). This is=
 done
>>>         by passing in the current memory map=E2=80=99s MapKey value=
 as returned
>>>         by EFI_BOOT_SERVICES.GetMemoryMap(). Care must be taken to
>>>         ensure that the memory map does not change between these tw=
o
>>>         calls. It is suggested that GetMemoryMap()be called immedia=
tely
>>>         before calling ExitBootServices(). If MapKey value is incor=
rect,
>>>         ExitBootServices() returns EFI_INVALID_PARAMETER and
>>>         GetMemoryMap() with ExitBootServices() must be called again=
=2E
>>>         Firmware implementation may choose to do a partial shutdown=
 of
>>>         the boot services during the first call to ExitBootServices=
(). A
>>>         UEFI OS loader should not make calls to any boot service
>>>         function other than GetMemoryMap() after the first call to
>>>         ExitBootServices().
>>>
>>> That "partial shutdown" also means that giving up after a failed
>>> ExitBootServices() call is difficult. We can't log anything, and
>>> whatever we return to can't call any boot services.
>>>
>>
>> This is the unfortunate part: we lost our console so there is nothin=
g
>> we can do except hang, or proceed without a memory map. Since we hav=
e
>> already allocated space for the static kernel image in this case, it
>> may be better to proceed so we can at least die loudly on earlycon
>> enabled configurations.
>>
>>>> However the only alternative I can think of it to allocate a suffi=
cently
>>>> large
>>>> buffer so that it can be reused to hold the modified memory map.  =
There
>>>> doesn't
>>>> seem to be any limit to the new map, so any buffer space value I w=
ould
>>>> choose
>>>> would be arbitrary, and there would be some chance that it would b=
e
>>>> insufficent.
>>>> efi_get_memory_map() would need to be modified to "return" the ori=
gional
>>>> size
>>>> of the allocated buffer as well, so I feel like this solution make=
s a
>>>> mess of
>>>> the code, reduces the value of the efi_get_memory_map() helper fun=
ction,
>>>> and for
>>>> all that effort, we still can't fully address this race condition.
>>>>
>>>> I guess the question is, where do we draw the line at "good enough=
" for
>>>> addressing this issue?  Do we use efi_get_memory_map() since it ap=
pears
>>>> to be
>>>> cleaner and does not seem to cause a problem today, despite violat=
ing
>>>> the spec?
>>>
>>>
>>> We shouldn't be knowingly violating the UEFI spec.
>>>
>>> At the very least, this should be raised with the USWG. This feels =
like
>>> a specification bug, given that it's impossible (rather than simply
>>> difficult) to solve the issue.
>>>
>>
>> efi_get_memory_map() is the linux wrapper around the GetMemoryMap()
>> boot service, and the latter does not perform any allocations. The
>> spec also clearly states that GetMemoryMap() can be called after EBS=
()
>> has failed.
>>
>>> Ideally, we have the rules regarding a failed call to ExitBootServi=
ces()
>>> tightened such that other boot services calls are valid. The curren=
t
>>> wording appears to result in a number of unsolvable issues.
>>>
>>
>> The only unsolvable issue is that we may find that we did not alloca=
te
>> sufficient slack to cover the updated memory map. Typically, a
>> periodic event that happens to allocate and/or free some memory in i=
ts
>> handler may result in one or two entries to be added, but it is
>> bounded in practice even if the spec does not spell it out explicitl=
y.
>>
>> So allocating a couple of entries' worth of slack should be sufficie=
nt
>> in virtually all cases.
>
>
> True.  I've talked with the folks implementing UEFI on my test platfo=
rm, and
> they believe a buffer of 8 entries would be more than sufficient for =
all
> practical purposes.
>

OK, so we're on the same page here

>>
>>>> Second issue-
>>>> When do we give up if we cannot get a good memory map to use with
>>>> ExitBootServices?  Currently there is an infinite loop in my patch=
=2E  I
>>>> noticed
>>>> arch/x86/boot/compressed/eboot.c only retrys after the first failu=
re.  I
>>>> think
>>>> a single retry is insufficent, we could do better, but I'm aware t=
hat an
>>>> infinite loop is generally a bad idea.  Any strong opinions on whe=
n to
>>>> quit?
>>>> 100 attempts?  Either way, it seems the system will require a hard
>>>> reboot if
>>>> the retry(s) ever end up failing.
>>>
>>>
>>> I think this depends on what the problematic events are.
>>>
>>
>> The wording of the spec suggests that two attempts at the most cover=
s
>> all cases, and the EDK2 implementation confirms that: the first thin=
g
>> it does is disarm the timer, and since all asynchronous processing i=
n
>> UEFI is event based (no interrupts except for the timer or for debug=
),
>> this guarantees that the race condition that hit us the first time
>> does not exist anymore the second time around.
>>
>> I know this is all a bit hand wavy, but I never experienced the issu=
e
>> in practice (to my knowledge) and I don't think it makes a huge lot =
of
>> sense to complicate this code too much only to cater for theoretical
>> spec violations.
>>
>
> On the platform I'm testing, UEFI follows the EDK2 implementation, so=
 I've
> been only able to trigger the failure initially by putting in a "slee=
p"
> between grabbing the map/ExitBootServices() and plugging and/or unplu=
gging
> in a usb flash stick into the device.  The issue does not reoccur aft=
er
> ExitBootServices() is called and fails.
>
> I do have a few reports of the issue occurring "in the wild", so I am
> looking to address it.  Based on the data I have, its rare, less than=
 1%.
>
> I understand your position.  On unrelated issues/projects I have been=
 burned
> where something gets fixed to address an issue with today's implement=
ation,
> and then it breaks again because that implementation changed in a way=
 that
> was allowed by the relevant spec.  Based on those experiences, I'm wa=
ry to
> just say "welp it works today", but this segment of code does look sh=
ort and
> to the point, so I'm kind of leaning towards your position, I'd prefe=
r not
> to complicate it without a strong reason.
>
> I admit, this is not my domain of expertise, I'm just trying to solve=
 an
> issue that was reported to me.  What would be your preference for a
> solution?  A single retry if ExitBootServices() fails using
> efi_get_memory_map() - basically an exact copy of how this appears to=
 be
> solved in arch/x86/boot/compressed/eboot.c?
>

No, I think x86's implementation is incorrect. efi_get_memory_map()
should allocate some slack (i.e., the 8 entries you mentioned), and if
the first call to ExitBootServices() fails, we should reuse the memory
map buffer, and call GetMemoryMap() directly to repopulate it. Then,
we call ExitBootServices() once more, or give up if either call fails.

This way, we are 100% compliant with the wording of the spec, and err
on the side of caution.

--=20
Ard.
