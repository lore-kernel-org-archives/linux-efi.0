Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564223;
	b=i5iRCCqItq3/Okc0pDRLI5uirgWY1HC7JZFBF9KM9Rmk8zm2BCOs7n6RjwwoAx5ikJcY
	 ebimio3H2EGVN9ow6nZurVs0Q+LTHHPWls8YocAdteZI7IR4FawsI8YPXkqhj5YTXi3oj
	 xXgTaeEflzG917vPj9pHwPqd8WabMaAfxa4QD67CLMQJakZfvDENBOs5VgyH1TQht9zBQ
	 hx6pv/kVyNuc5O9E8yBfMtJfUxkdqPyhU8B0kMwwUC0S+KFrXjvMXmeYyfJ2x/X1i4UES
	 nUfub9YNsxHvttNlyXv44QMiYFJjNpASOTK/+jNufJiUVHy3AxFlHZGWj9a+xvgtGkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
	b=M9n/xHWtr9QPei16nBn05C9WAkqcBG+jjpl4Uipohj2XIyEPPzfZ04hzGRdisI1l/ur1
	 DJeAkHjwvvIe7qJX4hwKR3WNxQtw9X8uL7kE4lah5UGLZ7bcg4ubCbu1ujPmm8Lsor+Oy
	 GnFeIwJPCo5tPf2JLHdGPc4/TVfZNIS+3pISnjtR4x7Kymhws0Vm+iAZONZR6a/GtYIJG
	 4f+tWooddoPDdkpl34vb04oIRjW/+O8/KWRXr10ffU3NeatS7732b6BMMiHrzG9nXGB5Z
	 WfuXG8ICaZZad1TfqzFW5pbNLFmFqBcz5rX0gX9T64PKUkr70ZZ90zjp24J0fyg5FAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="YppAuU/f";
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA94160A2626
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA94160A2626
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=YppAuU/f
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c40e30c26a4so170618166b.0
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564221; x=1795169021; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
        b=YppAuU/f77eWMTZ8F/Y/RTjltBDd6igz4EttMolmckndL9mvAt3euwqVCnUFPcnj1L
         wpVFClVgg0YlcE6bTABHQT1NnQyujG09t70SZ+IGoHQq0qQgGGwB+4JQikI2kaQwvi8W
         H3KupRONVF9kXu90kRN/xwbfNoANJajav9pnhnb3IMIJ4A6DWEq+8017kOKRrUT+YN/m
         jRUDmGHXRq1c+43Y1O2K5XEGEQl+nQ8YkAZ+/5vrEItOhIamTuHGEOkZUAeGsE8baOwB
         Dj4haSBpRwT/bMXANPqkevI0ogqYaGkZDRE/CPrkXlmZ9T16K5sayD5Snik8DtXgYcT5
         haBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564221; x=1795169021;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
        b=IqeTjdt5sQAu4cHqIKgpjy9is+3MHRQCfEQ4/v7R31Yef3cFNxojX8EpB0UEBOYX/N
         hK4EVKPl91WZFdrK4/ps4b54EtVpfvAgcoJJO8jItDGkhmWZgMDTJG65hviYZnNWADdd
         zcZfMlG+D+Sev/4C5MB9kbrDXK5nYbAOEOOepCvMEIf1GaONVx9BHYV0zQ/DVZQmbRWl
         Lqk/zc9aFk1l6jHh627cD15PMh5yiVTxQUfljhB59YEf3sfy25dILlW0R4Jw8ucbI28v
         wzk9u1HaUD9nO1oXgkV7uD3vFBStxQkOTgm8CTRaYQ3G7DO9ue4Yuv4fKStm5asPrGBr
         ru7g==
X-Forwarded-Encrypted: i=1; AL+hErF/TfRVD79TCu6kHasj96Jl6dOoFPRw0vaeOnQDj6UAivWSCyN4ZzNAEjEPmrYcAfEzL5P4Iwv8Tf8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+D3Z4q5/a5ho/wwWjK217SAWqVaVHx5xMtN9pvY1402/1/Td4f
	PLCcGbPBF80mtmKUEWvO5EXQ17cadMo7Wr1jvQT3yvxMb1CbxAdgIeJg+J20Pg3PlpH8
X-Gm-Gg: AYBFou10aPmdqf+yw6tO0eng4wnsiwOFNw+3zUXwsv47ZnMhyAz63eHOdBUK4Bq/WRq
	PWZBfuN+JFYROA0Sl2gELlhPzBdI4fvEq4kTsXEBaD3ewxYp9FIlss4O9WLNbUsDBsPS36FyGOR
	9/C6vqhrocIbPgrc4lGp9wN9hjSKgP/xvvU8yhz7hoAZg4cuvQolZ8ckrmFZ37EH9TOhakbh4Za
	6cqoE5KT/z3r0flZCbOW1g6kbg/2ICx7GbI86JM+LZLNdgiVD9RlALEHr48AsF3tO0uEpcVqdfb
	ueNyrvwqaN/CcnCvCa1JfhOUB1g0wDTj6XXe1kAHtsMUz2eQfxN3vxKEKEPdIc8X9it7yS1Pmr0
	ygo7+2EMkvBCHIzpiwL3/vyLQCMjedoevLOP40fIldZEn0m6kOspCzNfZZXGRqD+j4rweHLDuvS
	rFytF5fvpdZbsN2cT5TNbIbjkhR2kU7iYMrfYRExI+N6WWAxtRAT4q2DjnALtIz5f8sN6lZ/H+l
	a4dmV6l3OCCPZS0ePPFlI6tQUv6xMx5gdEagQkcH/ZtNe1aHyddbCdqyqkwuYfXqClufntdTMW2
	912Gu/VzltBHndUhz9X2wq6FhzTin3gglEY5c306KPeRy3EE9iF03AzbPJaPwLg=
X-Received: by 2002:a17:907:7b8c:b0:c42:bc58:f21 with SMTP id a640c23a62f3a-c50963856f2mr175546966b.15.1794564221164;
        Fri, 13 Nov 2026 02:03:41 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b23b3asm74752966b.27.2026.11.13.02.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:40 -0800 (PST)
Message-ID: <cfcbef5caf7651b63774549fa1999d34981c78a4.camel@amutable.com>
Subject: Re: [PATCH RFC 09/41] bpf: use fc_init_pseudo() for bpffs
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
Date: Fri, 13 Nov 2026 11:03:39 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
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

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0kernel/bpf/inode.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e..57cf3775c076 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/kdev_t.h>
> =C2=A0#include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	sb->s_magic =3D BPF_FS_MAGIC;
> =C2=A0	sb->s_op =3D &bpf_super_ops;
> =C2=A0	sb->s_xattr =3D bpf_fs_xattr_handlers;
> -	sb->s_iflags |=3D SB_I_NOEXEC;
> -	sb->s_iflags |=3D SB_I_NODEV;
> =C2=A0	sb->s_time_gran =3D 1;
> =C2=A0
> =C2=A0	inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct
> fs_context *fc)
> =C2=A0	opts->delegate_attachs =3D 0;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D opts;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bpf_context_ops;
> =C2=A0	return 0;
> =C2=A0}
