From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: Random boot fail on 'cannot allocate trampoline' on Intel DQ57TM
 board with B.11 BIOS
Date: Mon, 03 Dec 2012 19:31:28 -0800
Message-ID: <50BD6E90.5040400@zytor.com>
References: <1346212111.6836.355.camel@linux-s257.site>  <50464BD6.6080106@zytor.com> <1354591095.21227.1355.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354591095.21227.1355.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/03/2012 07:18 PM, joeyli wrote:
> =E6=96=BC =E4=BA=8C=EF=BC=8C2012-09-04 =E6=96=BC 11:43 -0700=EF=BC=8C=
H. Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
>> On 08/28/2012 08:48 PM, joeyli wrote:
>>> Hi all experts,
>>>
>>> I tried the EFI_STUB on v3.6-rc1 kernel on Intel DQ57TM board with =
B.11
>>> BIOS that's the only one sample board on my hand. I found it can't =
boot
>>> success most time, fail rate is about 80% (run 6 times only 1 time =
boot
>>> success).
>>> When issue reproduced, kernel emit a panic message like through ser=
ial
>>> console like the following:
>>>
>>
>> This is odd... there is plenty of low memory which should have been
>> available for the trampoline.  The ACPI errors is another issue, of
>> course...
>>
>> 	-hpa
>>
>
> I moved all memory modules (have 2 in this machine) to channel A, the=
n I
> didn't reproduce this issue anymore.
>
> Just add this information for note to DQ57TM users.
>

That will hurt your performance.

You list your BIOS version as "B.11" but that's not the typical=20
nomenclature for BIOS on this board; the current BIOS version is 0050=20
with the full version string being TMIBX10H.86A.0050.2011.1207.1134.

I'm wondering if you may need a BIOS update.  Also, are you booting in=20
EFI mode or BIOS mode?

	-hpa


--=20
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
