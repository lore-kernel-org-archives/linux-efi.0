Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564824;
	b=MaEgsbTffPrKZ77hKzkAqq8aGTKPAU6OQqO5xBdtPRR1KgbK9VabhFjgMLbOji1WyY14
	 b4ATcY6OFRpAuu74vks2bPUU2hgZ3nKlwtsJ2J11O/NJQU32+2ecASEC0JxGl3ykMBgvA
	 r1TJsgaEZIXUsnCn7r52ByNOtT1MDX7APT8z5AfRqOZHzP1zY9rTx7LXEmBckRv2vsjiK
	 kAosxnxw3ioZlh5hHEQW/90YM4B8OHfH9Hzfiggfsi3ZBaM8JsxThR+Hc5GPwXoYLmz4F
	 48ecmfZplNWTESNYuAVWXQUAP1Fgoni8Di2oCQtAFQSixkMpwf9jl24dkiOLChOwVpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564824;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
	b=VWZ/q4oDC4WpS/6g/S45vxlXjTVSeLGMuPJPSrdwuqOZ6WhwIt+Vco16A/yUhsWjA5H/
	 kRnu5ZzKK3lmnqTMq2BpdxG11zpy6oHKcb5FICt+V2wfdzH1yuLNOVrzaGEOCvWKPYTJ4
	 /73UPt67pjUrRTBU0dVyS9n+T3hUv1puVSoefLb/9H8V/Yx81jJ/rI1e17sP46ED3wexB
	 jrLoYfgBu38N/RMARn+HQAeMdbVKgE3Tj3As+Qhm0A9S8Kpu695olXsBdFdLl7sv8Bqfa
	 OMHdN1e9L0BEagHc5Mg1K9qSYH31HXHd+bCMG78jVrIP94DHiwuRSc08A34W9TrTkQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tBSDp3uS;
	arc=none smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CC660A260D
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0CC660A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tBSDp3uS
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b7221c0f2cso1490861a12.3
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564822; x=1795169622; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=tBSDp3uSBFgypsbtBQgsadIQZQK7UWodMC4WHZVi1N1ipHHYu6WywVfCa4AZ6QIaRM
         wIcOajhLTVFUJp4yf9/N65gePrg5n4K0AYKI0yA+7KNwnMoUY/irx0jTqY91Kx7jR9xZ
         Pm03fPe9TdsIWGPKhcU7A4Ssshd7c8Dhe1zzS2a/pwsZLiwc6FmAy6ptf2LWGhArJX18
         uzRhPjO9k+hyhG0ceM77HGUPCflD5+7VnbyODCgVUFUm1PdMwYT1gZdGgKWe2z5NHlJg
         Ao5qYJPp+rBAoBURzi6iHuHACVVyoOXqBDLcaaEy2+qVTTu+93IkZN11FbEDMtWMDX2T
         mB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564822; x=1795169622;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=D1W1xNFr/eiZ6zVTUdYDZgGkQC7rBw4fOV56NUThjSY1aZUXnDC0etxRtNH/LXFOyK
         S4Ms+PoCnfNpWg3LZtalnUJZf0v4484GoEMxHQ6I1e66dQN8ixrw6BBE88rDYwZcqN1n
         yx4hw6QoyYII9YZsGMflh47jmpLK6p3aObu6rnPGtNZUC8VSy3TE2h7s9x8LZMZwlanb
         Hd2P+RhtiIN2vn8Ii83oc8+mwwyhTzCV2XXWsZ6t09zHv0F6bYefuYp6zKJBGwJO1DqF
         ItYJW4xKFsAOLzkFOD4p7FVj9xSiyfCIoiF7yNi31kxakMqMxZc+HffM37jokmHlPokh
         zQtg==
X-Forwarded-Encrypted: i=1; AL+hErFF16IE8rfhH795Y7v7rriCTX1n8Nqn3X23j3u2ktEysJaBw83rZMKqHQ452QtjH1WDwGGhaPgpAEg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Hv9fH7D2OrWpWlkek2qSrEVG6fui7tGjRmNH7Z9iKGKVn0Dtr
	f2SNMxaqKSuApvW9K4Sp1tP1Z/hcuBM6NTINUpGz6vKibb+iD8rYsG5YHhpYVObw/gwJ
X-Gm-Gg: AYBFou1tpFjqJnJX9l1MUR3v87pcvyPaiBVOK+VcmryBiHweqpJx7ak/durhLguWtGc
	rlWe6GlRL3eBBff50fKRsZQYN1jKU58su+x4IGqAVXZI/Wvd/RbQDWbxGIjegZfjqJA1n97gdn7
	gl9L9gEuVBG9GQ4xn6VAPtO6b3EmhnI5DSltKcb+fAR2fT8wFvlsO75k41xiHzHzLZs39crss19
	uZf7URu7BKdF+DMDFD1F9Cx7GSkteb4dA7JlBxKUd4Ilu5sEWhlsfo5njxcWqHAilxHF8FNBLYZ
	iSqtX7VMnEzEG+Z7odNqXygm3YageQt6/IqDzGxLRmCTa4kZPrTDTFRiw9oKQMjhBh2r8oO4Cz9
	4PMpU7Mx3zWpIPqCR1mgHI4GswouVMHs0fmsfDiauFgEx2i51ZTsHERXWeznNIwKThoV2VRY/Q7
	rTDdHSU54jKKfifDFqhX73tBRN5yq0Na35SXTOooKkPQdJnBuVeg3ztw0IWUBzy79HsY0vnzPZe
	/o+W5ZkbLniitSm5JYcnJQwMOuOw8usX56niGpY9JD4T+Hv4j1wJTBBMBVcDx7gtTbPL5js39c2
	ETJeBsUu32uGvQgQ/Nu1IjscI5MnG638Efc3OfUSeae5QrLQCbJVDYlI83PLXkNy1b9dK+7NVo3
	F0/u/T/mG
X-Received: by 2002:a05:6402:208c:20b0:6b5:69f4:e7ce with SMTP id 4fb4d7f45d1cf-6b7c0c62bacmr1415990a12.39.1794564822367;
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4d29sm4332158f8f.35.2026.11.13.02.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Message-ID: <3546dd28b1d63c1478d391a2015fff4c1b976639.camel@amutable.com>
Subject: Re: [PATCH RFC 24/41] efivarfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
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
> Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/efivarfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 12746ced6dc6..e598d42c5f42 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -8,6 +8,7 @@
> =C2=A0#include <linux/efi.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/pagemap.h>
> @@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	}
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sfi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &efivarfs_context_ops;
> =C2=A0
> =C2=A0	return 0;
