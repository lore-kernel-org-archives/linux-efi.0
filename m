From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: Cannot add new efi boot entry
Date: Wed, 17 Apr 2013 22:51:34 +0800
Message-ID: <1366210294.23707.70.camel@linux-s257.site>
References: <516B1ED3.9040900@suse.cz>
	 <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com>
	 <516EB1B6.7050506@suse.cz>  <1366210184.23707.69.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366210184.23707.69.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-04-17 =E6=96=BC 22:50 +0800=EF=BC=8Cjo=
eyli =E6=8F=90=E5=88=B0=EF=BC=9A
> =E6=96=BC =E4=B8=89=EF=BC=8C2013-04-17 =E6=96=BC 16:29 +0200=EF=BC=8C=
Jiri Slaby =E6=8F=90=E5=88=B0=EF=BC=9A
> > On 04/16/2013 12:11 PM, Matt Fleming wrote:
> > > On 16/04/13 10:56, joeyli wrote:
> > >> I think I just got the same situation on my side with Acer machi=
ne. I am
> > >> trying Matthew's new patchset hope can avoid this situation:
> > >>
> > >> https://lkml.org/lkml/2013/4/15/473
> > >=20
> > > Please do let us know whether the patches work for you.
> >=20
> > Hmm, where did efi_query_variable_store in 3/3 come from?
> >=20
>=20
> here:
> https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/=
?h=3Durgent&id=3Da6e4d5a03e9e3587e88aba687d8f225f4f04c792
>=20
> Matthew's 3 patches all merged to Matt's efi git tree.

=46orgot mention, in urgent branch

>=20
>=20
> Thanks
> Joey Leeg
>=20

Joey Lee
