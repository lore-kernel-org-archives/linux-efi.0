From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Sat, 9 Aug 2014 20:23:02 +0100
Message-ID: <20140809192302.GJ15082@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 09 Aug, at 09:44:55AM, Yinghai Lu wrote:
> On Sat, Aug 9, 2014 at 7:23 AM, Mantas Mikul=C4=97nas <grawity@gmail.=
com> wrote:
> > As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G=
"),
> > the kernel freezes at the earliest possible moment when trying to b=
oot
> > via UEFI on my Asus laptop. (It still boots via BIOS.)
> >
> > If I revert that commit on current master (c309bfa9b481), it boots
> > correctly again [although I see "setup_efi_pci() failed" being prin=
ted].
> >
> > (Seems like it freezes when handle_cmdline_files() attempts to read
> > the last chunk of the initramfs -- the last call to efi_file_read()
> > never returns. Figuring out why that happens is beyond me, though.)
> >
>=20
> Matt found that efi_file_read()/firmware has problem that could not d=
o
> several reading. Please check if reverting that commit have any
> difference.
>=20
> ---
> I spent some time playing around with this bug and it appears to be
> triggered by the read-a-chunk-at-a-time logic in handle_cmdline_files=
(),
> (which is itself a bug workaround) introduced here,
>=20
>   commit 2d2da60fb40a
>   Author: Maarten Lankhorst <m.b.lankhorst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>   Date:   Fri Dec 16 13:30:58 2011 +0100
>=20
>       x86, efi: Break up large initrd reads

Right, I committed a patch to workaround this problem here,

  http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?=
h=3Dnext&id=3D1c24a2bef39f041eb578189207240d0457ef0ac3

since on my ASUS machine the combination of breaking up initrd reads
into chunks and reading into a buffer above 4G actually triggers a whol=
e
new bug.

Mantas, could you try out the patch referenced above and pass
"efi=3Dnochunk" on the command line to the EFI boot stub. I'm hoping th=
at
fixes your problem.

--=20
Matt Fleming, Intel Open Source Technology Center
