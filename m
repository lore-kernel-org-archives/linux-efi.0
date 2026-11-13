Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564657;
	b=gG54/F/kdJ+W6o7zE1XlqYXrZRtkeflaN/G3WfyUf8SGBkYwTu609lLen5J+aLB/xF3h
	 KYBRofdXehkF8Qe1ObUuwsMZMvN7at+dbUCABsLerHfwjtvGnsSlbEsuXLarLKhB0VrtL
	 lyLEgLYJj3c8aJyNDVLM9W0gVlE9mbR4utwgFjfW8M8lR9Oe/AkNtfyZnNN7L68g9Ir/v
	 9lVeVEepDk7uUwq8vFITMakY9Qn3dHbRrow0Cxg/W6QE9p+cVpVLxeI/PTOCMkETfqcL0
	 NVxbKu42V0k2OCMYiudCLD3JI1wlIMzH7K1t0H2ZEDiwZ1evL22k7OrazMxUiSRo09g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564657;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
	b=zGNLZxounPeHSRaiQxTTvSz5pkGh83zLqLMAcjaX1ptmSbmwXBOT2r67L+R+vtU9U17P
	 kjpBMw+oR6nWFrgVd4DQ56FuK9m+Bz16kGaUqBQ9i5zL3NtCD5BlVLB4XFMDmfxVExFO0
	 /wUzcsSJUnr4uqxdJftDQI5S0ltns0fSZ6lfCjv8D0BHOFrhLE5aAGliaIpdIONBaEcP/
	 /eBUWsU0XU3Ju3x5KhzUDPDzRS9hyfAKNDIXcXridV0M8ACQ4peIhtLrRnrKLSAexAUil
	 yv/CDxsF5krWY87IoP/IEPzOBpSbY6D2FMJ5rilEJMI3PsbWjCQyfKUjGz8yc10yAqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=afSYRRYW;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F43606A884
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25F43606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=afSYRRYW
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-490f38e9688so497686f8f.0
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564655; x=1795169455; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=afSYRRYW0Lzg1RjNF5a8Z8fp4FTD8+wBAkqEEgX+uXVLN6iB/1Oe+S3s3pjBsHkfPy
         t+OYs+BeBV0n1jEyBb10NVx3dBSZolIBqoZV0sAqk1NmAyPkc8BtADcPrCcEDzdTW4+p
         zgkm0FzjpTOQt7I53MJB0zmRNwJ5JPK+9oiFhFL/qPiFq6x22bgZ8fSq9Se2ho9ikF+q
         rg0gx4TedCmdQu2h6zCkoXcFHWmQ+ZQsRVeKTv2sVCXhncyHGZ2k8DCVvoh7926dtvhd
         5w+l12l3Dd1UCqA4z70s6tomNhqNtGqcJuf3lRDB60cxVt/wNhZpOgzeegjchzcaCyfn
         tojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564655; x=1795169455;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=CLGPINGpV9YyaIhTLq5Ikt5mv3BD1BjQK3IBfRxit4NjUwjr6kozizj0u6DHiVbuzi
         bp3Wt/H+zxLx2lj9/rihDkNwDn5jaOQST54z4IO1JuvfXR2JDLvGjvCya1uOtDN0uLar
         wtLK7AEazAiKygd97NYIDD1TCSO0UxE0qJPnCBLeNqVjuQBrLFnPpLsFbO5YvQnrJC2h
         Gg2OIZo04SUYOO0La6/6lNMXZUj3alfVoX7A4F86QXHIJ8P6lv5RL5yx91XszK4E8ugF
         rWfQ4wqp4kvCdcc0LM3L4VQsB7A8nB/zXUp9OLEpaMVeiFDZjwp8cj8kU6/KF+ovqLGz
         /kJw==
X-Forwarded-Encrypted: i=1; AL+hErFdntYF58/BQ4mFCDgBSJf61MHyPxBmzMJyVg24fFX7Lw0tkoura4cmTNFM+wdSZ0Ii8fTYVH+xojE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8VROUIn3SrYm3pvqdq3zFBHaiNrFhRjhZcuzu1FHJgHNPAFKdl
	ocQ/B8fJYIwpzOS/5WuFDnMTyJ3hFnc/CQ3C/DJvmMBRzpUfTDFhcPuvR9gkQ8ABePck
X-Gm-Gg: AYBFou31lljNJblXZkeX37W+2Q/5NVbMNXDkGOBTbdEqen2mcGqliBHPNeUDE6dUjjv
	yzKrWtQccnZJGKrqQQeDN55wz9cs16UdFBaoojb3nPQ+Paiu5/+urFPZBc8BGwtr8F6oXsIU1uA
	H1sqXHWnoshBjo58J7CBR1ATT6/3PHU2rfkRRjnKvOabK6WUtbD/FOrZFMO6lIDuoQh8HlXg6e5
	VBunP91aseKL3jA8r/3L3Ie8D2VcBhyJogXo8Es2Czfn5JKhBekiqQrpQoyh6OucDPspoT1FzXW
	udpPv8oHuphy/267Ux70IUiF7uQh2AK/q76+uwyeMIpV+qE+Dpvrlt3AfEfDdHXSQc4euM8p0o3
	IhqZaXDXaZZRvNccL0c++0QnghRl1M+fbA8jJMxgnQChF+HjOIgz+Mq2rRZF+hcSCpIAeMl3jYq
	n7COmznSALBXlc/8IX+liyXwcFvMHymTYZKe0SmQyhVVppun5bgvbDQpIUD70rhHcgW0COk5qep
	kfulf5YSnDSgvdEPQxOLiTKEmLtXwXb/O/NgIJ5wASHCkLu0iGR2xpcbEDXWQhlj8xznt/iubRg
	lieofXsS8v8KABbYxeQERQIbIgi8Q7PKJMslRZGOVj6fSIQsZGO5nDrcXuvLVFg=
X-Received: by 2002:a05:6000:470e:b0:499:ffd4:f519 with SMTP id ffacd0b85a97d-49b02d4c2cfmr11662822f8f.23.1794564655454;
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm4988050f8f.0.2026.11.13.02.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Message-ID: <0894c601b3f3c5b92008c6c399faaa539b658307.camel@amutable.com>
Subject: Re: [PATCH RFC 17/41] securityfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:10:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
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
> Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. securityfs never holds executables
> or
> device nodes.
>=20
> AppArmor puts a .null device node into securityfs but only ever opens
> it via dentry_open() which doesn't care about SB_I_NODEV.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/inode.c b/security/inode.c
> index 080402367674..93997a9f16fc 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -14,6 +14,7 @@
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -64,6 +65,7 @@ static const struct fs_context_operations
> securityfs_context_ops =3D {
> =C2=A0
> =C2=A0static int securityfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &securityfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
