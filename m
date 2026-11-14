Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794698411;
	b=Kri6Hjn40YThgBRzO/Y9zKkg/WLo87Dqazw1atIfiQ/I9gdxlxBKAFIXSOxkHbUcIf4e
	 bbnxZxP69r2yDCpM4dAkCU2/jCebSQtgvsc7qhnvuDwTSbEsYDFIDk+ZEw186QxG5cyjf
	 DwcyDruiOlFXQfHvJkLYHb5bgKkws1JUUkR4T4UQkvzrOkue1DXMkeIS3h1gN6/b9Lwhm
	 DywfqHZd2W+KaKNlT0AMVlxCNrd12wUxb+H15wN1ZNLoOUCkL9u5oD46VFVg1hy5t8UTE
	 0vV91A59EaFuNPJRF0JLv7m4uwyf3PLHL/MySS18sxR34LlXtO/KLDBkstQoyDytmZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794698411;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
	b=iRPdfzE0vbFIpIsGDBR2Ue50GbUHUBkRgYFtiooCk8kMg5hYa7SdwYKhSk48PoN7Zdqi
	 Ut35TeWFP3GjQpPC18VCB3e7YlHIJ0cbpsDegqaJt5rHzSI8iRsAprcwcI+3mWErxdFF5
	 u0JZ9P3lE6jqHMdvxYLfk3if8LGHSE0CQSjfCt8GfomS+8rU7/yMmv9h8WFsfYTN+ZvGQ
	 1JkXitl2gM4l8nqRHSdTDU+LMsdTGN+ZoD/DosBt2nWJlxjBUFrpQSTstMMzB9B34DxPY
	 L42SqqtgCa19zjqgKN/LD0Xk+0XLFxsuzvadm9GpTkzLX23hZKEsSVweT1cWN7gEpYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bZ4A5V+6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAA8606A336
	for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 23:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEAA8606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bZ4A5V+6
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b596569640so4611869a12.1
        for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 15:20:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794698409; cv=none;
        d=google.com; s=arc-20260327;
        b=R6oL7iy8vGN2bZJFnFLgfi6885suGo27HJYdSJWgTgZnHqaOpTYK3UJ65tlZVpQan0
         Iq+wExxh9F4KBedJbEUL3OUKQ1IHJZYyXl5a6bZGH+vDohLMw3Sos/G1ns9WiN/Pyg9z
         LBcHrJvlFQl5fsfPI+Prcl+rDD7E4GW8Jej5N8mD7iC+BePw2hL++OXpNlfhg4JRSMQz
         W8QcDn9J41xh6GPpSIEsGQMoIPHVAxhKYyi8NVfv7bk/Ow39F4q3exNFBzDypyTvxT9b
         +aX6k8gvJ82CEvnEmxUpj2zXiBZkMvdXk3xHSYC7ddCnJPE1uOoPtwjxLHApic7JsUND
         zDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        fh=0a5JG/5Nkc0yP9ggmy98gqHeZ3kg9iaLzDcHq0yRgwY=;
        b=K3sqWqcrUIOPIP84tFOJEyCp1ZIcuJV+Gdt0e/fn4XzhcZ/k6yS/iO6SUvwgYvltPS
         03WJGAhADK8aIhfRmwQaBKN9zhCvdrExZ7PyJ0JfyewaHnf+3kx1JHWdagRg0X3oEB27
         YFfB8G8Yklfxl7bZzfSEouFFStUdw1KJFMJMSJhzQKdeqCXfyyQou2SvS2JG8zdq3hoy
         nQIogGnGmSsENGmqZYprmr5QrIepWavQaC+ngQKBMh1dz+XJyGq7czucshJ3LBx3Q/A9
         dojLMFV1dxrL4CxheI39pELteHUf85+3veB1+jukmLTX0CrTJ59buw/kYRqu6ZT+a8KZ
         j2tw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794698409; x=1795303209; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=bZ4A5V+6Vs4HKIPLNbCXlaoHg6GUiZAgPE1CoHup/u8F9XnmCFMSb6naMqQFAl++mw
         +LZR0jt78s/FhrwMU+95xN0Ho10rZ/g9p6M/dfGpr9SfvlaOXM2WfiTCtO0CejnyefhK
         5gg17lDjyCI6S+pTTK/DIWzHtcTY1JHkLI4t/I/Teu6/Lgz9A0oKfkx231Ay53Fdu4Kp
         zCo0ecwmPzO3ZOIddRCFMjOjLH94BU3oXsC8cOhJgJSeLFwZkZlFyxo1cq6JVw7hHb6A
         21NW8PziNlBat7d4DfM9UgO0YIScpglsDnmQoGQNIOQhlOx3hw76q6t8+8jTPfBn24eS
         FVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794698409; x=1795303209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=M65ErBMS8J4mknnYS3txBd2zWjPJVVfuS2wNaDWEBnn/Oa73Jltn3UKivsPxQJeSMG
         xo1oObAJP7Pmc/cQBImgLacRqtHITVyWkwiiCY/U4tTg/50V+iONoJGhhDKT8U9cJY8t
         KMwfucC215N+GS3vzDksdH/NbmGV1GeoZB/XpautqeAUDBxlAFyfRPvbteb6ucTLAKMl
         LXpFV5D8FKgdP6GdhUPwlpM5uN4cMk19gdMzBMjn6UMfCNiSQsD9yEU2KLpnuyLB9d41
         DzXkbmnuWe6fqKAeWX/i//3aNr79AtF3cOe2f7jogVSn5/f1no+Q4w/IOQOVyo6Am9Gv
         DSQA==
X-Forwarded-Encrypted: i=1; AL+hErHijaaGzEgH90vYs1DOwGYPl+i+dqogOzvva6C6UvriIhqVNog1VokhvMO1512qAg7RTcklG779ZjA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/LZl23u7CcTqTvCSf8dRxcwz/vuwjPy2Bs5ZO+F15Xsrf+yRdw
	E2yPmoEQkKHdg2rzLFcE1LEb0vjyXbh1a5d17oTXJUyLoRNbs9UdVlpCY2AQ0OO3X3IteFxodlm
	oHRdD5+EVydbvvqqWlb1iyYJ/vPuB20k=
X-Gm-Gg: AYBFou1yDZ22l22x5JrvagkR/wQNa8Dq3pH6R3KQ0lLRhHOvy8n8Da1E+EywB58/XlW
	baPcYs1sN+fNBSW77dFhJeQvC9MBxYxCt/aFnkZo3ySRKq1wYJkUQMRbPcnp63yNRkPElKYLueW
	tIm7mWuIDZHtpLV90+VenMeNTfcOGi3Am+J3aJNJi6iKGPl01PcDQLRA14rsAkPosSq3DD/DP4V
	5VYjU2XoYzPiz2QCMyhf89kqL6r2rhwdrQXciy0RSkSippU5cF35Z8WUun08n7dyKefnyE5rKOt
	oDaqNujdDW/nz1nO9cPq6j3tsq+13rJiuW80XKZqmB8HWM9IE+c9AsiTJswWIZQ1gmodHYNKohc
	m8L48/ro2PHjGS6gtE++ahDA6tY4/MjHXIYFv4h7ghO1cq4Mb7AtwEL8s/StMhPuLBRpuXg==
X-Received: by 2002:a05:6402:e10:b0:6b7:f00e:5e56 with SMTP id
 4fb4d7f45d1cf-6b7f00e5f37mr1542816a12.1.1794698409123; Sat, 14 Nov 2026
 15:20:09 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org> <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
In-Reply-To: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 00:19:57 +0100
X-Gm-Features: AclHuK_YVxhIpv6JLzeNAX5mX5IHGfu05WS6uQ-TCKewxE3JKeci2PyA-UDMCbo
Message-ID: <CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
To: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 14, 2026 at 9:06=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>
> Hi Christian,
>
> Christian Brauner writes:
> >+      /* Look through stacking filesystems at the inode with the data. =
*/
> >+      if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEU=
DO)
> >+              return -EINVAL;
>
> This looks good in general, but what the bots said about O_PATH files
> here is real. With FMODE_PATH this is reached for a file that was never
> opened, so on overlayfs nothing has been through ovl_open() to look up
> the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
> itself, and when that fails it hits the WARN(1) at its end and returns
> the overlayfs dentry, so the check passes as well.
>
> Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
> it's easy to trigger with that. From a quick test with a metacopy file
> whose redirect into a data-only layer points at nothing, registering an
> O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives
>
>      ovl_d_real(/f, 0): real dentry not found
>      WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
>      [...]
>       file_check_backing+0x308/0x5e0
>       fuse_backing_new+0x219/0x4a0
>       fuse_backing_open+0xe8/0x390
>       fuse_dev_ioctl+0x53a/0x7d0
>
> and the ioctl still succeeds. A normal open of that file fails with
> ENOENT, so nothing could have used it as a backing file anyway, but with
> panic_on_warn this is now a panic.
>
> Maybe ovl_d_real() should just stop warning when the lookup fails, now
> that it has a caller that isn't trace_uprobe?

Yeh I guess that this needs to be a Fixes for lazy data lookup.

The correct fix would be to teach all the callers to deal with an error.

> The check would still pass
> for an O_PATH file whose lowerdata couldn't be looked up at that point,
> though.

One observation relevant to this patch set is that a datadir layer has no
business being a pseudo fs and that can and should be blocked explicitly
at overlayfs mount time.

The other observation is that fuse_passthrough_open() should probably
check the backing_file that was opened for io in addition to checking
in fuse_backing_open(), which could have different FMODE and specifically
could be FMODE_PATH.

Thanks,
Amir.
