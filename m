Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DE1545DB8;
	Tue, 22 Sep 2026 12:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081291; cv=none; b=DnBG3yXZTSjyF+8TE5TVFK1XlTy1ryk0U8F7er5A8zrRC4A4WwBMwT8qZJz0Xuk17OCK2I/796HeDcpvvfsWJYLDChdH9GUtLohKbKNPNs7pJ/2MTbFJ14JHqLazk7JBJt1jTYgJp3gC6kV32RmL5RGe4WD72IAKx1vf2MVvASk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081291; c=relaxed/simple;
	bh=Ki+wzMOd7XKBTD8hRP7BQu1HaNe7n80jfs5kZy6rBz4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tvvt7HZSpqA3GsGoLRLgHO+wFZPYPqu+t0jTjsPpqe/PP7uU+uh6eoAE/SWpzbdfOiQK4Kl3zKq5iewIm2b4BCtJc25JnKC6TZnZbpDudv7zLku3EbvnA1Q95gncbW/BgD6tkwG07CwEXK/XS1fOjGuq+exzZkxu1Hz2meQiUUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxRcrfCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxRcrfCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CC61F000FF;
	Tue, 22 Sep 2026 12:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790081288;
	bh=r4eH9hr+yvfFnvbbCrIYejYZnIdTOc3jXJLWRBe+BYc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=AxRcrfCKj4TeX6ZLNGmys0EohkLSWdZA4WpCoVu2s2m54mvKPCy6liQKcGrQ8XbgI
	 SQupz29e6y7f+7JP+FdhlC3s1z2X8i7JkPdbM3Y976b8njRgJrKLRElYxFR9JEM0BM
	 8TCcoyrcCXV565sfkLcc6LcmZjQmjecePjY6QHJrrJkVK8K8VbGFL91PeILG+FoFl9
	 1THEXtqQfFgXse9S65S+IyHqHuKjKQQgT8FUJXtwclVIR9dTtE3pMYo8uBe0eAvsYc
	 VeRU/FuqXgJPqY0qchNGgBdyeHHurNFz2kQGrv3nsl9hWhSY6PVrVOyB3nSxSAKtfk
	 9k3gXyOmIuBAg==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org,  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  chenhuacai@kernel.org,  ardb@kernel.org,  shuah@kernel.org,
  ilias.apalodimas@linaro.org,  akpm@linux-foundation.org,
  baoquan.he@linux.dev,  ruirui.yang@linux.dev,  guodongtai@kylinos.cn,
  kernel@xen0n.name,  graf@amazon.com,  liukexin@kylinos.cn,
  loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kselftest@vger.kernel.org,  linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 2/5] liveupdate: synchronize EFI KHO channel at
 execution
In-Reply-To: <20260904100852.26006-3-dongtai.guo@linux.dev> (George Guo's
	message of "Fri, 4 Sep 2026 18:08:49 +0800")
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
	<20260904100852.26006-3-dongtai.guo@linux.dev>
Date: Tue, 22 Sep 2026 14:48:03 +0200
Message-ID: <2vxz1pal5u64.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Sep 04 2026, George Guo wrote:

> From: George Guo <guodongtai@kylinos.cn>
>
> The EFI KHO configuration table is a global channel. Updating it while
> a candidate kexec image is still being loaded can leave the channel
> pointing at the failed candidate even though the previous image remains
> installed. Synchronize it instead from the image selected for execution.

Huh? Sorry, I don't understand this is supposed to mean at all. What
failed candidate?

>
> Use the actual scratch payload size rather than its page-aligned segment
> size, and propagate update failures before live-update serialization.
> Keep clearing the channel for cold and crash images best-effort.

Huh? This is word soup and I don't understand what any of this is
supposed to mean.

If you are using a LLM to generate this, please _read_ what the output
is and see if it even is readable to someone else.

And if you are writing this by hand, then take a step back, and consider
if patch reviews can even understand what you are saying.

>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  kernel/crash_core.c                |  7 +++++++
>  kernel/kexec_core.c                |  5 +++++
>  kernel/kexec_internal.h            |  3 +++
>  kernel/liveupdate/kexec_handover.c | 33 ++++++++++++++++++++++++++++++
>  4 files changed, 48 insertions(+)
>
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 2b36aa9fade0..6166ce4203d3 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -138,6 +138,13 @@ void __noclone __crash_kexec(struct pt_regs *regs)
>  		if (kexec_crash_image) {
>  			struct pt_regs fixed_regs;
>  
> +			/*
> +			 * A crash image carries no KHO state: clear the
> +			 * transport so the crash kernel boots cold instead
> +			 * of reviving from stale state.
> +			 */
> +			(void)kho_sync_channel(kexec_crash_image);
> +
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index dc770b9a6d05..147f5b5b23d4 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -1146,6 +1146,11 @@ int kernel_kexec(void)
>  		goto Unlock;
>  	}
>  
> +	/* Synchronize the handover transport with the image being executed. */
> +	error = kho_sync_channel(kexec_image);
> +	if (error)
> +		goto Unlock;
> +

Why are you setting this at kexec time? Why not set it at load time like
every other architecture?

Also what's this "sync channel"? Use simpler words that _actually
describe_ what they do.

>  	if (!kexec_image->preserve_context) {
>  		error = liveupdate_reboot();
>  		if (error)
> diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
> index 228bb88c018b..4d4c2290e85c 100644
> --- a/kernel/kexec_internal.h
> +++ b/kernel/kexec_internal.h
> @@ -46,6 +46,7 @@ struct kexec_buf;
>  int kho_locate_mem_hole(struct kexec_buf *kbuf,
>  			int (*func)(struct resource *, void *));
>  int kho_fill_kimage(struct kimage *image);
> +int kho_sync_channel(struct kimage *image);
>  #else
>  static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
>  				      int (*func)(struct resource *, void *))
> @@ -54,5 +55,7 @@ static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
>  }
>  
>  static inline int kho_fill_kimage(struct kimage *image) { return 0; }
> +
> +static inline int kho_sync_channel(struct kimage *image) { return 0; }
>  #endif /* CONFIG_KEXEC_HANDOVER */
>  #endif /* LINUX_KEXEC_INTERNAL_H */
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 39f489a258d9..3aa5c66dfc6d 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -14,6 +14,7 @@
>  #include <linux/cma.h>
>  #include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
> +#include <linux/efi.h>
>  #include <linux/kasan.h>
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
> @@ -2074,6 +2075,38 @@ int kho_fill_kimage(struct kimage *image)
>  	return 0;
>  }
>  
> +/*
> + * Synchronize the handover transport with the image that is about to be
> + * executed.  The EFI config table channel is global, while kexec keeps
> + * separate images for a normal reboot and for crash.  Write the state of the
> + * selected image immediately before it is executed, rather than while a
> + * candidate image is being loaded, so a failed replacement cannot leave the
> + * channel pointing at that failed image.
> + *
> + * An image loaded through the legacy kexec_load() syscall, a crash image, or
> + * an image loaded while KHO is disabled carries no handover state.  Clear the
> + * channel for those images so the next kernel boots cold instead of reviving
> + * from stale state.  Clearing is best-effort because an absent channel cannot
> + * affect a cold boot.
> + */
> +int kho_sync_channel(struct kimage *image)
> +{
> +	int err;
> +
> +	if (!image->kho.fdt || !image->kho.scratch) {
> +		efi_kho_update(0, 0, 0, 0);
> +		return 0;
> +	}
> +
> +	err = efi_kho_update(image->kho.fdt, PAGE_SIZE,
> +			     image->kho.scratch->mem,
> +			     image->kho.scratch->bufsz);
> +	if (err)
> +		pr_warn("failed to update EFI config table: %d\n", err);
> +
> +	return err;
> +}
> +
>  static int kho_walk_scratch(struct kexec_buf *kbuf,
>  			    int (*func)(struct resource *, void *))
>  {

-- 
Regards,
Pratyush Yadav
