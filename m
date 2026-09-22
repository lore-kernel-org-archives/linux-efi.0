Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3895542803;
	Tue, 22 Sep 2026 12:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790080249; cv=none; b=nIcm8BVFey/YDfast8VS5YQn7lymnGzc0BOq2CoMHDWzArWpATosetQgUa2+c6mEVMZNZZxoZgwB2h2da/nINUE4REykHFRpniqn7rGqNJ9w0jB5Eg6WjkknrZmmckiBy5aTtfIHh3FfzRQhkovFghC7e1LoMvq3wse0YR/PzoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790080249; c=relaxed/simple;
	bh=Qs+hH9j5ECf7wu8c8yamJoQ9GRescqfKiHV5zZgWxxY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TDN5KqwUn49McftdmCHT/9JOuM6rCXG0SP9LLal40xlB46nrtWxco8maYfVAj77bPNdrS6kq4WPQhskeswrY8YooBlO2jY/LaHNG6cdfhypdcmtDhzMh92P+XPA1jFhvcjJuMzplsLjkibQ0jcB99h4hw1WqlaBEK/mLMEWAYzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4TcHUGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4TcHUGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E541F000FF;
	Tue, 22 Sep 2026 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790080247;
	bh=Ic/h6nB8JUlBM8zaXvVjgvTf0SPmAf0fMbuRRf6h1OU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=O4TcHUGvDUaiZAcbWB6yDzYBqy/coJnW/7scfWIrPA9JZxubQUqIJf+7nKN83DAvz
	 U3rD2gr4++NFyoHbWT7OGBHQAnistbtAfT9opp3pPyes8L3+xOT//5ld67ttl0foKz
	 nXPLSXKR+pImSUOXClFkHmJBrLLIrFeQMPqtNcb9BryKjXCfhBjEnN9oi8UW7pkOYA
	 Hq+AfNeeC/W59e3rt+G6pf9lVI8MhGhbKvOoZk761TLTZJ9xR5xBsZNMSg2dNWGc8+
	 FIGiRNf6VjsnCN/LNVHx/rSj4nVE7vE+zwGwcigogdyg+GL6/GP2A9eRl5QX8kga0z
	 ZSCN83j72ugfQ==
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
Subject: Re: [PATCH v5 3/5] liveupdate: kho_block: include linux/mm.h for
 virt/phys translation
In-Reply-To: <20260904100852.26006-4-dongtai.guo@linux.dev> (George Guo's
	message of "Fri, 4 Sep 2026 18:08:50 +0800")
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
	<20260904100852.26006-4-dongtai.guo@linux.dev>
Date: Tue, 22 Sep 2026 14:30:43 +0200
Message-ID: <2vxz5wzx5uz0.fsf@kernel.org>
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
> kho_block.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
> CONFIG_KFENCE=y, these macros (in arch/loongarch/include/asm/io.h) expand
> to offset_in_page() and page_address(), both declared in <linux/mm.h>.
>
> Since kho_block.c does not include <linux/mm.h>, the translation unit
> fails to build with CONFIG_KFENCE=y:
>
>   asm/io.h: error: implicit declaration of function 'offset_in_page'
>   asm/io.h: error: implicit declaration of function 'page_address'
>
> Add the missing include to fix these build errors.
>
> This is the same root cause as the luo_session.c build fix previously
> acked by Mike Rapoport [1]; the virt_to_phys()/phys_to_virt() calls have
> since been refactored from luo_session.c into kho_block.c, so the fix
> moves with it.
>
> [1] https://lore.kernel.org/r/ai5nYlbERQBXRHSp@kernel.org/

Drop this paragraph please. History of previous patch postings doesn't
belong in the commit message. You should write this kind of things below
the "---".

>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  kernel/liveupdate/kho_block.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
> index 0d2a342ef422..0d56891b2f4c 100644
> --- a/kernel/liveupdate/kho_block.c
> +++ b/kernel/liveupdate/kho_block.c
> @@ -25,6 +25,7 @@
>  #include <linux/kho/abi/block.h>
>  #include <linux/kho_block.h>
>  #include <linux/slab.h>
> +#include <linux/mm.h>
>  
>  /*
>   * Safeguard limit for the number of serialization blocks. This is used to

-- 
Regards,
Pratyush Yadav
