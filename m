From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Sun, 24 Aug 2014 22:19:04 +0300
Message-ID: <CAPWNY8V=T=Y5uPX9J_qjdkTJRnctDs-PoTQP7LEX_cKQEn0_Zg@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<53F752A2.7080604@redhat.com>
	<CAPWNY8V4pfazk4Hw9qu07cAQZywC-GS7eyS+54fazXZaKMjMQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPWNY8V4pfazk4Hw9qu07cAQZywC-GS7eyS+54fazXZaKMjMQw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Harald Hoyer <harald@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 22, 2014 at 5:43 PM, Mantas Mikul=C4=97nas <grawity@gmail.c=
om> wrote:
>
> On Fri, Aug 22, 2014 at 5:24 PM, Harald Hoyer <harald@redhat.com> wro=
te:
> > On 09.08.2014 16:23, Mantas Mikul=C4=97nas wrote:
> >> As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4=
G"),
> >> the kernel freezes at the earliest possible moment when trying to =
boot
> >> via UEFI on my Asus laptop. (It still boots via BIOS.)
> >>
> >> If I revert that commit on current master (c309bfa9b481), it boots
> >> correctly again [although I see "setup_efi_pci() failed" being pri=
nted].
> >>
> >> (Seems like it freezes when handle_cmdline_files() attempts to rea=
d
> >> the last chunk of the initramfs -- the last call to efi_file_read(=
)
> >> never returns. Figuring out why that happens is beyond me, though.=
)
> >>
> >
> > I fixed my issue with: https://lkml.org/lkml/2014/8/22/232
>
> ...Well. If that's the _physical_ address, then I suppose it wouldn't
> have worked on my 4 GB laptop either way. (I thought UEFI already use=
d
> some sort of virtual memory, so I never even thought to mention
> this... Oh well.)
>
> Though if that's the case, then I'm wondering why it would be affecte=
d
> by the read size? Shouldn't it have crashed either as soon as the hig=
h
> address was used, or never at all? (I really don't know much about
> memory at this level. Sorry.)
>
> > Care to test?
>
> Will try later today.

=46inally got around to testing it, and yes, your patch fixes the initr=
d
boot for me.

--=20
Mantas Mikul=C4=97nas <grawity@gmail.com>
