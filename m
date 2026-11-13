Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565648;
	b=KQ1SoXKbI1NlZHOWgHmuwPS8MGIusKif+9K23IOimYnrgzwDnikAQEePLkZA03X54xE6
	 62nkmoiHYrEr7fOEnJqhtVD92PNS/Z2HLNcuoR7dfh94DxyH1PtKEHMEwR68i632Nk+6q
	 vdWOaa2hFV+9QSTovvQr/SfY+8sHc6d26UN342LlmrPT2YdfKoBMO42iFx4lj/1BYMhsT
	 PFUNW9whcyFzxclWHghLGRnftnlGiTp3rrPCpJaXvXvrS2HPYniqwDo0gkyO5OOCZLWwy
	 LNTCDA1LQxhfoZDQGKPSz9YQbcYX7r3BMNAk4Sb2I1k/cMmM/ydolp/E4cJ5o3y/rFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565648;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
	b=GxLswLXxhNpDGl58/D6qu21qSWSM5Xvr9HRLn91QmtkG8/alJxr3GHp8B3LScsEGEbjP
	 iLj2egU+2RLHy5bf6x9dt5azfGhk7SWMddTvo4sjMhxFh20rCHQwQZCjgIF6OyC1m87jZ
	 sQt051PQznRejX3/YqzM5a5qbU2pG0BanIOd5GkzOUrVu6dHGNJCrFE6/O+Z4n/7K7ETr
	 ABeae0NBEeAxNLeMhIfHrtg3PzTqtDaBZrlnPOEkBNH9xSG84autOIV+xJ/q7GaFRNxOw
	 f4DTbD/bJ3HKNItXmOF22yhUpXN/x6MjNy52USmAd3T8eI0sFHaNac/g9+8T/YgNmVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=N7Ff61ik;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CB9606A327
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:27:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42CB9606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=N7Ff61ik
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-49465892f7bso822120f8f.1
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565647; x=1795170447; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=N7Ff61ikIQ27nXVrR+i5fFuiFp+kpNCkSJ8kzzwXsWXF8oHPQYaaEtIn2sVJ/R61Yt
         eN/EgbWtaqyPzsaKr2MVnoSj+msmKBheiZS6yCjGNfIw7Nev7hKixHBvdeyifMwCAuyY
         p4HuC2pLhsdw/6s4IDRTQYVk2XreSuuUeA2/lEtpnIKw65+UPm9cBNCU3JmsoFXsrPGj
         WUoovGImF4s4dFS6xRIsBa0e81egoKAVqgb5m7AbWjvbiu6rsFasaFfPaH+ik5AAKzYn
         61DshIaK40jfv3WiwMjZKKDrEIOQNGX/IDgIqQj4sI1tIu9ZETTA/xF/QESgBcPouNO3
         9yyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565647; x=1795170447;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=rzCzmU/p8obOH80NIkh42n/pA3fjAQ/9o8L8FoKEul95o4F/7isOb+Kx06QHfy5CpY
         /U6/HVBg2Ofc7nZK7QA6agBPS4D24r+5CCX3sPvQwLYvb4N95J3qCCYysCA+xTz3F3zB
         fEaDWKoE/2qpidBF76Y9MYJ7H0ZHbUfRN0df+iGmLeWFPQUxnSPcyuZDJiqzApRi1gOE
         VQes+XpiOTgyUXobWuF2ITlik9jIFfVcW/fvQZjJ72D/5zxdOVLakWc5LED2JebuGg9d
         6uD8+4rtUgLOsC6A6zi/RjBVHW3z8l9qCxkM8+npqQmdflUZYJTQFv0I0Du0lMQlmI/t
         cyhg==
X-Forwarded-Encrypted: i=1; AL+hErGHNAJLw8DppsIJ1YZXPotAXZXosLfvgJ2gsypNWnsyRe6QQ7sJ85yw5CQmJyrJImxl2cBDMXQK9R8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8IjD8Fn/ma3QdYIEtZXj7Y5Smqo7Lc1ShtIm6NewDKdjIlJzet
	RbL+gEJjALNLJm1J/HcmTbhlyO+WJ597VM8/K+x+7JcvY1x+HF31g/LHxvo+9aXpu9u2
X-Gm-Gg: AYBFou2LaCtdbxkTjMwrFNxKuUiA4E6sU3ZGuAkFMXXUTjiawKqXwGOaW0VAcYEE/fi
	ezx3BKs5hfYvupXcCxL/je6cxcBJvIEOFa26q6aIdqy8lFgKB1AzBDI1lT2vys5En624+PycKCY
	pyfxtAOtP65mhTpSi2F5pjPH36M+oBiSFaQ8V1Ip6zdaNPTNuWtbBtLiZrBWUKtv09mBjfxif07
	Y55PMl1MOcSY+TYuWGTdTgE7k0ia+R+CbA4A1/nR/OFj6ylNL/k6jj8jncLVe8htkiy3YgHJ40i
	yaDrZ8CPWh+nDei2+4+pkralOpENtF3Q2X8aKM31WA5+J/zM3aESzRxZBjNiiT/S3fPbqzO+EYG
	VzpEuilkYkoBe5xTFuoh1plNjVeGYK3XiShBA2X6S7pzL88PRiAbs7+lry0cCEYaUkOQrAslK1V
	eJ87R3Z84Gx2AYUrZXKhFmknRqy8Nt6TpnxHpuwKPgdHWKOhcsj+kHxsl32t6OZJ48nWkbUbF4p
	DBpOB9ksERIXCveY76jM7vmFpcpN1OMk+HGqKAMAyaZT9OrQtBZ3V3WJ483WvhuGawZ9dwYruvZ
	PuJ8MMy+75kBr9TmaqweUSmC9IKr/Er4LThTWtBoSpP3Pf5BYPzI/26JHhWMNZw=
X-Received: by 2002:a05:6000:4707:b0:498:c419:3728 with SMTP id ffacd0b85a97d-49c713ae367mr4463557f8f.22.1794565646661;
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm5077482f8f.0.2026.11.13.02.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Message-ID: <0c109a58804a2d782e549af6ad13e89532d9f9d2.camel@amutable.com>
Subject: Re: [PATCH RFC 40/41] erofs: refuse files on pseudo filesystems as
 backing files
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
Date: Fri, 13 Nov 2026 11:27:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
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
> File-backed mounts take any regular file as the image and the same
> goes
> for the extra devices of such a mount. erofs reads them with the
> credentials of the mounter so this doesn't hand out anything the
> mounter
> couldn't read anyway. But files on pseudo filesystems aren't images.
> Refuse them just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/erofs/super.c | 6 +++++-
> =C2=A01 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index ce05557bd998..980d5fc2b576 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -158,7 +158,8 @@ static int erofs_init_device(struct erofs_buf
> *buf, struct super_block *sb,
> =C2=A0		if (!erofs_is_fileio_mode(sbi)) {
> =C2=A0			dif->dax_dev =3D
> fs_dax_get_by_bdev(file_bdev(file),
> =C2=A0					&dif->dax_part_off, NULL,
> NULL);
> -		} else if (!S_ISREG(file_inode(file)->i_mode)) {
> +		} else if (!S_ISREG(file_inode(file)->i_mode) ||
> +			=C2=A0=C2=A0 file_is_pseudo(file)) {
> =C2=A0			fput(file);
> =C2=A0			return -EINVAL;
> =C2=A0		}
> @@ -835,6 +836,9 @@ static int erofs_file_get_tree(struct fs_context
> *fc)
> =C2=A0{
> =C2=A0	struct erofs_sb_info *sbi =3D fc->s_fs_info;
> =C2=A0
> +	if (file_is_pseudo(sbi->dif0.file))
> +		return invalfc(fc, "source is on a pseudo
> filesystem");
> +
> =C2=A0	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
> =C2=A0		return get_tree_nodev(fc, erofs_fc_fill_super);
> =C2=A0
