Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9575C3A8757
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 21:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777497000; cv=none; b=f1cKXyL8RypahWvoVi7BmWTWor/qPY7x+91v00v6MFpz9vzAm1svuE+AhSS40wj7DjOjQ8YCnVkDvyMU0h5FpKo39pRRD8mrPR4kinpe4YhIrM9JuibFMdlIRDfqx89hhoyIKyFhp8EQ2kAm223a9zkDyz1cm84B/ZG9YHn4/6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777497000; c=relaxed/simple;
	bh=tKD1kZoqphx/1IqZo+FxuGf68uivswEb8Ml+8Wv6abw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LWfS1vuq1SZk/LgVpNCaM4KiqnOqjSV8r17zZ1jbKI8bWQEVkNOmfMM0DRrUwgFWX9KnJPvlQU1vBEv5wsr/JVEhBvq6mKseK5w5bP6X07+KwO1YYe65fALD8lGTQfIx5q8JMpx9x7myNAjsotX1mzaTwKmWSieGzzYweIO9Etk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GamSdEN1; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GamSdEN1"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ba8472c1613so34334766b.0
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 14:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777496996; x=1778101796; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HnqVnLYxhZQkXEJ+qyCw2Y174F/Hy99oiICnSXcEeRc=;
        b=GamSdEN14xHCNK9pd4PyrGGnYd/BnswBKUZuJC4/GwxxeuBPgFg2dzIaXBJGmLGpea
         mVm4Iwz92J2Xxy6doZTWzjmdJTjHQU8XPP8V9f++LHWaAcSbqARGiGRPP/cNikf18IyX
         KO9Pa3Gf2yFoUKALQN8gjYoRFUro/ptX1FHxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777496996; x=1778101796;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnqVnLYxhZQkXEJ+qyCw2Y174F/Hy99oiICnSXcEeRc=;
        b=pQGOGW7OAan12dqVGO6yem12gG8nKXQqVLP0u+RVfRJjmPWmG9l8Zv3P4Q+mSxed/s
         TXLBvL0MitpPhsl4NXvI2mvOy8gPSQrzg/7i3rKCeZjD6pF6t1UxfhOg1rtPTulUJtaQ
         VoePdMkwwWV1YpEYfQ6NH18WlkOvM4qWxWjZraQvx2s2s6/7WemA18TOTm3ejA5MylFJ
         x6UAGZ8MAw0bylBrT15I4HqtgXCs2DS8MIersfy0nYG1f9JdffJiJ8xpbnIr3woX2khF
         1F/v3iWJY/nDXFQLBeASWF7ssddxj5kQdbMUG/WgtHSiOh4MqZ+Q11LcR6Nn6q0xwIRW
         DxLw==
X-Forwarded-Encrypted: i=1; AFNElJ/dB3aUFRNQefBJi5OxRFU0dcZE3xms8y5JwaiOa/MguD/YU91qVgE+EOro+Iev4OOFKHxQ4yawTIM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwW52Q8gc7Yrbv9ld2J+YPi3upGR0MoG4xK3tPU+GChOuvp08Y3
	1AdsFbjMEGDyxH3onD80H9BojZtDpIQ9bEAr/M5MZzIAFKwmc5NxFg/qP6i2vOxLi9vGo/fy2ET
	f7YGfbAI=
X-Gm-Gg: AeBDiesK9wHeqUtwMgYqlSCzxtfwnC3/tadkG32NX6QMxnIkfp/1L+K4eizyb1trdll
	tvtvDuFqLKZiLOCYMwWufDn/4aiEo46gXz8iEzhCWkyNhvStcK6MiHVzoif9GNhJl+ChhRKBjE9
	KaCzQrY+2uYNXXApze1fgQlHYZsd0IHAV6RZJ2nMRtPmEESec1dYTtzCPdNHTLoRbqtdaDRSKUN
	yxmua0OsoRpwbsNGYE6YJIcWgt2/ivYEiv5G2U95CVFh+s6js/ev7FeAQhVU0PZ3sH0eObK5NZh
	BdzfygrV+6JjhUW7Mpj0A19rbz1k0zj5e8/lS3rtAQwdo1g0khx/QEAa3KL1ktMj3+bGTgHMrLd
	k0rL+Yf7SJhEVhJ6aaGKt2kvAajg7K7nL+/eQs4NiIHKN5pNd865I2rCJc3/qqVGN4KeGK0cBLy
	5/u5Q1iQV3fVUQFW/FK2K7nKuBct46atMaH90UoNxoLBBFIG3faODgZTkxO5uUQ6V5a5HSRgBVv
	mkAWEJcyxw=
X-Received: by 2002:a17:907:788:b0:ba5:4bb3:38f9 with SMTP id a640c23a62f3a-bbac65abd6emr21904166b.27.1777496995418;
        Wed, 29 Apr 2026 14:09:55 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67b22177d15sm1052939a12.26.2026.04.29.14.09.55
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 14:09:55 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ba8472c1613so34329666b.0
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 14:09:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/HeBQfeaqURLnBVRAJMv9vCQ5wgrz153c2D1ftB0PhS3XOvVizy5Awd73bm9+HK11jZqVCarbleh8=@vger.kernel.org
X-Received: by 2002:a17:907:5cb:b0:bad:dfe1:6a56 with SMTP id
 a640c23a62f3a-bbac6ac310emr20951866b.30.1777496634502; Wed, 29 Apr 2026
 14:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-5-neilb@ownmail.net>
 <20260428033738.GV3518998@ZenIV> <177737511992.1474915.1952404144121931523@noble.neil.brown.name>
 <20260428142225.GX3518998@ZenIV> <177741881482.1474915.12527082398060370192@noble.neil.brown.name>
 <20260429052626.GY3518998@ZenIV> <20260429170731.GZ3518998@ZenIV>
In-Reply-To: <20260429170731.GZ3518998@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Apr 2026 14:03:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgs8yAfaQYmeKWab7KES0jU46TvdBfQ3Q9+6+=E=vrx=w@mail.gmail.com>
X-Gm-Features: AVHnY4JtG_9GDiz56QzrtD5BrZqKcsiFlr8t2n0kWXJmeuX800NGv4Qx6DLxhBo
Message-ID: <CAHk-=wgs8yAfaQYmeKWab7KES0jU46TvdBfQ3Q9+6+=E=vrx=w@mail.gmail.com>
Subject: Re: [PATCH v3 04/19] VFS: use wait_var_event for waiting in d_alloc_parallel()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: NeilBrown <neil@brown.name>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 29 Apr 2026 at 10:07, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Something like patch below (on top of -rc1, completely untested).

This looks like a clear improvement to me.

... but I obviously didn't test it either. But just looking at the
patch I went "Make it so".

             Linus
