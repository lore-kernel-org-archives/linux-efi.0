From: Matt Fleming <matt@console-pimps.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Wed, 13 Aug 2014 15:02:19 +0100
Message-ID: <20140813140219.GP15082@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
 <20140809192302.GJ15082@console-pimps.org>
 <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
 <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
 <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sun, 10 Aug, at 09:43:32PM, Mantas Mikul=C4=97nas wrote:
> On Sun, Aug 10, 2014 at 8:55 AM, Yinghai Lu <yinghai@kernel.org> wrot=
e:
> > On Sat, Aug 9, 2014 at 3:45 PM, Mantas Mikul=C4=97nas <grawity@gmai=
l.com> wrote:
> >> On Sat, Aug 9, 2014 at 10:23 PM, Matt Fleming <matt@console-pimps.=
org> wrote:
> >> [However... Whether it's five chunks, four (after making the initr=
d
> >> smaller), or just one (with your efi=3Dnochunk), I noticed that it
> >> *always* hangs during the *last* read, and the allocated memory al=
ways
> >> ends at roughly the same address (0x137fffXXX). I wonder if it's
> >> selecting a memory location already in use, or something like that=
=2E..]
> >>
> >> (The laptop is Asus K52JT, AMI firmware v206, no updates available=
=2E)
> >
> > wonder if  efi_file_read return with wrong chunksize.
> >
> > Can you try attached patch ?
>=20
> Thanks, but it didn't change anything.
>=20
> (I tried adding some efi_printk's, and as far as I can see,
> efi_file_read *doesn't* return at all.)

Could you send you revert Yinghai's commit locally and send the dmesg
from a successful boot? I'm wondering what other regions are around the
0x137fffxxx area.

One other thing to attempt would be to progressively try higher and
higher max memory addresses to read into to see if we can correlate you=
r
hang with a particular region, i.e. this code,


	if (hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
		initrd_addr_max =3D -1UL;
	else
		initrd_addr_max =3D hdr->initrd_addr_max;

	status =3D efi_parse_options(cmdline_ptr);
	if (status !=3D EFI_SUCCESS)
		goto fail2;

	status =3D handle_cmdline_files(sys_table, image,
				      (char *)(unsigned long)hdr->cmd_line_ptr,
				      "initrd=3D", initrd_addr_max,
				      &ramdisk_addr, &ramdisk_size);


--=20
Matt Fleming, Intel Open Source Technology Center
