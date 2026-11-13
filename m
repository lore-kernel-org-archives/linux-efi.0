Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564728;
	b=AzjvePKiNIjZVQzgyqys15RKX5Jhm8LEPVxP7ymZGeSsZbtV5ESLuW4EWsA5IANE3lxU
	 2S/H7KWPRRe3rL0cwYmbEPOqvQ2rOYEd/xZCqEDAKZAC2rVXGEaPGlIq2lwmSZHGslroq
	 FEGl9X9QoTAAKgeV7msUau5hBpFUrc1lYrvCIBBRUEwD2GlvuhruiG1yIXY0Sxocs6npi
	 swA8YBZFABi3UsgP3IGf1Iv4DoofkKLn4kQde3voEAPh3etr5Q8gZ3zp4suntjN57jbmC
	 Ov1GJWO1caItO+CwW4km0+oHMdqAT3l3EKRrhp1OQHkPSDU0H/6TVMJe3HSz+Vauv1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564728;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
	b=xKx7XAdFdrI0zl3In2/CU5bb90EBw45V3EmhxPetvWtze9iw/pS4Dpl8uIqkduank9EE
	 S1RmLob9hsiUGr9VbSFANTuxEKTPrQnuNCak2iQykMhkEwwRcmylY1bfGNSiPo8ItG0D0
	 lQXmXIsrHZYmgEeT4hlA0DDDZL5fbE55cuLO7zvuueNJsuKFwO2VwcLQsXRfRw3lPNVCj
	 n2InviXD6RVvuI1D80sdQ2lGYSbDrRI8ql1Z9AQjG3q9QUPZVYnVTyvIoVaNvbxTFFzbv
	 6IY9/Mf5V33JNGuSnNkL0NO82IkhGN2QGSNBy+1ogR/IMzNm2pLGlsKHdJBVmRbJxew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JofFrwon;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E64606A330
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:12:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1E64606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JofFrwon
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so10449105e9.2
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564726; x=1795169526; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=JofFrwonLml2YmEXhdcViuKQhdgodt9TPfkjQoH5bRE5MuhkX9eapeBcuLoN9BMOMG
         mg62x7tr1NIo2ce3//xfxGBo2Glw1JnMwrRUE5PKg9cgXRmANAsmerUzgfn4I+APSoic
         nLUkrr6h7Ej/6ZnsBOEx8OEPXrCx3CvMaGkTszs9w9WOs3gF62hftbL3MH/tr8iwAkM5
         IEqdn+20vI39qrHT5Lu5B20ux21tBPJwfptIyU9tNUhlU5QyFDk51k8ZhbiJowoQswf0
         13eatahih0uhEB44iQMwucAarD0vNvZBAG3aTkRmepVuKD8cgol5N6Bgv+DPTP+kX4Yt
         YdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564726; x=1795169526;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=rawYCXsaFpdbb5Ttb7Mn8RxB6L06Az06fwIzLja2xyvFn6R6JLdJVjtcWAqhe9CYZl
         U3UmgBBO6Am928t4lUuQ9fWpJT+IwrA2hR8a6KQASCFenpSeS1P71wf6CJ1sp7wyfthU
         c1ahydL2+4KeeWDF06UOlXiIqdhc6cO4aTZzaqLM5j3iRKNonu6B90f8p2aXpG4zwVam
         6WrFCJqYMiFBSdAGFO9oSHk845dVYmD1tehKSleRH5qLUWHbIb07enuk1I3Gt8HbT8/g
         JnXeIxVh6X21yIH/nnQRAW3jrD8X0j5JQIF1DMeuz5F1lldY2VlhcIBX+hKaWpJbKxuW
         RjLQ==
X-Forwarded-Encrypted: i=1; AL+hErE7JSe8OF9zzPS/5AQwP1h/AaAIkERKMRvsgrjFK4Jtb6Cafd59fimlu16GZhv1SdQwBs8PTn9AOkw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+sBkOD93yw+u/hp0mnNkqimA6+MAK8778jZGQVzlgzRURuFP/4
	i5t7HEKdIXKVAG9W9ACCcNd7s5X/cD/ikFOAUq88Q33PJODGQGtFRST7sQplcdcNKoO3
X-Gm-Gg: AYBFou20GcfTW2b+7/KM0ifs5cLVPndnSf20gFfyRTAl3CeZ+o0kw7GMYShakHwCCdx
	JR4v8q1WmmibHZF91KKifHntu6jQDaNw1/s/okL9A3JE+oAvrQVBUh27ExaP5akMh9UL7guE1PP
	rFjDCtQfatHnhAd5jI5otQo9uEtxKHeRfgIG+iCR1Z5WoRDY5HDnfTrzbdukF1DU+Diuzf/yCl2
	0ViO8NqopSNMyOAeqPgw13L4KgZ9d9Df2AAoA8ZW2vGIAEpX4PDmIfSa6+0BSsLZMGwX+4xbM4D
	QLoQjpV6rav/AY5G08CjY78WsTMZqQHYvqbiUgOLpqGMfM8HfHnxsVv1Vqm7/vK/OwzoMFU//Tg
	bI4VI+A4RQshjg8V8JvScaoEHWDlmQkEmxPAB8TjMpSMkE8ArP1WemBoAhrFbOQ6JvrMhCFL4ya
	R0SqF3oDZsKv73DJKEjaiKi8lqzgIGrHfqUjUupPJoSjuShNE4ez7/fY9Yf0QVodfW3aLyrhfsK
	Xd0gIhVnsuR/DbJtvrM3NN+M0W2x22tHz3iqDDoypKf4mEJi99u2Ur192ZB07fuMpoWS8MNiGY5
	VCeK2SVztpGcD7C1N4sBC/IJX/6cIdDUfuUHgwAx17qXGRzfNLvFO9Kl/xyxlJMcMjknEP+GVSn
	bA4yOkfP3
X-Received: by 2002:a05:600c:c4a3:b0:4a1:6992:f861 with SMTP id 5b1f17b1804b1-4bb55a02932mr40317635e9.1.1794564726124;
        Fri, 13 Nov 2026 02:12:06 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm142085915e9.4.2026.11.13.02.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:12:05 -0800 (PST)
Message-ID: <82d691d2db7579d9630bf89f73132e36124bf74e.camel@amutable.com>
Subject: Re: [PATCH RFC 19/41] smack: use fc_init_pseudo() for smackfs
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
Date: Fri, 13 Nov 2026 11:12:03 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
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
> Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/smack/smackfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index a72bc7fabea9..4a56bbeaeca3 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -25,6 +25,7 @@
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include "smack.h"
> =C2=A0
> =C2=A0#define BEBITS	(sizeof(__be32) * 8)
> @@ -2880,6 +2881,7 @@ static const struct fs_context_operations
> smk_context_ops =3D {
> =C2=A0 */
> =C2=A0static int smk_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &smk_context_ops;
> =C2=A0	return 0;
> =C2=A0}
