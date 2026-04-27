Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516DE356A12
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 07:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777276193; cv=pass; b=VSxxy654E0MS0wAC4FuXiLFPnY/zVzIz6zRe0nXVEKBRMkaAZFgUourqBEaPfA/8wK2sRa3Pecl1c3tRDYyuLyyXn6i5YPYwkwoR/nYCuGsWJ1I1aAMkI8fyd/es18FO7gAsk+B23i1KL0q5++TfeTt71a+girtMqn27BQfUjco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777276193; c=relaxed/simple;
	bh=f7OgKalAyVt5gmyU2LJSzNsZnB4DtET7GNZ8+Zt9tWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=seD5uKLa4oTua4W+oKEzNpy7uDv1MPKL85/l2naPnumkHH5h12lDlntWPIsM48Wq4cL9R23JLgQbBKmpMHaa16iBaRW+6oiksnCfFLQ5jRrMBoxscKUW4yFmvIPCMq1bBgUi15RWdE4IgxahiZ5zomomtmpu92H3Q90m5GjLvgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lf5ppi9A; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lf5ppi9A"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67785ef88feso6921380a12.1
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 00:49:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777276190; cv=none;
        d=google.com; s=arc-20240605;
        b=g8emxXzfIJsl56X3j1hhVwIRF5yrkjIFDMwaYEL9C0ItWySYrlH2/oWgjpTb2lyVMJ
         BqOIdnKt1TxAPj8sFVfsD6lh3rBwpZMbhQhYiD02vwB+VEtEFIfAmfBR/7mOvDmNcIoH
         pbxOv5SompRgn9sLHEPmdgG93ZjKy1s0XDUDGEMLAdXoeTQldlNP0wjEeHFbcKpB+Hoi
         4jbwW/89PMEmi2nMwi/1BaWBXqSibkfw/yadklxp4p6tGjqvCFXEdtpFBQp5woFO/0vs
         ccj7CP8LC6aoN7rYpKvdBanRtp9YVjYxp9KfXsud+9pCX/vqcEeEUZHfSQ/vYiVXVbSQ
         i4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M+JJEH7a7ZgWwJ+BUNcwUv/jdbyBTQx+IMzVRjmXkV4=;
        fh=KqOOrHjtsq98xfQATkaG3voDi6/N5No5zOaqS+5oTV4=;
        b=FOzMe48PBwC0WI1uWnVATZf4lC4BA9PuWhR8skDDDQhd8m2hheIqXWg541LWuMhQUe
         pcb3ledN/F2HGxYQmRf6B1yAaGmfgWS0qNoTtE/dFEdFlH+eCWKAVXfZhuICdGyIOnGm
         MSxHP95UbHl1fUW5k5nBpnkfGqapFQ/KNvKdXYDTGnTB0558tV1DcYdkH7TKkh9ICT9C
         BlZQLC0VnYAbOBDGXLFCNa2ArqxcdqWgc5IonP91dlhCUsFGA86XyHTOfpeQ4T1YQsZD
         xOqS6p1SVvepZcOA7Gj4TvUJ+vdvykBT1mTxAh1AV6KDZimVg4fvlEMuQXkgN6VuvwbJ
         wlmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777276190; x=1777880990; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M+JJEH7a7ZgWwJ+BUNcwUv/jdbyBTQx+IMzVRjmXkV4=;
        b=Lf5ppi9ArV3tMF4TQI1tAC9lpKfF6UauWPDSK4QmAzWkDz445wbNgYCno88v7X0XbD
         VT4/2UAahAj7BPtuPfPIDzL7dOadMKIyWTCT6rF/ukqMZAIGIckYT4HDod6oSGb2zDNv
         j3GQddJ5sDWomFGzwAmORYvdN8WC+CI+iQipilmJ6w/tMAVoXA8I3hjFRx159tHzYZnH
         hRp/l1FOVr6KBn4F4SiNWO6slthc373Hi9zhjcsloCwYmG8oiu9zTNbfegZCB8p7dV++
         VmVGiNU4Vs4aNhireAP3YhcditlXAX0/zuSWuMJEZ+f2idZ962Yk1+Zx6eB8ZgEQ1HBf
         i6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777276190; x=1777880990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M+JJEH7a7ZgWwJ+BUNcwUv/jdbyBTQx+IMzVRjmXkV4=;
        b=KDMTlrMgTaOGIQ2Yuz6IFa7eefwe/7M66PIsFtf1u4t1lh2StIXDm4TZat7aqfoMjT
         fmHyKL1gUPWFPCvnGbnzjLumJkWGRiec2hWAK7fSvnpR4Whzj+Y9HAEzyCLRpz980RTI
         NL6OGq4fUp4B6a3nSMCOzp9j1cc6Y6ehed0pERUEjet1O5Z3/taG2mQP6HmpWzOlOeDx
         u3ABKoTk5Sas8N9DitG9niDozmFape+YDSAwgb9qTP2a6SPB6zhv5aOEsZVNSfixDV7c
         gXs7foxYVAy314m4ca7m8DAKdRn3EwAdsKhSSP57cw0nLuSAUy2ZeQZhaY9v1DFT+eiP
         q3xQ==
X-Forwarded-Encrypted: i=1; AFNElJ9//o8+yVXrhaJ0P6sQ67GtwLsejeqQRMYJmGj6Iw2IGXKbpHTlU3WZ5myXjQCeiN2sN4B32BFq7ds=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe/HmF4UGtzmn6oa8mXDSvVvrXLGzyG9f5W/KHNY06RQJ8s76o
	5A3Q4g8ykSDg1YsV9i5eLdQDdinNovJfXLenodIYBkkKIqbxuNljbl2/pODhbq75K93SeeHF3iL
	b7KmMjpTB5i855fIk8ilNPIxNw1vRg/q5tu2F
X-Gm-Gg: AeBDiev8GjL/IkK2V5X0PDrbmtvTWfeEdP6y1Yh8+Mhbd7RAGB+O8Ik3P8r5Hs/2Xta
	/Dvi3GXfgcUgq5+dXnhldtUWNasQMAl2Ga59fogM6gGZnPyRGAlb82UbWEcDKcTt2tiudwDm8To
	PFF5WfTAWqMka/+EGAW0hW5BYGQVM6jf4eD1ps8Pe21Q6iAgOZaXOuYLVrbIZ+6JC17XNupMLsb
	tLde3YyHuyMT4/O2VKwCPS37eEUFT6CfcsyX3YIrxcYilBREgEmQiW0N120n1Z1O6z9jLwtvfWM
	dwu/KitHfWW2R3RF44CF0lSO3uTR+7unoQP5DPlJrb86ryxTBw1i
X-Received: by 2002:a17:907:a604:b0:b9d:6a05:64ab with SMTP id
 a640c23a62f3a-ba41828cbb9mr1910538866b.8.1777276189333; Mon, 27 Apr 2026
 00:49:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-9-neilb@ownmail.net>
In-Reply-To: <20260427040517.828226-9-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 09:49:36 +0200
X-Gm-Features: AVHnY4KLQlNudAoMusC5eQkonz2WBnBqsh6v2a9sQQCshqNF5gfekEomngG1TZA
Message-ID: <CAOQ4uxjj6iJNnwUqV+cRtqo4qRD4v-f-ct92=ofCZWPDATXM7g@mail.gmail.com>
Subject: Re: [PATCH v3 08/19] VFS/xfs/ntfs: drop parent lock across
 d_alloc_parallel() in d_add_ci()
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 6:07=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> From: NeilBrown <neil@brown.name>
>
> A proposed change will invert the lock ordering between
> d_alloc_parallel() and inode_lock() on the parent.
> When that happens it will not be safe to call d_alloc_parallel() while
> holding the parent lock - even shared.
>
> We don't need to keep the parent lock held when d_add_ci() is run - the
> VFS doesn't need it as dentry is exclusively held due to
> DCACHE_PAR_LOOKUP and the filesystem has finished its work.
>
> So drop and reclaim the lock (shared or exclusive as determined by
> LOOKUP_SHARED) to avoid future deadlock.
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/dcache.c            | 18 +++++++++++++++++-
>  fs/ntfs/namei.c        |  4 +++-
>  fs/xfs/xfs_iops.c      |  3 ++-
>  include/linux/dcache.h |  3 ++-
>  4 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 569a8ddf4c0d..a2ddfe811df3 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2294,6 +2294,7 @@ EXPORT_SYMBOL(d_obtain_root);
>   * @dentry: the negative dentry that was passed to the parent's lookup f=
unc
>   * @inode:  the inode case-insensitive lookup has found
>   * @name:   the case-exact name to be associated with the returned dentr=
y
> + * @bool:   %true if lookup was performed with LOOKUP_SHARED

I do not understand the choice of API.
Seems better to pass the lookup flags and avoid exposing this very internal
logic in the call sites...

>   *
>   * This is to avoid filling the dcache with case-insensitive names to th=
e
>   * same inode, only the actual correct case is stored in the dcache for
> @@ -2306,7 +2307,7 @@ EXPORT_SYMBOL(d_obtain_root);
>   * the exact case, and return the spliced entry.
>   */
>  struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
> -                       struct qstr *name)
> +                       struct qstr *name, bool shared)
>  {
>         struct dentry *found, *res;
>
> @@ -2319,6 +2320,17 @@ struct dentry *d_add_ci(struct dentry *dentry, str=
uct inode *inode,
>                 iput(inode);
>                 return found;
>         }
> +       /*
> +        * We are holding parent lock and so don't want to wait for a
> +        * d_in_lookup() dentry.  We can safely drop the parent lock and
> +        * reclaim it as we have exclusive access to dentry as it is
> +        * d_in_lookup() (so ->d_parent is stable) and we are near the
> +        * end ->lookup() and will shortly drop the lock anyway.
> +        */
> +       if (shared)
> +               inode_unlock_shared(d_inode(dentry->d_parent));
> +       else
> +               inode_unlock(d_inode(dentry->d_parent));
>         if (d_in_lookup(dentry)) {
>                 found =3D d_alloc_parallel(dentry->d_parent, name);
>                 if (IS_ERR(found) || !d_in_lookup(found)) {
> @@ -2332,6 +2344,10 @@ struct dentry *d_add_ci(struct dentry *dentry, str=
uct inode *inode,
>                         return ERR_PTR(-ENOMEM);
>                 }
>         }
> +       if (shared)
> +               inode_lock_shared(d_inode(dentry->d_parent));
> +       else
> +               inode_lock_nested(d_inode(dentry->d_parent), I_MUTEX_PARE=
NT);
>         res =3D d_splice_alias(inode, found);
>         if (res) {
>                 d_lookup_done(found);
> diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
> index 10894de519c3..30dddef43300 100644
> --- a/fs/ntfs/namei.c
> +++ b/fs/ntfs/namei.c
> @@ -8,6 +8,7 @@
>
>  #include <linux/exportfs.h>
>  #include <linux/iversion.h>
> +#include <linux/namei.h> // for LOOKUP_SHARED

... this won't be needed

>
>  #include "ntfs.h"
>  #include "time.h"
> @@ -310,7 +311,8 @@ static struct dentry *ntfs_lookup(struct inode *dir_i=
no, struct dentry *dent,
>                 }
>                 nls_name.hash =3D full_name_hash(dent, nls_name.name, nls=
_name.len);
>
> -               dent =3D d_add_ci(dent, dent_inode, &nls_name);
> +               dent =3D d_add_ci(dent, dent_inode, &nls_name,
> +                               !!(flags & LOOKUP_SHARED));
>                 kfree(nls_name.name);
>                 return dent;
>
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 325c2200c501..f03d832f1468 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -35,6 +35,7 @@
>  #include <linux/security.h>
>  #include <linux/iversion.h>
>  #include <linux/fiemap.h>
> +#include <linux/namei.h> // for LOOKUP_SHARED
>
>  /*
>   * Directories have different lock order w.r.t. mmap_lock compared to re=
gular
> @@ -369,7 +370,7 @@ xfs_vn_ci_lookup(
>         /* else case-insensitive match... */
>         dname.name =3D ci_name.name;
>         dname.len =3D ci_name.len;
> -       dentry =3D d_add_ci(dentry, VFS_I(ip), &dname);
> +       dentry =3D d_add_ci(dentry, VFS_I(ip), &dname, !!(flags & LOOKUP_=
SHARED));


... and this ugliness could be avoided.

Thanks,
Amir.
