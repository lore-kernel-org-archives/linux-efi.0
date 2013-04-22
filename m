From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: Cannot add new efi boot entry
Date: Mon, 22 Apr 2013 19:31:17 +0800
Message-ID: <1366630277.23707.132.camel@linux-s257.site>
References: <516B1ED3.9040900@suse.cz>
	 <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com>
	 <516EB1B6.7050506@suse.cz> <516EB6F2.6070806@console-pimps.org>
	 <51703664.40003@suse.cz> <5172466B.9080105@suse.cz>
	 <517519E3.2030409@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517519E3.2030409-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=80=EF=BC=8C2013-04-22 =E6=96=BC 12:07 +0100=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On 20/04/13 08:40, Jiri Slaby wrote:
> > On 04/18/2013 08:07 PM, Jiri Slaby wrote:
> >> On 04/17/2013 04:51 PM, Matt Fleming wrote:
> >>> On 17/04/13 15:29, Jiri Slaby wrote:
> >>>> On 04/16/2013 12:11 PM, Matt Fleming wrote:
> >>>>> On 16/04/13 10:56, joeyli wrote:
> >>>>>> I think I just got the same situation on my side with Acer mac=
hine. I am
> >>>>>> trying Matthew's new patchset hope can avoid this situation:
> >>>>>>
> >>>>>> https://lkml.org/lkml/2013/4/15/473
> >>>>>
> >>>>> Please do let us know whether the patches work for you.
> >>>>
> >>>> Hmm, where did efi_query_variable_store in 3/3 come from?
> >>>
> >>> It's in a patch on the 'urgent' branch at,
> >>>
> >>>     git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.gi=
t
> >>
> >> The 3 patches plus that one work for me.
> >=20
> > Actually they don't :(:
> > open("/sys/firmware/efi/vars/new_var", O_WRONLY) =3D 3
> > write(3,
> > "B\0o\0o\0t\0000\0000\0001\0003\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
=2E.,
> > 2084) =3D -1 ENOSPC (No space left on device)
> > close(3)                                =3D 0
>=20
> Thanks for testing Jiri.
>=20
> You can disable the EFI storage checks in -rc8 by using the
> efi_no_storage_paranoia kernel parameter, but it's only recommended t=
o
> do that if you machine ends up in these kinds of situations where
> garbage collection isn't be initiated, or your machine ships with > 5=
0%

Does garbage collection only trigger by UEFI BIOS when system reboot? o=
r
garbage collection also triggered at run time?

There have a problem is if we delete boot entry when the flash space
tight(maybe 99%, just remaining_size < max_size), then we can not creat=
e
new boot entry unless we reboot system for trigger garbage collection.
But we already lost available boot entry.

> of the variable store in use from the factory.
>=20
> Matthew, what kind of info do you need from Jiri to improve the stora=
ge
> limit algorithm?
>=20

Thanks a lot!
Joey Lee
