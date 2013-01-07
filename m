From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efivarfs: Drop link count of the right inode
Date: Mon, 07 Jan 2013 21:41:56 +0800
Message-ID: <1357566116.6113.316.camel@linux-s257.site>
References: <1357333116.8203.50.camel@mfleming-mobl1.ger.corp.intel.com>
	 <44edfa54b80aedb674bdb482eef4f559030d9bf7.1357365172.git.lxiang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <44edfa54b80aedb674bdb482eef4f559030d9bf7.1357365172.git.lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=85=AD=EF=BC=8C2013-01-05 =E6=96=BC 13:59 +0800=EF=BC=8CLi=
ngzhu Xiang =E6=8F=90=E5=88=B0=EF=BC=9A
> efivarfs_unlink() should drop the file's link count, not the director=
y's.
>=20
> Signed-off-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>


Thanks
Joey Lee

> ---
>  drivers/firmware/efivars.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index d6b8d2f..60f5324 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -995,7 +995,7 @@ static int efivarfs_unlink(struct inode *dir, str=
uct dentry *dentry)
>  		list_del(&var->list);
>  		spin_unlock(&efivars->lock);
>  		efivar_unregister(var);
> -		drop_nlink(dir);
> +		drop_nlink(dentry->d_inode);
>  		dput(dentry);
>  		return 0;
>  	}
