Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564206;
	b=qRorcfzEl+uVNgxNqVbDKG5kwL+T/cQpIatFMYZhJA1D1mZuFve3eGQF1GUGA2hLwJk1
	 dm6NroQ8TLDreUUZfmjQGPlwraAEgOjHCOg9Dy6WjYxGIaeWGZEYGbb/XkZg3vjfG70ii
	 b2mboTQvTj/dfQ6LBvQRqYxIHGWUvbRYoi5owqNKJUCjAtvnzMvENBFl5x4Yx2yZ+9shB
	 uBzz80xhzdAnG80dECvjg9mwnvo+uA/r9pHaM74OhAI7KHyE6XTGu9ASZJiN2sG7+OTg2
	 sqA5kP7jKmrhwNh0QGt9H4Hkd7plB7Tv6T6cD2dR6jP1ZYKEjVShwyG5oUln0rIzxdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564206;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
	b=Qgh3H9sEaBSa1SfDeqN4BQ3oDpT945rnZYYk8b9f8yBJNScwyhmKOFZvJVOBkiY99+zi
	 kYc3k0WOP/aQDzQZ/eruWnn3bXRvjBHGEkrDWbd6viQ3nOuHGtH1WXNduGCuaFHa9P4p0
	 XPUE/ad86B9AdeASzNs6/OjBcOePBENiKhD5TZGckIy7zXqHpairRI1LcbjklYA39WrNc
	 yfknLGSO5ZCQcgk/Li6cpxNfbMBBXKlOodrjediBX+Fy+sq+afTPXzb0KkFI/2UGPhPqg
	 6RYZ45hOLWfNWJeRWFgAGNBPOo0F9HRQZvGCgozjsmBDAcJDzCQq4CCwbYExr+EFZbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gwzE4vcd;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76A660A2614
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 10:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B76A660A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gwzE4vcd
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b7a488a0a4so1112851a12.0
        for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 02:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564204; x=1795169004; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=gwzE4vcdu75novdCBouGsk6add5G1MbU4rjoUAUKLfhHjN16JXpL3TW62te0KeNQ4h
         CFkYIh/ZmfunLC+OqOwxPpTEErLMClrM1fcYGPQemfzJ8eoNcG0IRaMTNTZVl4uFMmTY
         NY1KgETdjv8quXYbE0ixE9wDZSzgcrDYvO5KUD1dPMwQkdJqOZ2wE5l6rVs/yjm1Qi5n
         44DBR0sdjAGKBFCF4ajO9UcYXSr02RfqiQv/3Y8VdogG9ka76OpTkDSlKx1J0txrvJw5
         RvPlb1UdQfd5RzPQ+F4LJqddQeogWrPEdkR1aa5XunF4ZwrUyeTcEOKG0iN98ugSQ46P
         5SDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564204; x=1795169004;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=mjqd6zfBgkdbNjPkCFR0Qg6hlAf1k0wyBa5nOnafThTB37+6gEwEViJcMInjjMDMgO
         MNni/tVvRhXidocLPi7ZuhHErAPTK+zg7dCgpcuiH9HYpU1nmX9P7T/819vtuS99hCUz
         +fS3hqVvtJd29YC8opqqeaw1AsEvrToLQeEt0H6mWgqz9vG1dlmz+zoHr3OIF1oyDCla
         UqPtVJVrJCEZObvQmsWznOnnEKw8yuR2J0knj5MmhMUj2H8xDHgAzNf0Ol2sj12+vdGZ
         9Q8jkh7wRMO4lPmt6xuptFccP36RIlI6tvWDc+o9tbs5QoSxrwG7hxfsaL4Q+hVP0v6t
         zirA==
X-Forwarded-Encrypted: i=1; AL+hErG/XBXtTGMAryExdy4IvyrLSKZbg2CDWKS8L/slA+Kl5gkUMsKqUjXnvFGi7dFC2alqbN5FHd5Qk+E=@vger.kernel.org
X-Gm-Message-State: APuU4Z/kJY943fwX6Kl7BTAEP7fbyBIgzKwgA0e00FxnrdlkpUbmbA7F
	n1LcRW9vlLT4Wcs1QwlkM5y5pWuaspYsG4a8WHVOOsFx+zE0jZqnp+HFkYuf4FrxvQAw
X-Gm-Gg: AYBFou3kEOGs5WcXhW7gdjA+8lXi4/LO+mZl8axZocLX4fElUeuUIJAbYEJyYou9ZWd
	D0nUA6nEqUckWqBXxtirgfYTRJb4snfIysJcg9bGY1DmKXgw0CW2d4ISv9s2iqUZAotZjvi5IAl
	vD21tEUOzSLSaZnfnVDBsCHI7cQygpWYUl2RhszPyckFWILRrSYLEnrBwwu9MxbvECoE1LzEiWQ
	dvw3Yr3QMJnTCS4XTfK83YZlVkjQ+rmHzxCc2Z+rbcM16xKPCVjE01P2FwbjS0rqWjvjPiwntZ1
	9fn49QSqyoLkgDPmqUObhJ7FqI81kzihM7SyDD5XgDNcKcyJjw883Fb58j49YgYyGxxw6FW1guo
	T61g6wm1A81CUTyZiTJ52NI3UXiLHCzvFyI/0vxI3dhGw6+WyOJh/bY9V+TbLNub0knmZhKHMNL
	LvhOW0+5ifXKbLnE7eA4RJMyezN8cugom7K49yYITkS5+xkIKMxPP4ZkJz4rcuWlopgKR90NFbs
	oAFMqRRqWckvdMY9HJQQjOFv7TkFN5ehvz/qekDW7Kh7Rg1zISXHrFuxoPkIyYJqNIlY9KQcGSa
	SWWreVoZXtu86ik6BFbwDnsImCLEtFRc4t18cgOrX97Ksy0GkltXxCgbLbqwi04=
X-Received: by 2002:a05:6402:270d:b0:6b7:d479:654a with SMTP id 4fb4d7f45d1cf-6b7d47965e6mr298323a12.36.1794564203570;
        Fri, 13 Nov 2026 02:03:23 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c236124esm752333a12.6.2026.11.13.02.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:22 -0800 (PST)
Message-ID: <e5f36cc53b733383ac1d1f1e8c03f73091595edf.camel@amutable.com>
Subject: Re: [PATCH RFC 08/41] mqueue: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:20 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
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
> Initialize mqueue as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0ipc/mqueue.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 322c3dd98c44..8bbe32d0881f 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/sysctl.h>
> =C2=A0#include <linux/poll.h>
> @@ -405,7 +406,6 @@ static int mqueue_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	struct inode *inode;
> =C2=A0	struct ipc_namespace *ns =3D sb->s_fs_info;
> =C2=A0
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	sb->s_blocksize =3D PAGE_SIZE;
> =C2=A0	sb->s_blocksize_bits =3D PAGE_SHIFT;
> =C2=A0	sb->s_magic =3D MQUEUE_MAGIC;
> @@ -457,6 +457,7 @@ static int mqueue_init_fs_context(struct
> fs_context *fc)
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(ctx->ipc_ns->user_ns);
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &mqueue_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
