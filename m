Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CF93E169B
	for <linux-efi@vger.kernel.org>; Thu, 20 Aug 2026 13:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787231828; cv=none; b=BSW2i+Zuq7gOlWVOXDvBAu3ZZHsdfQQ7k3vyhLhe4DdHtOGqBPeEGs6IzpNMWC6IMnev7u58OBXGeA7wJdFkaAbG/K6zubYwJdPX3q2RtuJYSB9Kv4N8PaAeCOIn3Pr6Q0WL6deFLqX7L1Cvezvfp692WEaQZN9zkyntHV1qwsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787231828; c=relaxed/simple;
	bh=Sy2cw8POdJ2lBi4KnfpGDYZklAX0myLUoFb3VFDKJeQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fKD2cL0mdyw7GjWwixWC5y/fFFqq77TdXno5aG06fZfb7/BcV5NlKtLndZklBHxriEb0f9+cnZxWLb67gHGdVVUuGggWmg7hoqsS2JjSnpQdvSxu60gN0KAzFpzM3q4MH3WtgTV8GdH4DwERcj3W9MPJzD0S78OY/OnjqZg+JBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WOQEggLa; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WOQEggLa"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso26802605e9.1
        for <linux-efi@vger.kernel.org>; Thu, 20 Aug 2026 06:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787231825; x=1787836625; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=irm8GSnQflsbzEKogo4Qk5ku/XY4gPUwlR5IzkAY5qU=;
        b=WOQEggLaDovH2O1EAVY6GbZgEthWgjo9Y9PLoFsl4p+ZcqJxZ5xAZkKmKl9iI/79re
         I8coEGtfTlEublk2TNJl4mBcsbGluy+ISCYciPIt+AGc1XXBh7p5kfUX48YfHvb05eQ2
         D6Po5NTDkflZtYSS6r371+few/r6F9mJXB6Wxl5ghiyYyjNYRoOzu+0+NAqy3ZiUy0S6
         RLjvQdwu4Km1YZ/PTI7S1t1dqTy63UZUlULnClqEUdqfh2O6mM20U4EAx+vrPuj/87zI
         hAZbcdA6g6sTlrnGhFuaUTrdPLFqQGFPG9sQ+jAKJLIsxT3/ldYwoXxeJO74ib+v+/fd
         lG/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787231825; x=1787836625;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=irm8GSnQflsbzEKogo4Qk5ku/XY4gPUwlR5IzkAY5qU=;
        b=gsLHfAPDG+24Ge/LivOzXCH9Fx6n2w/7K9AVQ3M08QxaB2BE/yG7WPcmx9mT/b2k1g
         40Ybeh35m5ZpwIhV9IcvfbMYGXB2bXYr8rpYwqEbF2RD5yTK35U8/Ltp+XEqTFIyfJc7
         8CHTRzB+AMZVDJl6J7++yBUYmML9BhUEiEHET8hXN5iKaxuboxkT8Xkp2I44E8LTG9bp
         UNG+ByTJghhzFuSZ5hfYsOLxV4iT6P+dSCGDsatV5yT/ojjdNd5uomF0IcVHqaYLxJRb
         bpCZI+szc9u9+9fiTnvRg/u6V7bUnLHKgbqcLjAgZ4y/cELYijZ3aoR3uUKN2XfE6SAk
         QBAg==
X-Gm-Message-State: AOJu0YzWV9wn1XgnOU+HYxGIF7gGK9qfxYcDqXCHCza6gmUDSnaYtP4S
	P+lIZhiRBR32SD4VLVr9STRgBZRECWosFcmI4qWMzbrWEw3jv/xXD3noeF2G8NW/gts6bCh5Mdh
	bC3kKf9o=
X-Gm-Gg: AR+sD10C97nRtH4BY38pv7MKi7yH1cTDiiu9m33gyqXc7E8bQ5bEH25mxeY79YqnVge
	afbfr48FadtEneBa5shgB9b6Hv4ckmtOJzM6oArmMSFKvEngkQKXauUT93r5SQxMMpZ1rB531cA
	XXGetUbMOPAbuS9hQaXcwWEKWIWWX0XWyNEW3bdNceAvj6hYbvYgmX7QKi56EKfeZwmTs0g2KS/
	cFmXm6lN+HPIrntkuu4b4hr/IkfTE64N7zM0KdzHAusXcY6ami1jFs2ntTSRvsMbpt5QQA4bXWF
	imak7hlSOgHSGlnu5gQDdOH+EXxm+HHPYPBM5Cy0XZ35yKdmA5x3yzsyswnOsAC4bWbeABW/cXA
	2YVthdgtReSGVDGSf4xWIk8xR55uhMWlvFgSf3U+uL6pARR92UFI1VfdxjWCYOyA3J1VmlgdGbA
	j5IDxaeMpzWaarLCGJx5ExX+n7we0InYmju6uyWXX9s2cuJw4kyYVlvYaDQi6get5E9deNJEaUh
	2acOx3NFOxr1W8VZYMcBm3uOQCB/MqnhLn6ZJM=
X-Received: by 2002:a05:600c:34d3:b0:497:ff73:68d5 with SMTP id 5b1f17b1804b1-499aa110a3bmr246765525e9.0.1787231824637;
        Thu, 20 Aug 2026 06:17:04 -0700 (PDT)
Received: from r1chard (1-164-84-97.dynamic-ip.hinet.net. [1.164.84.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa09b199sm126570585e9.0.2026.08.20.06.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 06:17:04 -0700 (PDT)
From: Richard Lyu <richard.lyu@suse.com>
X-Google-Original-From: Richard Lyu <r1chard@r1chard>
Date: Thu, 20 Aug 2026 21:16:55 +0800
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org,
	Anisse Astier <anisse@astier.eu>,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] efivarfs: Rate limit statfs() handler
Message-ID: <aob-R-ULD6S38waw@r1chard>
References: <20260818141150.905336-1-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260818141150.905336-1-ardb@kernel.org>
User-Agent: Mutt/2.2.16 (2025-11-22)

On 2026/08/18 16:11, Ard Biesheuvel wrote:
>Ravi reports that statfs() may be called by unprivileged users on the
>efivarfs mount point, which may result in a flood of calls to the
>QueryVariableInfo() runtime service. These calls are disproportionately
>costly on x86 systems where the variable store is backed by SMM, as each
>SMM entry requires a rendez-vous of all the CPUs.
>
>So rate limit the calls to QueryVariableInfo() at twice per second, and
>return the most recently obtained values for calls that are elided.
>
>Cc: <stable@vger.kernel.org>
>Cc: Anisse Astier <anisse@astier.eu>
>Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
>Fixes: d86ff3333cb1 ("efivarfs: expose used and total size")
>Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>---
>This supersedes [0], which had some issues, the main one being that a
>cache that requires explicit invalidation may go out of sync due to
>direct calls to SetVariable() made by other drivers.
>
>[0] https://lore.kernel.org/all/20260801144258.15977-2-ardb@kernel.org/
>
> fs/efivarfs/super.c | 30 ++++++++++++++++----
> 1 file changed, 24 insertions(+), 6 deletions(-)
>
>diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
>index 733c19571f1c..8d33f11db2a1 100644
>--- a/fs/efivarfs/super.c
>+++ b/fs/efivarfs/super.c
>@@ -89,12 +89,30 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> 	/* Some UEFI firmware does not implement QueryVariableInfo() */
> 	storage_space = remaining_space = 0;
> 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
>-		status = efivar_query_variable_info(attr, &storage_space,
>-						    &remaining_space,
>-						    &max_variable_size);
>-		if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
>-			pr_warn_ratelimited("query_variable_info() failed: 0x%lx\n",
>-					    status);
>+		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
>+		static u64 storage, remaining;
>+		static DEFINE_SPINLOCK(lock);
>+
>+		if (!__ratelimit(&_rs)) {
>+			ratelimit_set_flags(&_rs, RATELIMIT_MSG_ON_RELEASE);
>+
>+			spin_lock(&lock);
>+			storage_space = storage;
>+			remaining_space = remaining;
>+			spin_unlock(&lock);
>+		} else {
>+			status = efivar_query_variable_info(attr, &storage_space,
>+							    &remaining_space,
>+							    &max_variable_size);
>+			if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
>+				pr_warn("query_variable_info() failed: 0x%lx\n",
>+					status);
>+
>+			spin_lock(&lock);
>+			storage = storage_space;
>+			remaining = remaining_space;
>+			spin_unlock(&lock);
>+		}
> 	}
>
> 	/*
>-- 
>2.55.0.699.gb54405d56f-goog
>
>

Reviewed-by: Richard Lyu <richard.lyu@suse.com>
