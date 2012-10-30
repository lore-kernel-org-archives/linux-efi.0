From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efi: fix always unregister kset of efivars in
 register_efivars
Date: Tue, 30 Oct 2012 11:07:02 +0800
Message-ID: <1351566422.21227.49.camel@linux-s257.site>
References: <1351493576-3094-1-git-send-email-jlee@suse.com>
	 <1351537904.14888.44.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351537904.14888.44.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=80=EF=BC=8C2012-10-29 =E6=96=BC 19:11 +0000=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On Mon, 2012-10-29 at 14:52 +0800, Lee, Chun-Yi wrote:
> > The cc9c97b76aa7235d5a1de0f74f990097f77008b4 patch introduced a
> > issue that always unregister kset of efivars in register_efivars.
> >=20
> > This patch moved the kset_unregister function call to the kobject c=
reate check
> > block for fix issue.
> >=20
> > Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> > Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  drivers/firmware/efivars.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
>=20
> Thanks Joey. What I ended up doing was squashing this patch with your
> previous version and rebasing my 'next' branch. That way, when this
> series is merged the bug will never appear.
>=20
> Please take a look to make sure everything is OK.
>=20

I just check the next branch, this fix merged with patch commit eecceeb=
,
everything is OK.


Thanks a lot!
Joey Lee
