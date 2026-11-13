Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573425;
	b=taaF9P/8N2kOsucD0cUYcz9IyIRSBRGDIoERRBcaycbSQMUxsk8VNjt2lSXCy7HvUlTt
	 guBGfr1IV9HbtRBaOveWFsWKDWN6I3RoyfAx0hkvHBGWxTdJfvi9CuOYtNi7B1dvCOUaJ
	 7KhJUk9ZkNFazKBUYHBZPSpOUir+bN0UJxhfL/FvCfWzqhmHfZayNkmUzgcewG1CV6lSj
	 bHInZd8eEYQBtIFsu6JA5Bl/nE7XREzprVA155AXuOh4P8+741UcmWdMJDK+OWUQ7PYwh
	 +XDv4wqvIm9TYK8EaACLP5GvXlAOYAn0J/GnBcs7b2okG2jCv/3v1Zh3adNzfEefoig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573425;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
	b=SqFbH1sqnQdRQxzbanmoKaznjSDPeD5cVZvoINCfTMHf/bcs8/kIdN0W6NLvBBJy3QWq
	 c6AjCsJTblCdPK6hbZg/IqUnKLJw3gKvEhC3jWgM2lcboFua9gLOD+RGMtlA0P0/8tpEE
	 9cN7ijFG8hQUoSI5bRRM2hBW0niGbCj+q4/3et9p8S1s1hGGf5BPM0MNthLAx3rkguX2X
	 4gpXLwXoqxbZIMBGswIIvHqdNeQ0G1kiUQMZ+zHWXmGNqv1Obk80qV0yJYr0UKkQajiSs
	 pqltit3y+HbdD2tOnqgt5FlvZlPgyen9h/Qs5PFPNceuzyG5SybbeVi7HUvaX+diAfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n2XPHptJ;
	arc=none smtp.remote-ip=74.125.225.139
Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90D5606A334
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 12:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D90D5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n2XPHptJ
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-4a5f76661b5so3542075e9.0
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 04:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573423; x=1795178223; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=n2XPHptJWAiGnWBjuWK6g5NkFljgiKFcabC8Vn0J/U7Rs5oCxIs8ae//bm8icbKFtW
         GhaGag1Xoi7ZyXwdHESo4gzqQGVIFHJ4SWyDVffZrMrzihrR6J8Y41NroO1pUm4S3UEM
         GevRMV87lpSFNCzDE68IInZGbL5X+gYDk7IApotAPKeUo9xOfBbHGBSC5mcggp0KJBcK
         Nc+e1mR1SmgmgC0Frha4Bk72pKDTzd14yUseYASwtvG8qZfbG+gNn4GmoQhA8ODET64L
         X6SskqZIriPJvj35d5mhI8G8hobVKdLKjnxeG6bMHAYcCPTjUD9dRkaaJK3nWVTXV/IA
         bDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573423; x=1795178223;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=k29c7ko4pj2DS+DcvN0eoqj6vspPawbZLKbyWMcF0nWeBGJLvJQLt/lmwqjFGBHtM5
         Ay27HTVHOlQ8VVg56aZleWmPiYZcgE0qn96XVcfzwiOFi9akFKXxxYE3uISJYSoXRK0V
         WB6wuSePk5qPy7agsjwifIQAql5M7afCrzWHYcX3gKFgHkHMpf14BFXIeRfSPf27OfW+
         xij0r8EEicZgm6LNyiJ27tpa395KNrHHwSzMLl+OBGstsH+GMp3fV8G2DS4A1GV+3gfx
         A0hI85+Oi4boSAAjtQq6BFnkDJCpKKp8JLRNKZ9XG+vH48FhgdiQmwKVgtTuH6dhpsKf
         uCMw==
X-Forwarded-Encrypted: i=1; AL+hErE/z1mcqE6h/eXMwbzt2Iwc5Fb9GQOGB9+D1l+ODvJGGcu86a1Mv/6Erzjo/EsI5WaarK6tGoeK30c=@vger.kernel.org
X-Gm-Message-State: APuU4Z/efUvm03t1p4T/2gz5xYqZ+sZ4tuOeG33i+0WGOKUMmPN8bsGQ
	iiSxk9bVbWBB8dG9vjbKKJjtjrqkvmBs7r8rhtUofIW6cFnr0o5eJNKDarGga7h0RfD4
X-Gm-Gg: AYBFou0o5Csu3m8yxj9oFS43eMF3tBmf9BO268QJ/0/q1sNUUaFFzaJ3fv27tnyqFp1
	SCJUhfQIerCVoVXsIABz36CURe+MU986pCxRUn1O9wzn0Q5DXfWGJl5+TdBZcQ++3VmKB37eObi
	uhuOCq7Fwh59BbCIk69Q9v10ZLW3x+sasTrSgN/YNpDn1kF1qpf1k6ERi/bJttmSgR2ztmc/Yme
	KF4Jb3TIycxUe/0meOxBxFNSyatmn+aoAx/NJxN/yr8n8vAethag5y++uMbNyBIagrq3ZNo2EuJ
	gtZpKGBRbcWqqsThVp6i2hS6W3aX7fe4dqpP6PTooT0OE7cYPWtSWX6kU4UZp1Te33fgJbxy3Fv
	R6D8Bfl89DsdnXmVH2K/ep3ENREt8ShO8JA2k9t4WqzeeZJsjfcrdVtQvgDt+d2/ov6bLPRYva9
	AbeL0A/hzfH5QVL833sPdZnKLszgLN/T0ZRW9aVZbmKel3qwlNyQYOQkovE7onubSABdQEwb2hO
	QHGoFW0mvw9xnRN6Ax6EgdJkcFPKVEe1vVcgJ2kIg52m3hRn2S4S3dKSFEu5E0vq+Xajd6JVfa5
	pbCabN6vSPfNXm6xJxa+avs/E5rBkvIomCHJlty6z34vmdwOyRmLF9x4WrCJ/9pjdAE/Q78vecx
	XB6v9yEPA
X-Received: by 2002:a05:600c:b86:b0:4b5:d95c:2378 with SMTP id 5b1f17b1804b1-4bb55ac4030mr49782945e9.34.1794573423157;
        Fri, 13 Nov 2026 04:37:03 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55af2901sm57437255e9.13.2026.11.13.04.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:37:02 -0800 (PST)
Message-ID: <f12140be54ffc4d1e8e4026f80c41c75cf5727e0.camel@amutable.com>
Subject: Re: [PATCH RFC 39/41] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
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
Date: Fri, 13 Nov 2026 13:36:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
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
> fsg_lun_open() takes any regular file as the backing file of a LUN.
> The
> file-storage kthread then reads and writes it with kernel_read() and
> kernel_write() on behalf of the USB host. With a procfs or sysfs file
> behind a LUN the host gets to read and write kernel interfaces with
> kernel credentials. Refuse files on pseudo filesystems just like loop
> does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/usb/gadget/function/storage_common.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/function/storage_common.c
> b/drivers/usb/gadget/function/storage_common.c
> index 75831f2c7abe..83683ade20c2 100644
> --- a/drivers/usb/gadget/function/storage_common.c
> +++ b/drivers/usb/gadget/function/storage_common.c
> @@ -211,6 +211,11 @@ int fsg_lun_open(struct fsg_lun *curlun, const
> char *filename)
> =C2=A0		goto out;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(filp)) {
> +		LINFO(curlun, "file on a pseudo filesystem: %s\n",
> filename);
> +		goto out;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If we can't read the file, it's no good.
> =C2=A0	 * If we can't write the file, use it read-only.
