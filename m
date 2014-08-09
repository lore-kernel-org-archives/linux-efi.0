From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Sun, 10 Aug 2014 01:45:16 +0300
Message-ID: <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
	<20140809192302.GJ15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140809192302.GJ15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Aug 9, 2014 at 10:23 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> =
wrote:
>
> On Sat, 09 Aug, at 09:44:55AM, Yinghai Lu wrote:
> > On Sat, Aug 9, 2014 at 7:23 AM, Mantas Mikul=C4=97nas <grawity@gmai=
l.com> wrote:
> > > As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above =
4G"),
> > > the kernel freezes at the earliest possible moment when trying to=
 boot
> > > via UEFI on my Asus laptop. (It still boots via BIOS.)
> > >
> > > If I revert that commit on current master (c309bfa9b481), it boot=
s
> > > correctly again [although I see "setup_efi_pci() failed" being pr=
inted].
> > >
> > > (Seems like it freezes when handle_cmdline_files() attempts to re=
ad
> > > the last chunk of the initramfs -- the last call to efi_file_read=
()
> > > never returns. Figuring out why that happens is beyond me, though=
=2E)
> > >
> >
> > Matt found that efi_file_read()/firmware has problem that could not=
 do
> > several reading. Please check if reverting that commit have any
> > difference.
> >
> > ---
> > I spent some time playing around with this bug and it appears to be
> > triggered by the read-a-chunk-at-a-time logic in handle_cmdline_fil=
es(),
> > (which is itself a bug workaround) introduced here,
> >
> >   commit 2d2da60fb40a
> >   Author: Maarten Lankhorst <m.b.lankhorst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >   Date:   Fri Dec 16 13:30:58 2011 +0100
> >
> >       x86, efi: Break up large initrd reads
>
> Right, I committed a patch to workaround this problem here,
>
>   http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit=
/?h=3Dnext&id=3D1c24a2bef39f041eb578189207240d0457ef0ac3
>
> since on my ASUS machine the combination of breaking up initrd reads
> into chunks and reading into a buffer above 4G actually triggers a wh=
ole
> new bug.
>
> Mantas, could you try out the patch referenced above and pass
> "efi=3Dnochunk" on the command line to the EFI boot stub. I'm hoping =
that
> fixes your problem.

Thanks for the patch, I've just tested it but the problem remains; the
system freezes even when reading the entire initramfs at once.

[However... Whether it's five chunks, four (after making the initrd
smaller), or just one (with your efi=3Dnochunk), I noticed that it
*always* hangs during the *last* read, and the allocated memory always
ends at roughly the same address (0x137fffXXX). I wonder if it's
selecting a memory location already in use, or something like that...]

(The laptop is Asus K52JT, AMI firmware v206, no updates available.)

--=20
Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
