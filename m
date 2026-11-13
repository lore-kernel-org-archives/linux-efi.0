Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564919;
	b=wjKgUeIFPqIaM4DMuF2rtnxpCVY70Wy/cMfYL58InIS/V7QEFBZt5z4BRcrW7P6LUxlx
	 z5Biiy/3tWcQeNp8bT5Q1RxkBYScvHJiNIanRPNe2DtKdJ6aHkWNzYTthfnNyAzkPVbq8
	 3bet7NvZRBS4RAst6ZJrBRQfDJMX4d8mJ2ghvr8qUYr26Ca+eVDbpKSO1Lya0bTj4tzHq
	 4zYTg6HGVGX6eK183SiuuPhjMa2dGNlLZFcdSMA/QuKKeQ5BZna7+NQKMAn2M4/bU/a8B
	 ygjnsMaycOucnFRQbZa/dXcSAEC7G1f+Y/DRF05Y1Z3aR2yoF5bf8pwiu+PgMXp8c+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564919;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
	b=LrsN/gqOPCxj+qgwuC13p4WpaV7J3ReQGftfh7k2adrcCri3uboG3hd7Xa1GZemV8ec9
	 T1ZMf+KuP8d3AVWURLZoukLotRcCueQ6YSBJl6Sd2JpfoitFA2O/nTbM4FM/GiK1K4sSy
	 UuwdpiDqD9pk6SoF2dT/SiU5ieaPpy8DVSd2MwVLzdJtPKUVGWlLnkjKM9oCR5cNwY0wS
	 NJFYHGfhp0sYvY0LRRjjuTS14ko5pUBOcx4eNFy1qflG+s5j5xxQPYgatJ6wH1LtZSPR4
	 /X26KIfIuv81BAhF9FbYWExKigGtYLij53pqP2nxYKm8ueJfqJmYS+Gc85qU+MarsJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XokUN4uh;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19CF606A8B5
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A19CF606A8B5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XokUN4uh
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so5374055e9.1
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564917; x=1795169717; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=XokUN4uhZ5cnIDNPS9kLjfaPp8ZSmyDY7nHz3ffF9uftFGQzzc0NaUd0CPxl6tmm/G
         EB2bqVZrrrQULKzHfxmMlarOF7+NP4G1EuGLp1x7hwkFzcf5DKQIlYH5+zTWTg0qLXK8
         Q27+pu7matN83z4kFimCCYFY9EtcVBpSYh+f+WbPWczzC82gi2dU1+IxENiNgIvD4ssI
         1POQJndyP8zOY9I/drEtHc8Rir/wcokVwFCL8xkdsULqRcKqvw/m2pftg5e6OYSufYMA
         FPm06vn59Z5lYx4UA2FpKr0UjB0BBdejlJLIE+RKFWt9/d0/clXrD3SuYpmwDbHdW+74
         JQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564917; x=1795169717;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=ypkb62Yj7cmUuWsNubIs1M6qfWtFTgEIWviuKYolyA1cxREqsmfZVIyYY5xSb20+2F
         g5qC+44WOaFjHV2pb6D+P0sbMF4QOV4bRBsq01tJlDrsE0GnCouK10hD/IZYVaD/aiPw
         SpaQI0TdNmiPQP0PNO2HodaOdxopQsed5729nFxzQeV5/OPdgyoVbNUE4Wnqq++kbtgR
         +z1J4P5GEes+ZvI0laJsBBgSkoVHWRr4T2vyuqT2SLpgxukb/2ABndnAY4gR1VzYLTfB
         tFMjrtzx4AFp7vl3cE0v+VFymnCqlTG4WwlGnY9H2952CxjkSgUHUKfKXHbwcIvxyFGh
         Hlgg==
X-Forwarded-Encrypted: i=1; AL+hErHnERQoQdDxeKEUQma1s5Ef58kGQXUno8tQLociuBRB3vDAaTn9WzhuOhFKwSLYPxrlRaQGNGuiJH8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/WZiWqYv5HGSalXgKXYiaUfw5tgM818Z9r4dBDSPr9ZW4ithtn
	3VVszRIXs1zeZe4eyujluPDAlsZ6MHOf9UN5qJE8V3H4zooKWEfs01SO/qOH4fYT3rsT
X-Gm-Gg: AYBFou3bUHhntPs7MdTJdQisB0X27uUEZfkMP8MCllemDT829wBOz3wq4a7MRBJ3q/k
	51rBYO4eb49x9pYgi5GXgkMQ8EHhWELXtuzNeH9C50wm0H+qkJLT+oirAxznM9clXfSmw5gdoRs
	U9WxcLYiZlRmjIFuB7q9YjT9pQHjtTLGgv7xN0QsrDXkFm674DUYaXydj0x5Uk3+qD+f822X0xy
	jiwiD+mXx9JUViI04R7BA8+tfLvgKTQebXr+twSDwwhAFJLx+yFBYBZWz1Ybmg+NOkF/1eE9Mgb
	W2PF+I5yGpHdxOnYB62uYvQdu1cBBM/nGwZLjGLD3CBegfR7U8YmH6nVN+dv7wXV4JrMg1ZhyZl
	KKa09eDu1y++34HUUHc0cfqtYrGGT/7+xY7fImi6FBs8scWSGAINvBk4JDSCi2xDNgk+bg5D3mZ
	t7cobJhWcb4vO4R8OzPt+eIjkgYbzhZAf6g7zoAQN/g2Aqg7ZQ5rDvYmbST/E1VGgQhLVs4SDLB
	WG0TQjr7rYYtCrVZiLdccUtuo+/2nLAnkkEzppxC7Teb5eps3Vfp7hNAeKths3Le70h6OVNEbGY
	X7IKbvTnJk+aewgjPvnWYSOYlcfZiVjiaF/olC0r3F/1KYsimB0eBZa1upOZgkA=
X-Received: by 2002:a05:600c:4f84:b0:4a7:7f3f:6f8e with SMTP id 5b1f17b1804b1-4bb5599ade1mr43492835e9.0.1794564916955;
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56680ea9sm31982365e9.0.2026.11.13.02.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Message-ID: <e2edfa06d185acd86b46945622b6eb6dff97b307.camel@amutable.com>
Subject: Re: [PATCH RFC 33/41] fs: add file_is_pseudo()
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
Date: Fri, 13 Nov 2026 11:15:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
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
> Add a helper to check whether a file is a regular file on a pseudo
> filesystem. Only regular files count. Device nodes on pseudo
> filesystems
> such as devpts, binderfs or the block devices on bdevfs are what they
> are.
>=20
> Look at the inode that actually provides the data via d_real_inode().
> overlayfs accepts sysfs, cgroup2, debugfs, tracefs, configfs and
> securityfs as lower layers and reads of such an overlayfs file are
> served by the file on the pseudo filesystem. Checking the overlayfs
> inode would miss that.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0include/linux/fs.h | 12 ++++++++++++
> =C2=A01 file changed, 12 insertions(+)
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c..407ffb6342ec 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2553,6 +2553,18 @@ static inline const struct inode
> *file_user_inode(const struct file *f)
> =C2=A0	return file_inode(f);
> =C2=A0}
> =C2=A0
> +/*
> + * Regular files on pseudo filesystems are kernel interfaces and
> must not be
> + * used as storage. Look through stacking filesystems at the inode
> that
> + * provides the data.
> + */
> +static inline bool file_is_pseudo(const struct file *file)
> +{
> +	const struct inode *inode =3D d_real_inode(file-
> >f_path.dentry);
> +
> +	return S_ISREG(inode->i_mode) && (inode->i_sb->s_iflags &
> SB_I_PSEUDO);
> +}
> +
> =C2=A0static inline struct file *file_clone_open(struct file *file)
> =C2=A0{
> =C2=A0	return dentry_open(&file->f_path, file->f_flags, file-
> >f_cred);
