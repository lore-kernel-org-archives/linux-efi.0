From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: add support for seeding the RNG from a UEFI config table
Date: Wed, 19 Oct 2016 21:35:00 +0100
Message-ID: <8029158E-6144-4842-884C-918F1F916E05@linaro.org>
References: <1475749646-10844-1-git-send-email-ard.biesheuvel@linaro.org> <1475749646-10844-2-git-send-email-ard.biesheuvel@linaro.org> <20161019110926.GG9616@leverpostej> <CAKv+Gu9g1W8EfnJN2Y_Xgo=QKC1gHa95rjO32Dqt4uT+amzhnQ@mail.gmail.com> <20161019112243.GD31476@codeblueprint.co.uk> <CAGXu5jJ-KTVJLwAp6iZ-tp5AKnAzSHz80yZkg4dh3uYDz3MsJw@mail.gmail.com> <CAKv+Gu92dC6BK7Adb2xLvPwNXv=z15A0zhss_XVNfd+r0NA0SA@mail.gmail.com> <CAGXu5jKx5cvZsBwC1AJZ3Q4CCn-nxD3Jejs5irQLRan+j305Cw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jKx5cvZsBwC1AJZ3Q4CCn-nxD3Jejs5irQLRan+j305Cw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


> On 19 Oct 2016, at 21:20, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>=20
> On Wed, Oct 19, 2016 at 1:18 PM, Ard Biesheuvel
> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> On 19 October 2016 at 21:14, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>>>> On Wed, Oct 19, 2016 at 4:22 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org=
> wrote:
>>>>> On Wed, 19 Oct, at 12:13:55PM, Ard Biesheuvel wrote:
>>>>>> On 19 October 2016 at 12:09, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrot=
e:
>>>>>>=20
>>>>>> I think to some extent this mush be treated as an ABI, given cases li=
ke
>>>>>> kexec.
>>>>>>=20
>>>>>=20
>>>>> Perhaps, yes. That would also allow GRUB or other EFI aware
>>>>> bootloaders to generate the seed.
>>>>=20
>>>> If we're going to go down this route, we should try and get the GUID
>>>> into the UEFI spec.
>>>=20
>>> It seems like maybe under UEFI, both this table (which sounds like
>>> it'll not be rotated regularly)
>>=20
>> What do you mean 'rotated'? It is generated at boot. My 2/2 patch
>> generates it from the stub using the EFI_RNG_PROTOCOL on ARM/arm64
>=20
> Oh! I entirely misunderstood. I thought doing regular writes to EFI
> variables was discouraged (since they may be stored in NVRAM that
> would "wear out")

Uefi config tables only live in memory. They are used to provide the os with=
 data that the firmware generates at boot, e.g., smbios and acpi tables etc

>>> could be mixed with calls to
>>> EFI_PROTOCOL_RNG by the kernel? (Similar to how kaslr is seeded?)
>>>=20
>>=20
>> That is kind of the point. KASLR is different because we need the
>> entropy before even jumping to C code, but for all other uses of early
>> entropy, this seemed like a useful approach
>=20
> Yup, cool. If the table changes per boot, yeah, my suggestion is pointless=
. :)
>=20

Yes, but as Mark pointed out, we need to decide how to handle kexec, which d=
oes not go through the stub
