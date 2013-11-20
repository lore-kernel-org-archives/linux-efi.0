From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia
 parameter to efi_storage_paranoia
Date: Wed, 20 Nov 2013 16:08:01 +0800
Message-ID: <1384934881.6516.4082.camel@linux-s257.site>
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at>
	 <527CB013.30200@jp.fujitsu.com> <527CB0F4.8080606@nod.at>
	 <527CBC05.6080505@jp.fujitsu.com> <527CBD01.1000908@nod.at>
	 <527CBDD3.2020609@jp.fujitsu.com>
	 <20131108143421.GB22636@console-pimps.org>
	 <52809AEB.9080100@jp.fujitsu.com>
	 <20131111105424.GD22636@console-pimps.org>
	 <528AD50D.6060503@jp.fujitsu.com> <87siutqdwv.fsf@redhat.com>
	 <528C562B.3070008@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <528C562B.3070008-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-11-20 =E6=96=BC 15:26 +0900=EF=BC=8CYa=
suaki Ishimatsu =E6=8F=90=E5=88=B0=EF=BC=9A
> (2013/11/19 12:16), Madper Xie wrote:
> >=20
> > isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org writes:
> >=20
> >> Hi Matt,
> >>
> >> Sorry for late the reply.
> >>
> >>
> >> (2013/11/11 19:54), Matt Fleming wrote:
> >>> On Mon, 11 Nov, at 05:52:59PM, Yasuaki Ishimatsu wrote:
> >>>> Hi Matt,
> >>>>
> >>>> I uses FUJITSU's x86 box.
> >>>> This does not become bricked even if I use all efi variable stor=
age.
> >>>> Thus I want a way to not need to specify efi_no_storage_paranoia
> >>>> parameter.
> >>>
> >>> The efi_no_storage_paranoia parameter was introduced because some
> >>> machines do not initiate garbage collection of the NVRAM until yo=
u
> >>> allocate all space - basically it's a switch to turn off the "sav=
e 5KB
> >>> of stoarge at all times" workaround that is needed to avoid brick=
ing
> >>> some machines.
> >>>
> >>> The intention of the switch is not to allow you to fill your NVRA=
M just
> >>> because you can. If that is something you want to do then I think=
 it's
> >>> fair to require you to explicitly turn on efi_no_storage_paranoia=
=2E But
> >>> I'm assuming here that you are doing something like writing lots =
and
> >>> lots of pstore entries and just want to write as many as your var=
iable
> >>> storage will allow? Or are you doing something more fundamental l=
ike
> >>> creating BootXXXX entries?
> >>>
> >>> What are you doing to run into the 5KB reserve? How much NVRAM do=
es your
> >>> machine come with?
> >>
> >> I just add boot entry to NVRAM by efibootmgr command. But when Lin=
ux boots up,
> >> the remaining NVRAM is less than 5Kbyte. So I cannnot add new entr=
y.
> >>
> > Howdy Yasuaki,
> >    If the remaining NVRAM is less than 5Kb, your writing will trigg=
er a
> >    NVRAM storage reclamation. However you still failed creating ent=
ry. So
> >    I'm just curious what itmes occupy lots of nvram storage space.
>=20
> Even if we got EFI_OUT_OF_RESOURCES while running Linux, gc does not =
run.
> Trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS environme=
nt with
> UEFI. So on my system, if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte t=
hreshold,
> we cannot use nvram storage until EFI_OUT_OF_RESOURCES occurs on pre =
OS
> environment with UEFI.
>=20
> Thanks,
> Yasuaki Ishimatsu

Can we try to trigger gc by EFI_OUT_OF_RESOURCE in EFI stub kernel or
EFI boot loader to recover NVRAM space? Does work with the BIOS on this
machine?


Thanks a lot!
Joey Lee
