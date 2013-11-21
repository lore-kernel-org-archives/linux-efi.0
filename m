From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia
 parameter to efi_storage_paranoia
Date: Thu, 21 Nov 2013 18:27:13 +0800
Message-ID: <1385029633.6516.4097.camel@linux-s257.site>
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at>
	 <527CB013.30200@jp.fujitsu.com> <527CB0F4.8080606@nod.at>
	 <527CBC05.6080505@jp.fujitsu.com> <527CBD01.1000908@nod.at>
	 <527CBDD3.2020609@jp.fujitsu.com>
	 <20131108143421.GB22636@console-pimps.org>
	 <52809AEB.9080100@jp.fujitsu.com>
	 <20131111105424.GD22636@console-pimps.org>
	 <528AD50D.6060503@jp.fujitsu.com> <87siutqdwv.fsf@redhat.com>
	 <528C562B.3070008@jp.fujitsu.com>
	 <1384934881.6516.4082.camel@linux-s257.site>
	 <528DCED7.5070806@jp.fujitsu.com>
	 <1385027623.6516.4090.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385027623.6516.4090.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-11-21 =E6=96=BC 17:53 +0800=EF=BC=8Cjo=
eyli =E6=8F=90=E5=88=B0=EF=BC=9A
> =E6=96=BC =E5=9B=9B=EF=BC=8C2013-11-21 =E6=96=BC 18:13 +0900=EF=BC=8C=
Yasuaki Ishimatsu =E6=8F=90=E5=88=B0=EF=BC=9A
> > (2013/11/20 17:08), joeyli wrote:
> > > =E6=96=BC =E4=B8=89=EF=BC=8C2013-11-20 =E6=96=BC 15:26 +0900=EF=BC=
=8CYasuaki Ishimatsu =E6=8F=90=E5=88=B0=EF=BC=9A
> > >> (2013/11/19 12:16), Madper Xie wrote:
> > >>>
> > >>> isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org writes:
> > >>>
> > >>>> Hi Matt,
> > >>>>
> > >>>> Sorry for late the reply.
> > >>>>
> > >>>>
> > >>>> (2013/11/11 19:54), Matt Fleming wrote:
> > >>>>> On Mon, 11 Nov, at 05:52:59PM, Yasuaki Ishimatsu wrote:
> > >>>>>> Hi Matt,
> > >>>>>>
> > >>>>>> I uses FUJITSU's x86 box.
> > >>>>>> This does not become bricked even if I use all efi variable =
storage.
> > >>>>>> Thus I want a way to not need to specify efi_no_storage_para=
noia
> > >>>>>> parameter.
> > >>>>>
> > >>>>> The efi_no_storage_paranoia parameter was introduced because =
some
> > >>>>> machines do not initiate garbage collection of the NVRAM unti=
l you
> > >>>>> allocate all space - basically it's a switch to turn off the =
"save 5KB
> > >>>>> of stoarge at all times" workaround that is needed to avoid b=
ricking
> > >>>>> some machines.
> > >>>>>
> > >>>>> The intention of the switch is not to allow you to fill your =
NVRAM just
> > >>>>> because you can. If that is something you want to do then I t=
hink it's
> > >>>>> fair to require you to explicitly turn on efi_no_storage_para=
noia. But
> > >>>>> I'm assuming here that you are doing something like writing l=
ots and
> > >>>>> lots of pstore entries and just want to write as many as your=
 variable
> > >>>>> storage will allow? Or are you doing something more fundament=
al like
> > >>>>> creating BootXXXX entries?
> > >>>>>
> > >>>>> What are you doing to run into the 5KB reserve? How much NVRA=
M does your
> > >>>>> machine come with?
> > >>>>
> > >>>> I just add boot entry to NVRAM by efibootmgr command. But when=
 Linux boots up,
> > >>>> the remaining NVRAM is less than 5Kbyte. So I cannnot add new =
entry.
> > >>>>
> > >>> Howdy Yasuaki,
> > >>>     If the remaining NVRAM is less than 5Kb, your writing will =
trigger a
> > >>>     NVRAM storage reclamation. However you still failed creatin=
g entry. So
> > >>>     I'm just curious what itmes occupy lots of nvram storage sp=
ace.
> > >>
> > >> Even if we got EFI_OUT_OF_RESOURCES while running Linux, gc does=
 not run.
> > >> Trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS envi=
ronment with
> > >> UEFI. So on my system, if EFI_OUT_OF_RESOURCES occurs by the 5Kb=
yte threshold,
> > >> we cannot use nvram storage until EFI_OUT_OF_RESOURCES occurs on=
 pre OS
> > >> environment with UEFI.
> > >>
> > >> Thanks,
> > >> Yasuaki Ishimatsu
> > >
> > > Can we try to trigger gc by EFI_OUT_OF_RESOURCE in EFI stub kerne=
l or
> > > EFI boot loader to recover NVRAM space? Does work with the BIOS o=
n this
> > > machine?
> >=20
> > Yes. I can trigger gc by EFI_OUT_OF_RESOUCE in EFI shell on my mach=
ine.
> >=20
> > Thanks,
> > Yasuaki Ishimatu
> >=20
>=20
> OK, then maybe can try to trigger gc in EFI stub before
> ExitBootService().=20
>=20
> Another problem is what's the reasonable threshold. The threshold sho=
uld
> bigger then 5Kbyte, then we write a dummy BootTime NV variable to
> trigger gc.
>=20
>=20
> Thanks
> Joey Lee

hm... after review your mail, if the free NVRAM space of issue machine
is REALLY less then 5K even after gc. Then there have no way to write
any variable unless user remove some NV variable.


Thanks
Joey Lee
