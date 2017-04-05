From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL 0/2] EFI fixes for v4.11
Date: Wed, 5 Apr 2017 11:45:34 +0100
Message-ID: <CAKv+Gu85yRgWSJXFHD0-ZyCkbU3avmR3zOVd4w=BNuSpgH0pUg@mail.gmail.com>
References: <CGME20170405100833epcas1p4b5076679dc4f8644fa789b421a66f953@epcas1p4.samsung.com>
 <5013223.ea6UCckGV3@amdc3058> <CAKv+Gu_VaKNDmaWc2Gqpg1JB6pBthCVUOGEsONb8sj2Uos7qcg@mail.gmail.com>
 <6222690.3kM8OKJmde@amdc3058>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6222690.3kM8OKJmde@amdc3058>
Sender: linux-kernel-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Leif Lindholm <leif.lindholm@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Eugene Cohen <eugene@hp.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 5 April 2017 at 11:44, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> On Wednesday, April 05, 2017 11:14:06 AM Ard Biesheuvel wrote:
>> On 5 April 2017 at 11:08, Bartlomiej Zolnierkiewicz
>> <b.zolnierkie@samsung.com> wrote:
>> >
>> > Hi,
>> >
>> > On Tuesday, April 04, 2017 04:27:42 PM Ard Biesheuvel wrote:
>> >> Hello all,
>> >>
>> >> Please pull these fixes for EFI framebuffer support on ARM/arm64 syst=
ems.
>> >>
>> >> The following changes since commit 822f5845f710e57d7e2df1fd1ee00d6e19=
d334fe:
>> >>
>> >>   efi/esrt: Cleanup bad memory map log messages (2017-03-17 18:53:12 =
+0000)
>> >>
>> >> are available in the git repository at:
>> >>
>> >>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-=
urgent
>> >>
>> >> for you to fetch changes up to e73c2811538bd36ec1340d01bafdc080af3191=
4e:
>> >>
>> >>   efifb: Avoid reconfiguration of BAR that covers the framebuffer (20=
17-04-04 15:56:43 +0100)
>> >>
>> >> ----------------------------------------------------------------
>> >> Two fixes related to the EFI framebuffer driver:
>> >> - Ignore Graphics Output Protocol (GOP) implementations that are mark=
ed as
>> >>   BLT-only -- the framebuffer base address is invalid in this case, a=
nd the
>> >>   Blt() method is not accessible to the kernel.
>> >> - If the GOP framebuffer base address coincides with a memory BAR of =
a PCI
>> >>   device that has memory decoding enabled, claim the memory resource =
so that
>> >>   the PCI core will not attempt to move it later on.
>> >>
>> >> ----------------------------------------------------------------
>> >> Ard Biesheuvel (1):
>> >>       efifb: Avoid reconfiguration of BAR that covers the framebuffer
>> >
>> > This patch breaks build if PCI support is not enabled:
>> >
>> > drivers/video/fbdev/efifb.c: In function =E2=80=98claim_efifb_bar=E2=
=80=99:
>> > drivers/video/fbdev/efifb.c:386:2: error: implicit declaration of func=
tion =E2=80=98pci_claim_resource=E2=80=99 [-Werror=3Dimplicit-function-decl=
aration]
>> >
>> > (x86 ifdefs are not enough, the patch should also check for PCI suppor=
t)
>> >
>> > Also please cc: linux-fbdev mailing list & me on fbdev related patches=
.
>> >
>>
>> Thanks for the report. The patch was tested successfully on an
>> impressive list of configurations by kbuild test robot, but
>> apparently, none of those has PCI disabled.
>
> Well, it has been found by looking at the patch itself and since
> none of defconfigs contains such configuration currently the issue
> is rather minor one.
>
> [ Also sorry for the late report but this is the first time I see
>   these patches.  They were never posted to linux-fbdev or me. ]
>

Apologies for that. I did cc Peter but no other fbdev maintainers.

>> Ingo, since you have queued this already, how would you like to
>> proceed? I don't think we need anything beyond
>
> I see that Ingo fixed the patch himself so it is all fine now,
> thanks!
>
>> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
>> index 758960b6aec9..b827a8113e26 100644
>> --- a/drivers/video/fbdev/efifb.c
>> +++ b/drivers/video/fbdev/efifb.c
>> @@ -364,7 +364,7 @@ static struct platform_driver efifb_driver =3D {
>>
>>  builtin_platform_driver(efifb_driver);
>>
>> -#ifndef CONFIG_X86
>> +#if defined(CONFIG_PCI) && !defined(CONFIG_X86)
>>
>>  static bool pci_bar_found;     /* did we find a BAR matching the efifb =
base? */
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
