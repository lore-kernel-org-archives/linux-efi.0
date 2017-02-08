From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 06/10] arm64: efi: add EFI stub
Date: Wed, 8 Feb 2017 17:40:35 +0000
Message-ID: <8792A751-3557-4D81-921B-F544EEE38811@linaro.org>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org> <1396637113-22790-7-git-send-email-leif.lindholm@linaro.org> <CAOZdJXWU1dmFfCc88RMp3SvouU7roDiJsA=3aHzwijwhMH7naA@mail.gmail.com> <E4BDBC23-A96A-4D84-B7EE-B7967D4E4DDD@linaro.org> <73a460e5-98f5-86c2-142f-a9a084ee0203@codeaurora.org> <20170208170305.GI15459@leverpostej>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208170305.GI15459@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


> On 8 Feb 2017, at 17:03, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>=20
>> On Wed, Feb 08, 2017 at 10:35:02AM -0600, Timur Tabi wrote:
>> On 02/08/2017 10:29 AM, Ard Biesheuvel wrote:
>>>>>>> +       status =3D handle_cmdline_files(sys_table, image, cmdline_pt=
r,
>>>>>>> +                                     "initrd=3D", dram_base + SZ_51=
2M,
>>>>>>> +                                     (unsigned long *)&initrd_addr,=

>>>>>>> +                                     (unsigned long *)&initrd_size)=
;
>>>>>=20
>>>>> So I know this patch is almost three years old, but why is there a
>>>>> 512M limit on the initrd size?
>>>>>=20
>>> How do you reckon this constitutes a limit?
>>=20
>> handle_cmdline_files() calls efi_high_alloc() with that limit.  I'm
>> still trying to understand all the details myself, but apparently
>> our firmware and initrd need to fit within the first 512MB because
>> of dram_base + SZ_512M. When we change "dram_base + SZ_512M" to
>> "~0", everything works.
>=20
> Just to check, how big is that initrd?
>=20
> I guess it's possible that there simply isn't sufficient contiguous free
> memory in that range, even if the initrd isn't that large. Can you share
> the EFI memory map dump from booting with efi=3Ddebug?
>=20
> We originally needed to restrict this to ensure that the kernel could
> map the initrd (and I think the 512M restriction specifically was
> inherited from the DTB mapping restriction). Since then, we have relaxed
> things in the kernel, and today Documentation/arm64/booting.txt says:
>=20
>    If an initrd/initramfs is passed to the kernel at boot, it must
>    reside entirely within a 1 GB aligned physical memory window of
>    up to 32 GB in size that fully covers the kernel Image as well.
>=20
> ... so I think the EFI stub should be able to take advantage of that
> relaxation.
>=20
> Ard?
>=20

Interestingly enough, this code originates on 32-bit ARM, where the linear m=
apping is only 800 MB so I suspect that may have something to do with it.

I agree the stub should simply follow the rules laid out in booting.txt. I t=
hink nobody hit this because it is usually GRUB that loads the initrd not th=
e EFI stub=
