Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5CC37FF56
	for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 07:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777275799; cv=pass; b=ZiG6NnFU1U86IMSkLZSs/DQ1LmEj76XqXoJf0rl93O2VBwnrAyG/txvUU0YV1jzaUOb76d4gQPWwK6JGYDlFZ2uq0u1cBUy7feGIvjSLgM2SQQby7/fVYBlBDJ5YhhVhKAc71OMtQkKA5L4JZ6QVcqtD6KATWHp0oEZSkUx1QIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777275799; c=relaxed/simple;
	bh=WmMNIGbAGBnWZSMlQH2IaOr5hvZoDWPa/zqdW8jKm/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bUz2IkMogKy9kX7qw4T0pjawlgVSYFp742pM7nF4vT7AS0sBrRTexlBv/WBKgWDLxesf7KTfP64SHzh/8ikVHRstZ584IF4g+IWEVcPyuIlZXnexVVmemcnqwaaHRz6uTMYEc7VhC2xnwS3v7Ytytwn13R/TMeGs7rohn5NfHqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a/FA44Bb; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a/FA44Bb"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8f9568e074so1634985766b.0
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 00:43:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777275796; cv=none;
        d=google.com; s=arc-20240605;
        b=EkJbW2rNHJR9FNsUPOFbyoE3lR0gftliPRcYGZSBYi2abvzzGdFzjfTVMwPPdaC3rE
         XBZ9VDpexfC7ua83mtDzoJOwQJSEfDxG0+eDrpZTi0qBaiJ9tR937vruoXWPDAYercAR
         ARNRU9TYPeFlQyW5wIRna1DbR2DkKwkWeO9mLSfdFZWx5CMa2fhmMYxGoxosSN22W8xE
         tIDeCgGe5z9MjXKmvFMbm+13tbjSU7+U7imv66ycTrq2z6zly6Jsfcb6B5fPmpXZMdKR
         RTTMj/cG6SajbdFWx3R/xac0W+PpjzMHAYiasT3pCSw9FetMDF0685521gF3fXjbrJXs
         K1Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WmMNIGbAGBnWZSMlQH2IaOr5hvZoDWPa/zqdW8jKm/U=;
        fh=mhSOxowBK5i3rFxDce1czB3tkWi7lKA6BZsYtDuHboM=;
        b=JDcCLv0c93bmuOu4T9CjkSFQu5uN1sUpvkbTjgsvKFqjc22T3hzKT0jd+b1XescNS9
         pYPQqdZm4BR8P2OksZi3Gm0tMFkbFWP/qTyroQvYLWcn9rELNiTu8f0XUuUX/1n/BMht
         Y2Pr4jL6+TBbsb1nG1SGQyJ9xafv4Au6/a3zlQ3izIybyZROlfA7CFlKz8p0mk8emzGY
         CtxcMSd9Uv6jYwzrYfB2Q5lgfSEBbFXBFQNexxFQOUCsZdaMdZorjmghbUFGzNsix8nZ
         sXkLoIk0ITk8Gvo+NEbi872KlT7QLW8dtpkvu1NnEfdOzed3ZOE7+HneBHPl/vSUVWOg
         O64w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777275796; x=1777880596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmMNIGbAGBnWZSMlQH2IaOr5hvZoDWPa/zqdW8jKm/U=;
        b=a/FA44BbzZXxxbedD8kE5+H1vrImlqqwN3YbeQOMdARXbVawR2vWZ5mOHYsA0YlO6v
         +mNHBShRUXyetKieaB97logJ3fHpKQfperZrl3A1YBRmfKG7kWwRx+OyWr2e4qHevHdI
         FkSbpfYlqPq1NF1ZGronloT46QL3AE0W1eJi35NbAOuLa93pZfVe2V8dNf/QqjdRZws0
         ccmYmpcAf4FGllvW8jDeuJuKAoC7AeJJj4aKFMgI4ZGbnMNhE3AXwvuBO7STe9DrOEVz
         0kGo3j33hKJgLfhPoGH91kHzGdQkBkILo/RhOF74RxQojeHWwmocHhlB52HiIugGKkx1
         ZoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777275796; x=1777880596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WmMNIGbAGBnWZSMlQH2IaOr5hvZoDWPa/zqdW8jKm/U=;
        b=dbTs1UjTYDf6Eb1tRUuKiUgnkhztkCwPufyIyv2E5NP2drzWzxtEQwoJf9TzIlyjBv
         n2tBmBc0mhnYcfJtbfBYzAOxHNvUjJtsJSvY5i43JVY5FFcmzfUsGIuayHo5CQV1Gkb6
         eFVAW9U5hma0coe+nWwzLfh2ho/h+qnG0Hxn5G+VGmxjmf6bzJ5qEqVwhUX0Mf9BUFFQ
         UJZDUeBtGJoa1rqFz6eWq2M5IivTVcj7wwmXWt7OsTqAhC3NmRgK/ASry9HQleYPQwbc
         c2mhRpdyF4GopAWaB+yUIU7MnnK4TdayY49fAqN3Voj3CnXXHkdfA5S0xmJtV8d6kInl
         EXvA==
X-Forwarded-Encrypted: i=1; AFNElJ8q0f6pc4hMrQ89JAkKUzDaGty2zNg/cSFZ+TgwjSOA9MFgfIewcHRKnU3jfF+S+a7yEmol5ENvyh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQzITJzHilm2s5l32SX22JGlcBtl2gC5JBfWL456S9rLQ4J8MY
	ooQuS9sITxP+K+f96a1FyE79HHmJLuQSrZmTLWRltf2uNeS8dQtrNKjQsX0Ye5pRdn82aA5AcgP
	7rrrHEQNR7TiDr/pz8Shd99V/YmJyo2U=
X-Gm-Gg: AeBDiesuim9mpf5jm80dgr0CCBWEdn8qJttWJp5StplGNMT4ymbcj68+amjD2QkLwtW
	4hBnzEMPL5VVJZA0NSZYAKsg+VGr0vs8KnOF4Rm/msW04HOPwbFw4Oz/tIyuux33cMy0xnrZrQq
	ZARSi3lxgfZ883H9uKC1Bbb/h+H9sTuwaH3o/VG5JsCTkz+8THXDXNQxmT9ZrMJ3m97uOKyCnoy
	m0ZY8oM/O9RGNd5nfIPetPdDYRaAKeAP9cJYfg7Ecfo7KDXpKO1Kw6wXijoNzBiKItvhS2na82r
	69H8eHKsRG+xs2fLhrBbcKXWfhCS7DE5GGQe1RoC0v18Q+jMJR9P
X-Received: by 2002:a17:907:c30f:b0:b9c:bc70:e928 with SMTP id
 a640c23a62f3a-ba41a91d717mr2121879166b.25.1777275795629; Mon, 27 Apr 2026
 00:43:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-8-neilb@ownmail.net>
In-Reply-To: <20260427040517.828226-8-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 09:43:04 +0200
X-Gm-Features: AVHnY4Li24Tmq3-41JYR95SCf6Z2AFdg2a4cjT7d8-aaRtTKWrSVG2trUoxa1eg
Message-ID: <CAOQ4uxi8rqkbhK4=8N1ncfU1m6bjdHLbinSf=j3k0oVEaSa-wA@mail.gmail.com>
Subject: Re: [PATCH v3 07/19] VFS: Add LOOKUP_SHARED flag.
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 6:06=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> From: NeilBrown <neil@brown.name>
>
> Some ->lookup handlers will need to drop and retake the parent lock, so
> they can safely use d_alloc_parallel().
>
> ->lookup can be called with the parent lock either exclusive or shared.
>
> A new flag, LOOKUP_SHARED, tells ->lookup how the parent is locked.
>
> This is rather ugly, but will be gone soon after we move
> d_alloc_parallel() out of the directory lock as ->lookup() will *always*
> called with a shared lock on the parent.

Neil,

Forgive me for being skeptical about the *always* part.

How long ago did we add ->iterate_shared()?

It's true that Linus eventually got rid of ->iterate(), but we did not
get rid of the assumption that iterate_shared() might be upgraded
to exclusive lock.

The obvious reason is that *someone* needs to do this work for
old filesystems, which are also hard to test and nobody wants to
touch them.

I have nothing against this patch, but I think it is more realistic
to state that LOOKUP_SHARED is here to stay, so if you think it
is too ugly, maybe there is something to be done about it.
Personally, I do not see the ugliness though.

Am I misjudging the situation of shared lookup wrt old filesystems?

Thanks,
Amir.
