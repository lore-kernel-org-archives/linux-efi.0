From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3] efi/arm64: handle missing virtual mapping for UEFI System Table
Date: Sat, 5 Jul 2014 08:25:35 +0100
Message-ID: <09C85B92-02BB-45C4-A461-D4E0CD4F7203@arm.com>
References: <1404487509-26084-1-git-send-email-ard.biesheuvel@linaro.org> <1404492756.19665.57.camel@deneb.redhat.com>	<20140704170110.GM16404@arm.com> <CAKv+Gu_-=NtVNFLEh35Pv8OO6nLe1YhPjS13MYZa93YOXFOh6Q@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_-=NtVNFLEh35Pv8OO6nLe1YhPjS13MYZa93YOXFOh6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 Jul 2014, at 18:19, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wro=
te:
> On 4 July 2014 19:01, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote=
:
>> On Fri, Jul 04, 2014 at 05:52:36PM +0100, Mark Salter wrote:
>>> On Fri, 2014-07-04 at 17:25 +0200, Ard Biesheuvel wrote:
>>>> If we cannot resolve the virtual address of the UEFI System Table,=
 its physical
>>>> offset must be missing from the virtual memory map, and there is r=
eally no point
>>>> in proceeding with installing the virtual memory map and the runti=
me services
>>>> dispatch table. So back out gracefully.
>>>>=20
>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>> ---
>>>=20
>>> Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>=20
>> Thanks. Do I take this patch or Matt already has other EFI patches t=
o
>> push? If the latter:
>>=20
>> Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
>=20
> Thanks. You can take it for 3.16 if you like, otherwise it is probabl=
y
> better if we ask Matt to take it through his tree with some other
> stuff we have in flight at the moment.

OK, I=92ll leave it to Matt then together with the other EFI patches
he=92s already queuing.

Thanks,

Catalin--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
