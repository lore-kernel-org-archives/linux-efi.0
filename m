Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904033;
	b=Fx3APfVPfpgwxgsiwadMaYaP7HW2EgRcJWwS/UCQyTLJ5Ced10kmCIz7NZQVrGk32nrN
	 tPVWyO4FJgPcvZDEKtjU3uOqXGybStETmULwM7BkEFc9+odhU50n0SnuenNtn47gUtVZL
	 f+oamgd2TWKzppwtDFzYnguJ1Todqaj1WeU2YtaRXlduOFVjMzkPgQYRxg5lNS8ToSz83
	 TNCjkWAXK/LBdk4oZlBenM9z7Hj3YvctlNTYCBBYIOomFt5PX1qzBdd73Kv9zn5+Ah2PA
	 2F097XfsaAQdJZzEWJYWgJ1cIH5VF7ab0NjzjtKjJHoKTi++aBJmP1ooFhj2TQQwFvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904033;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
	b=RffS633LviuQWFTIp6ZFz3GH3Ddgq6uokBK8iqnI+sllur3e9CHCwRETHpH31sZyxkn9
	 /78Smsdhjxwqvf7FemLcE2OSX6jTxwbheu1J68PcrwcdSJX6KGZwPHETZsVNlfzYbi4DG
	 kzRzBSQjjmPgAABfp+aPa3zq8qAjtHPzzkTQ6B3WyRTTox7pEhEJdrDFB9BoLrTLzw/TB
	 ENppRCjNH5xdUCNz/53eBLzjf5p8annSIeZrSYD1fyDfayHwsZ4lI14D7IGKMkPvDDuAF
	 +5hBGUll8y06h1DofvwkoZGs2UMi/1iS8sVmwinT6jQdDaDvjLAjjenVyhcjKJ8mSDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=m3Y+iV2p;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFB1606A331
	for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 08:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFFB1606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=m3Y+iV2p
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so21934125e9.1
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 00:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904030; x=1795508830; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
        b=m3Y+iV2pelmutPYORVxza4CHQMpjq7iS5lmecWgDjvax6Coso4uWa+KMaCm+CB3bWY
         yM9xDjlaUDqClL2wfFs+3EgMKFX4Q8fuLgup7VSVEO3iDYFOyh4nyeN0Shri07+KD82b
         UFGbuWvBELdRnXkiKa1GIWjPRb4Wz8WRQUErt4eMboeCaxWHABbQwTZk6BuPw2NopAXW
         5935wwOL0Ggt8LD7VeJmtmL6iC6DgtiD4S4DRbEtkaj1swNFS1XEbe90cWaNyokAE8Lz
         Ulc1c4G0eNVUIpLzTdbViN3HgCOMoyHpu6hnCIZ+utcpbQY02w1kBKtCyN8iaUfGq6tI
         6sqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904030; x=1795508830;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
        b=PycKT83pV5TIjEUhYhpJSlz09TDF9H9XjghukpesrPGwrB5DW77n9nqW9wzzcT69O1
         3O8eyJKy2eQkyAIBXVSzhSj39HI7YX3cOGHkxwJllBv7dSWMeCVh+ZoQu0oLXDVAUR1z
         k6Sm+Kx6ZSXnB1weERNmtwOGyLL3qpIX3wBZVeY8BUrjqybdiXhpxdVStNvqD0dgCU9S
         P5FiYgdlc6zne/87VS6t+1C1pJDg7zoO/86oNiKaiHWw5/NSK7uHwFLKy+o3thCjx8nd
         +YUwrdkOrGo/7/RPbz4PTtHY4tuUz7UI8mOhAtgFLndS1y1ZJciTkZjJ9upY6xhdAHcM
         BH9A==
X-Forwarded-Encrypted: i=1; AL+hErHTDeoWZj2P0WcnC0LDEWvHJr+24IKJihEI+L4z+RvWi4iOCpfEAu13RFPqeY3wlseovbJDHXKqEHc=@vger.kernel.org
X-Gm-Message-State: APuU4Z87uuPhHY9UzwFDQEJ+1CtFOdFwJp5aec6alzwIoYXnI2qv40KP
	0cR+WmS9reI8Fz0W+e1z4fRyS2GQkvz+P5ZNiSCIWD+vaZ9lJuW70KHO744aEvta0VfJ
X-Gm-Gg: AYBFou1q4W3FUbAfvQm9/r4yCb3rvgVzV/2j8biMsA1c2TAjF1RTd704MQXZYM2GDm0
	5xBVK/tHfKjQxX2oLWwRq2nt5/+coraGiDI4k38l7JPApDtmetFoHH8myHYZtxZMVtyC9Fi3CDm
	ugoBNEw1Z6tdwIIsm+R3U4kEvX8hVrqnylofGgvDokFPNatl1k+7Ztm+Tjy5qIla/h8QH7pAc5W
	hMv+o4qOYSNZwg5F9xI/5QDOTGrGq7DP+T0ra479Dz68HpPvkf9xFl5kQsQBmjzGdAeX3Laj7qX
	DzY/sXa/NTrn/UbTmFlzDkLqtg2PWgLxwa4EIW1tyRLDq4HX50uRazSgnoDX8oUEwrf2BLO9bul
	E5hB55SnUSc83ljRgSEe32fyFRqlABqVftawhHQ3e7n0HcwL4Xx+syXcqYiPnqZUqMVR1Zp99qR
	tSVhYsWRbA6WvMZ2JAC/oNoNQageXRGdiD1RktRwRctNUbUjPhRHxx6JVs02XRV8vAIK3aECyW9
	C2Caep6Oi1wetLvCeFCZ0Gp8ICOO6FuAYkr1+k+tVqtWmASMqTKLBxtpUcnF7mF60zltNNm4vpE
	Ii8pgwLgq350QUxzWIlvEaZUkBVxZQICe1pOv+ucVUtVm5oFgou6rbUAaQ0ysR8dt1ydSyUUbRO
	gcv7m9uI3DHDI8xqNNdwvertiMJ8LJEkQ1UMIiUa3cd7lSPvgO2MREUrU
X-Received: by 2002:a05:600c:3494:b0:4bb:6c71:b268 with SMTP id 5b1f17b1804b1-4bb6c71c232mr134135095e9.6.1794904030378;
        Tue, 17 Nov 2026 00:27:10 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7838c912sm45730155e9.4.2026.11.17.00.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:27:10 -0800 (PST)
Message-ID: <0ec7b8c90cc456b24e5b19c1db673d497ae43735.camel@amutable.com>
Subject: Re: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Tue, 17 Nov 2026 09:27:08 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize binderfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC
> by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
> SB_I_NODEV for the binder device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/android/binder/rust_binderfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/android/binder/rust_binderfs.c
> b/drivers/android/binder/rust_binderfs.c
> index 5f020226720db..04468c5b5c116 100644
> --- a/drivers/android/binder/rust_binderfs.c
> +++ b/drivers/android/binder/rust_binderfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/compiler_types.h>
> =C2=A0#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/gfp.h>
> =C2=A0#include <linux/idr.h>
> @@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	 * necessary and safe.
> =C2=A0	 */
> =C2=A0	sb->s_iflags &=3D ~SB_I_NODEV;
> -	sb->s_iflags |=3D SB_I_NOEXEC;
> =C2=A0	sb->s_magic =3D RUST_BINDERFS_SUPER_MAGIC;
> =C2=A0	sb->s_op =3D &binderfs_super_ops;
> =C2=A0	sb->s_time_gran =3D 1;
> @@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	ctx->stats_mode =3D binderfs_stats_mode_unset;
> =C2=A0
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &binderfs_fs_context_ops;
> =C2=A0
> =C2=A0	return 0;
