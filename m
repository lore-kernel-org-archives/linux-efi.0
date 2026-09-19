Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EAE322A1C
	for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 14:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789827349; cv=none; b=oYWDTkb9Pv9u+X2H1L0yMPoWiG9n6TFjksknV2tQMdACbCE6Gr0kpqOwqCx6SMSPzEH7Br0GNZaeqE6cmdqIHYeR6JtLHu0Lbw3p9ihbjvMdAYNgB+S+3iBUiO14zp/Ha8cRNoqDV9Ok8CTvmrEQyHA+/AHymlW77L93tAxK7Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789827349; c=relaxed/simple;
	bh=7Ywu9wHGDJY8V6jFJ2w6Ivi/pbw62GoKi2blMN5etwM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JbUrOj5K6m1qB3OJvYG+W/NcmXdVxHsJeEqmM/Y+ousmNDeQdwR0bBEAEWS1PkFJC3fcvuQNopc49zMfDEM69O2QPZ+Skbls/96mvTG+/RWaJogBltkt/IOhX5vgkV+3MLI+yfrV9btZHOZcSPwR5gWSpKKa9VOPopfskwfKjM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G23z1QDz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G23z1QDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F771F008A3
	for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789827347;
	bh=ZHQNt2F7ph//QKd/Dcx1X0C3z22bcWkHaUtkyigDYBI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G23z1QDzc3fsSxuhTrLJIpBQgKbxieWQRWlzynMgFWSINgiqaTqh+lYvFgxMKLhJl
	 P5g+IxmxBWkqE9KttwTeaIyQdPkFB5m29YiCCQOHIJtEETSDKv1uBvcpedPCfMOt9l
	 IZYJlQnO4sDaZSCuqa5UxFM+hTJMX3cChIrtb8bGYu/VaXfyTKknqX5r6AlmwJep0x
	 No90WJ3vojX8xw+Bn4YSUwzZV6oOuAkdi7JoEprJS2ZBTP28ByKCvHmTl1gD5olAjb
	 CeRnCsNOqOPiucci/V+AnzxFD4ZDK3DhPntFhf84SooweR4VOloAZlq07NKzVY4eWf
	 a8R9WHhLJ3ndA==
Received: by mail-ed2-f40.google.com with SMTP id 4fb4d7f45d1cf-6a60590a85cso3140332a12.0
        for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 07:15:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx1x+g6zlj1ouetBOYN11O0BHGPG8Ah6Vv6r+AyVZflpX2XTBtL8b7WSxbZGwBN0QL+vlC0Zdzz4uc=@vger.kernel.org
X-Gm-Message-State: AFuF++mpBvKgrDehLX0e2gQZW10lc2gX87nL6TsCGpsJdJ/iuqZdgLBs
	J+KfbR/PlAPnE8ug5UhjMmYwR3MBrY3h97wraUsqHW2go4neTsbQibHUTIOcxJ6CS2KTG3sQi64
	lOP06yNg6lcxYt2IcTdg0siBa4uD7g0E=
X-Received: by 2002:a05:6402:21d3:b0:6a9:a5d6:622d with SMTP id
 4fb4d7f45d1cf-6aa577f53cdmr3570046a12.3.1789827345998; Sat, 19 Sep 2026
 07:15:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904100852.26006-1-dongtai.guo@linux.dev> <20260904100852.26006-3-dongtai.guo@linux.dev>
In-Reply-To: <20260904100852.26006-3-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 19 Sep 2026 22:15:37 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6uKKzXgrb8YK+VAdW55ODWtXp0bEju=dcmm7=MVxcc-A@mail.gmail.com>
X-Gm-Features: AcwNN1UTKroSTs8ThQILzapvRn9O7BvQxeeOOihMqsFr5wFvKBxjbfZvuj-g5Cw
Message-ID: <CAAhV-H6uKKzXgrb8YK+VAdW55ODWtXp0bEju=dcmm7=MVxcc-A@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] liveupdate: synchronize EFI KHO channel at execution
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, George,

On Fri, Sep 4, 2026 at 6:10=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> The EFI KHO configuration table is a global channel. Updating it while
> a candidate kexec image is still being loaded can leave the channel
> pointing at the failed candidate even though the previous image remains
> installed. Synchronize it instead from the image selected for execution.
>
> Use the actual scratch payload size rather than its page-aligned segment
> size, and propagate update failures before live-update serialization.
> Keep clearing the channel for cold and crash images best-effort.
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
>                 if (kexec_crash_image) {
>                         struct pt_regs fixed_regs;
>
> +                       /*
> +                        * A crash image carries no KHO state: clear the
> +                        * transport so the crash kernel boots cold inste=
ad
> +                        * of reviving from stale state.
> +                        */
> +                       (void)kho_sync_channel(kexec_crash_image);
> +
>                         crash_setup_regs(&fixed_regs, regs);
>                         crash_save_vmcoreinfo();
>                         machine_crash_shutdown(&fixed_regs);
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index dc770b9a6d05..147f5b5b23d4 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -1146,6 +1146,11 @@ int kernel_kexec(void)
>                 goto Unlock;
>         }
>
> +       /* Synchronize the handover transport with the image being execut=
ed. */
> +       error =3D kho_sync_channel(kexec_image);
> +       if (error)
> +               goto Unlock;
> +
>         if (!kexec_image->preserve_context) {
>                 error =3D liveupdate_reboot();
>                 if (error)
> diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
> index 228bb88c018b..4d4c2290e85c 100644
> --- a/kernel/kexec_internal.h
> +++ b/kernel/kexec_internal.h
> @@ -46,6 +46,7 @@ struct kexec_buf;
>  int kho_locate_mem_hole(struct kexec_buf *kbuf,
>                         int (*func)(struct resource *, void *));
>  int kho_fill_kimage(struct kimage *image);
> +int kho_sync_channel(struct kimage *image);
>  #else
>  static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
>                                       int (*func)(struct resource *, void=
 *))
> @@ -54,5 +55,7 @@ static inline int kho_locate_mem_hole(struct kexec_buf =
*kbuf,
>  }
>
>  static inline int kho_fill_kimage(struct kimage *image) { return 0; }
> +
> +static inline int kho_sync_channel(struct kimage *image) { return 0; }
>  #endif /* CONFIG_KEXEC_HANDOVER */
>  #endif /* LINUX_KEXEC_INTERNAL_H */
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
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
>         return 0;
>  }
>
> +/*
> + * Synchronize the handover transport with the image that is about to be
> + * executed.  The EFI config table channel is global, while kexec keeps
> + * separate images for a normal reboot and for crash.  Write the state o=
f the
> + * selected image immediately before it is executed, rather than while a
> + * candidate image is being loaded, so a failed replacement cannot leave=
 the
> + * channel pointing at that failed image.
> + *
> + * An image loaded through the legacy kexec_load() syscall, a crash imag=
e, or
> + * an image loaded while KHO is disabled carries no handover state.  Cle=
ar the
> + * channel for those images so the next kernel boots cold instead of rev=
iving
> + * from stale state.  Clearing is best-effort because an absent channel =
cannot
> + * affect a cold boot.
> + */
> +int kho_sync_channel(struct kimage *image)
> +{
> +       int err;
> +
> +       if (!image->kho.fdt || !image->kho.scratch) {
> +               efi_kho_update(0, 0, 0, 0);
> +               return 0;
> +       }
> +
> +       err =3D efi_kho_update(image->kho.fdt, PAGE_SIZE,
> +                            image->kho.scratch->mem,
> +                            image->kho.scratch->bufsz);
You can combine the last two lines.


Huacai

> +       if (err)
> +               pr_warn("failed to update EFI config table: %d\n", err);
> +
> +       return err;
> +}
> +
>  static int kho_walk_scratch(struct kexec_buf *kbuf,
>                             int (*func)(struct resource *, void *))
>  {
> --
> 2.53.0
>
