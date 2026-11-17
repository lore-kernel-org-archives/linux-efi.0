Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794905084;
	b=xK8IbawZMxwjlB+2qgUvYo4yTiHA3GAeKGndWG9EI4DwaSh3WyIwWkZNng9Mrg1t8lkE
	 YYce0QIF3biHir3G70ykRJEZSjPUl2QAcgvqkRV8MJ3s5ox6GKVwhP5XHciRGN64+4Q2Y
	 0FOrdjs7PDINRn79Rd0qMbMWnRGwmqVqe4trm755iT4NrI0h0QSd3KKqcEXhXYF1Y0zat
	 K7XzWunQ+0X50x9hTQCoLRhW+UKazcj5a6je3EntVpqZTQVh4CBthK56ndPyOYvU3cnWm
	 tCABgUyz/RkPQ0+B+ZXWMqnLWB6sF5HtWe5Ah2HgaF+Amw0tOIrydI3osy1WQ0OkQsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905084;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=YtgOPMlBsDbDRTTami0iaeC2PfdAlPMUJ3BhZBWqnDY=;
	b=ItCghlBmqz4EV2rh6KTaVomzQpyqzrBjpBornStmPwTig+mt7Bjtvy4XnZJLIdvRvQIG
	 8Z6n1Rn+L/A4wFeYsNVh2eXn/7FENhIP9ifCw8Gaikps6ijNVQIgsfMcyVjOI8PwRnhLH
	 vp4lg8RfPJS/4GBGnGyCEqb7dfjcDKlrNhLhbV3dhsvNiY9N9O833bwOnEwnwp6pkdLWw
	 IpxN0Y/nfWj+ObuhXOI59HNQp4CcGrr0f9WYGZlMGrqTGOE7EGgtLETyMdokXbqH6qKsF
	 zKvsTmRjT1NpqWM8n60ldgEroOBzGI/QfMpjPPQxnSU9RxGWgomG2ZNoz+BbP4kwa7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qPWJSshs;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCACB606A883
	for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 08:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCACB606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qPWJSshs
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so43045085e9.3
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 00:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794905081; x=1795509881; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=YtgOPMlBsDbDRTTami0iaeC2PfdAlPMUJ3BhZBWqnDY=;
        b=qPWJSshsn8vVlxONBkwnt0Rrdn9d5F3Qc4ul63isG/q9SzfN/YeX6Opt0gSo3Jew6G
         TPoHc3exB3o1TVJHb31ucJURrMLm+X5ZLvKQdkLiUwsGhwj3/4jXaF9QxR3XbUAvZwOE
         a/cd4y1UcgXoBr9kVgdvuhJuBveUAauSYuunqpBOO8ny5BuS4lSdHT4xtCJFDNjS8url
         r/ZKVJBRzaToW1BBIq0cKvkP0/i/p+OipahpXpiSl0PGBR9WYmSpn39e8LKnYXYjrWjD
         bzQp5gYJPTRPzgdIgnmtc42HrrCv5BgaqLA/tsUHs3tWdIoSQrhFLq1gvYrghbRPmmpF
         EcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794905081; x=1795509881;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YtgOPMlBsDbDRTTami0iaeC2PfdAlPMUJ3BhZBWqnDY=;
        b=YrArPaqOG0Mp6eBxn835WxNRmlWuykvNYoSOB4OGGE6Rz1x4F7myiQ5tKneARDI/X7
         7wLavtfgWbkvG2JVCQNsi3itA6wqbz0smA6tpRumCcyOHVVGkO8MgrgC+cMIpf3S1igB
         thcGq3mBopn411HI/rsClddB5XWZaBKm5+SDBojcEQyKP/rgb+3DAwhgt6sbvLGvi8Xq
         WnXoRmvwnImwHYuByld3fWMb/h8jOaHLqYEN2G01zx53NvV4y776D6ykF9DTupVpOFdp
         FiOJDUnJ6Z5ghq3YS7+D8OtFjpo9B//6aIvELDXKSPmYY6ChgH0AZykrYh79o5LyH8Ba
         1gZw==
X-Forwarded-Encrypted: i=1; AL+hErHX/ecpNBGpBg4FbxV0r+4XZBuc0Tzj34LgODa8XYl7XKN0neTg8lGh4Faei0RsWNVrcLirc3tkkIc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9NsBf8KoPk5vJlGuYoZBv9FjdGplRHi0xy2er3zLV8eoitBcFn
	Z93OsYTb2/27DZdO3iY0wjn2ltTji0DuwQBx/WSLV0II7ZbUdyKkyPzm20OXtvgz8hPG
X-Gm-Gg: AZFdTZepxI8NZHo2N6Hr0jB7Hql5FiKmzEXMdhYou6gheaeC/ro/sE1yo6ANrwQ/4wf
	pDn8rQ2EvGKniL8+5QZ0zROUDn0ieanQOdCe6V/O6/jWwItYduO66Yr+yPBAcVzBxv/Qo08dyX5
	KFTEvqq5ya5iPYGdm0Y8No6dY9NmIsleJj+W665xpqWobEkr4xbT5JF0wpFgjsL99wYwqwCnYpy
	rAsead285QBMtOkAMSj7PuHnQI5s5+XXkZeh4a617zl6VPYCGl47ckmAm38XvX9QxaRf58tK70C
	GRrkW8O4HB8BQNBwuhNNx4GJmwtHcubicpwxFDZ/U84PM5luoBEsHb4G7YeSV44ABsKLthmI9oD
	Nza0JOVH3RBAxb+5q7GBeWrXpdkwq60ZHrT34YZPVk/aGaAQAJ1QZ26qYIzvhhll6AMmwcLjaPA
	nGS1GL7xRmsuxaYGZMNeG8Q3lL9Vr2D6xbGQbLXZtoh1hWb5AmjUOoEhZNnc9fVFg3Y5R96wMYm
	Kt60zGbFlkA7tfxxy4HUGmuJXtKTkL3nmvVmMXVg9OMuErrfaLyN0v1NsiWNmEjvR9TYELdVrCI
	BExrlBnPXB2KL6Wf7J4cMhT4N5ALVsq57eYpYXMapc/6AFzN1/N8noJAsfVM2Dq3lBqGeXOOoBM
	ptnM/q7MeXEYErwErbhZWSWoi41XdHKKLiDAX4Kx2BQZQjohUz2B4L9+3CMFURF9IvJoji0MesL
	hJeg==
X-Received: by 2002:a05:6000:2411:b0:48f:f26d:c5c with SMTP id ffacd0b85a97d-49c70b051d1mr27471178f8f.9.1794905081269;
        Tue, 17 Nov 2026 00:44:41 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d673ce75fsm19982260f8f.55.2026.11.17.00.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:44:40 -0800 (PST)
Message-ID: <d18a972cfc6a7d6da39ab9674903d7ae6e4c1826.camel@amutable.com>
Subject: Re: [PATCH RFC v3 35/44] fs: add file_check_backing()
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
Date: Tue, 17 Nov 2026 09:44:39 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-35-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-35-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Loop, zloop, the nvme target, the scsi target, fuse passthrough, the
> usb
> mass storage gadget, erofs and acct all take a file from userspace
> and
> use it as storage. Currently, each of them has its own idea of what
> to
> check before using a file like that:
>=20
> - loop and the gadget check for a regular file or a block device, the
> =C2=A0 nvme target, the scsi target and zloop take any file type
> - loop checks the open mode, the gadget checks FMODE_CAN_READ, the
> nvme
> =C2=A0 target, the scsi target and zloop only check for ->read_iter() and
> =C2=A0 ->write_iter()
> - apart from acct which refuses procfs and sysfs files none of them
> =C2=A0 cares whether the file is a kernel interface
>=20
> Add a helper that does all of it in one place. It only accepts
> regular
> files and, if the caller passes S_IFBLK, block devices. It refuses
> files
> on pseudo filesystems. And it checks that the file is open for what
> the
> caller is going to do with it and implements ->read_iter() for
> reading
> and ->write_iter() for writing.
>=20
> O_PATH files are refused unless the caller passes FMODE_PATH. That is
> for callers that only need the path of the file. fuse passthrough is
> one of them and has accepted O_PATH file descriptors since commit
> efad7153bf93 ("fuse: allow O_PATH fd for FUSE_DEV_IOC_BACKING_OPEN").
>=20
> Block devices are fine even though bdevfs is a pseudo filesystem. A
> block device that userspace hands in is a device node on devtmpfs or
> some other filesystem. Files on bdevfs only come from
> bdev_file_open_by_*() and never end up here.
>=20
> The pseudo filesystem check looks at the inode that actually provides
> the data via d_real_data_inode(). overlayfs accepts sysfs, cgroup2,
> debugfs, tracefs, configfs and securityfs as lower layers and reads
> of
> such an overlayfs file are served by the file on the pseudo
> filesystem.
> Checking the overlayfs inode would miss that.
>=20
> For an O_PATH file nothing might have looked up the data yet.
> overlayfs
> only looks up the data of a metacopy file in a data-only layer when
> the
> file is opened. d_real_data_inode() does the lookup then and if that
> fails we return the error.
>=20
> Note that the file type is taken from the inode of the file and not
> from
> the host of ->f_mapping like loop and the gadget do it. A driver can
> point ->f_mapping somewhere else in ->open(). It makes no difference
> for
> block devices as both inodes are block devices.
>=20
> No functional changes. Nothing calls the helper yet.
>=20

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/read_write.c=C2=A0=C2=A0=C2=A0 | 53
> +++++++++++++++++++++++++++++++++++++++++++++++++++++
> =C2=A0include/linux/fs.h |=C2=A0 2 ++
> =C2=A02 files changed, 55 insertions(+)
>=20
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 6767283108991..9f1e7bfcbd4f1 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -866,6 +866,59 @@ static ssize_t do_loop_readv_writev(struct file
> *filp, struct iov_iter *iter,
> =C2=A0	return ret;
> =C2=A0}
> =C2=A0
> +/**
> + * file_check_backing - check that the kernel can use a file as
> storage
> + * @file: file that userspace handed in
> + * @mode: FMODE_READ and/or FMODE_WRITE the kernel will do I/O with,
> or
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FMODE_PATH if only the path=
 of @file is used
> + * @type: S_IFBLK if a block device is fine as well, 0 otherwise
> + *
> + * Call this where a file from userspace is taken as a backing file.
> Only
> + * regular files and, if @type is S_IFBLK, block devices are
> storage. Files
> + * on pseudo filesystems are kernel interfaces and are refused. The
> file
> + * must be open for @mode and implement ->read_iter() for reading
> and
> + * ->write_iter() for writing. O_PATH files are only fine with
> FMODE_PATH.
> + *
> + * Return: 0 on success, -EBADF if @file isn't open for @mode, -
> EINVAL if it
> + * can't be used as storage, or the error from looking up the data
> of @file
> + * on a stacking filesystem.
> + */
> +int file_check_backing(const struct file *file, fmode_t mode,
> umode_t type)
> +{
> +	fmode_t io =3D mode & (FMODE_READ | FMODE_WRITE);
> +	/* Drivers may point ->f_mapping at something else. */
> +	umode_t fmt =3D file_inode(file)->i_mode & S_IFMT;
> +	struct inode *real_inode;
> +
> +	/* O_PATH files are only fine for callers that just use the
> path. */
> +	if ((file->f_mode & FMODE_PATH) && !(mode & FMODE_PATH))
> +		return -EBADF;
> +
> +	if ((file->f_mode & io) !=3D io)
> +		return -EBADF;
> +
> +	if (fmt !=3D S_IFREG && !(type =3D=3D S_IFBLK && fmt =3D=3D S_IFBLK))
> +		return -EINVAL;
> +
> +	/* Look through stacking filesystems at the inode with the
> data. */
> +	real_inode =3D d_real_data_inode(file->f_path.dentry);
> +	if (IS_ERR(real_inode))
> +		return PTR_ERR(real_inode);
> +	if (real_inode->i_sb->s_iflags & SB_I_PSEUDO)
> +		return -EINVAL;
> +
> +	if ((mode & FMODE_READ) &&
> +	=C2=A0=C2=A0=C2=A0 (!(file->f_mode & FMODE_CAN_READ) || !file->f_op-
> >read_iter))
> +		return -EINVAL;
> +
> +	if ((mode & FMODE_WRITE) &&
> +	=C2=A0=C2=A0=C2=A0 (!(file->f_mode & FMODE_CAN_WRITE) || !file->f_op-
> >write_iter))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(file_check_backing);
> +
> =C2=A0ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
> =C2=A0			=C2=A0=C2=A0 struct iov_iter *iter)
> =C2=A0{
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c4..b1c7ebafbadbe 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2553,6 +2553,8 @@ static inline const struct inode
> *file_user_inode(const struct file *f)
> =C2=A0	return file_inode(f);
> =C2=A0}
> =C2=A0
> +int file_check_backing(const struct file *file, fmode_t mode,
> umode_t type);
> +
> =C2=A0static inline struct file *file_clone_open(struct file *file)
> =C2=A0{
> =C2=A0	return dentry_open(&file->f_path, file->f_flags, file-
> >f_cred);
