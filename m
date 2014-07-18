From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] efi/arm64: handle missing virtual mapping for UEFI
 System Table
Date: Fri, 18 Jul 2014 20:42:27 +0200
Message-ID: <CAKv+Gu8PW2C3=Y5+fwQbCttLp7S4a=qD5n_CRK-FM9cN84kzOA@mail.gmail.com>
References: <1404487509-26084-1-git-send-email-ard.biesheuvel@linaro.org>
	<1404492756.19665.57.camel@deneb.redhat.com>
	<20140704170110.GM16404@arm.com>
	<CAKv+Gu_-=NtVNFLEh35Pv8OO6nLe1YhPjS13MYZa93YOXFOh6Q@mail.gmail.com>
	<09C85B92-02BB-45C4-A461-D4E0CD4F7203@arm.com>
	<20140707201103.GB27474@console-pimps.org>
	<CAKv+Gu9aksvu3kOVt9GAA8jGdR0DkUUJ2iT3RMS-kEZ-OOkH2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9aksvu3kOVt9GAA8jGdR0DkUUJ2iT3RMS-kEZ-OOkH2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 7 July 2014 22:38, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 7 July 2014 22:11, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
>> On Sat, 05 Jul, at 08:25:35AM, Catalin Marinas wrote:
>>>
>>> OK, I=E2=80=99ll leave it to Matt then together with the other EFI =
patches
>>> he=E2=80=99s already queuing.
>>
>> Thanks guys.
>>
>> What release are we targetting with this patch? Is it a bug fix for
>> something likely to affect people? Have there been reports of users
>> actually hitting this issue?
>>
>> We're at -rc4 now, so there's still time for getting bug fixes to Li=
nus
>> but we may start being asked for justification from the tip folks en
>> route to Linus.
>>
>> If it's just a case of improving the error paths, can it wait until
>> v3.17?
>>
>
> This fixes a potential panic under buggy firmware, but no reports of
> this actual bug are known, so there is no justification for a late
> merge for 3.16.
>

Hey Matt,

I was wondering if you're on track to queue up your -next branch for 3.=
17?

If so, could you please include $subject? And if you don't mind, could
you squash the following fixup into "efi: efistub: Convert into static
library" as well?

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index cdaedad3afe5..afaeb734295a 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -4,8 +4,7 @@

 CPPFLAGS_vmlinux.lds   :=3D -DTEXT_OFFSET=3D$(TEXT_OFFSET)
 AFLAGS_head.o          :=3D -DTEXT_OFFSET=3D$(TEXT_OFFSET)
-CFLAGS_efi-stub.o      :=3D -DTEXT_OFFSET=3D$(TEXT_OFFSET) \
-                          -I$(src)/../../../scripts/dtc/libfdt
+CFLAGS_efi-stub.o      :=3D -DTEXT_OFFSET=3D$(TEXT_OFFSET)

 CFLAGS_REMOVE_ftrace.o =3D -pg
 CFLAGS_REMOVE_insn.o =3D -pg


Much appreciated,

Cheers,
Ard.
