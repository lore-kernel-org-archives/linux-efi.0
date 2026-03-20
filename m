Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FC33DBA0;
	Fri, 20 Mar 2026 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774015727; cv=none; b=lLL7+Dv9Prhnkov3fluH+/uCrEihqme3nZlQHb0Axx6P+i6DwuyaW9r1nINCRdWY51gzunAJVhzgMxm9wN3Qbx9rassRYbIRzsJiccetIonOlJ8S5sWp9s1bwR3T5HtK89ostQR2VY5MRD3VNK0cwrPTVbtlp9DvMgtFxUvlNKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774015727; c=relaxed/simple;
	bh=WVfZ6L3FLNwGx30VAAwIZX8hW08FXLNTDmV3F+t04M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r431NrI4IRMimIQtYiwuyQVMTzRgvq6+z2bLzvJ0Pr7Yp/bzMdl/hva2Uh7FnMLarOyzZbvPEx0GdKJY3ttLGodQjS045yk9iYPcq7LEhhz3+PxsXSYVmM1uhaxe29zFOWiwLL7g7Es84bfXHpXu1gND9+iIHF34Q/s4npZ/1CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhAaxFSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhAaxFSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281DBC4CEF7;
	Fri, 20 Mar 2026 14:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774015727;
	bh=WVfZ6L3FLNwGx30VAAwIZX8hW08FXLNTDmV3F+t04M8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NhAaxFSrV4BUv1KSuYXShMeuUJzOWECv9F5WlASjf1RgEmQiERGW2NKQ1HK2d1LkF
	 yuQO86/wJx4eBlMJhreQPiApetKUnm1bWlXZGfqxHgjIPJ05zE+5QKpBsDWp0oc9dW
	 bvyz2++8asRAjzLChvN7iVZ/WKgyiB0Z/zGbZSjtSHZXD14XE0MGBATfVywy2fv7E3
	 kpGnRjXXvtFpuJlOb3mEWUag/IKfDzOkhcp+3JlIr4GnE3b0jgXiVE7lC5ag1efQju
	 6BKgUM0Fo2tZGyolod/yUxlZClln7KfD2GVAF09ve6dLkCXL1/TjijDwMU3lPauReF
	 coD04aYxlRAlg==
Date: Fri, 20 Mar 2026 16:08:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Message-ID: <ab1U59ye2eBOz6x3@kernel.org>
References: <20260225065555.2471844-1-rppt@kernel.org>
 <100b9ae1-74cc-48b3-ba63-1a72cfa2ebbd@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100b9ae1-74cc-48b3-ba63-1a72cfa2ebbd@roeck-us.net>

On Thu, Mar 19, 2026 at 09:06:52PM -0700, Guenter Roeck wrote:
> Hi,
> 
> > +void __init efi_unmap_boot_services(void)
> >  {
> >  	struct efi_memory_map_data data = { 0 };
> >  	efi_memory_desc_t *md;
> >  	int num_entries = 0;
> > +	int idx = 0;
> > +	size_t sz;
> >  	void *new, *new_md;
> >  
> >  	/* Keep all regions for /sys/kernel/debug/efi */
> >  	if (efi_enabled(EFI_DBG))
> >  		return;
> >  
> > +	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
> 
> Was this possibly supposed to be
> 	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
> 				       ^		     ^
> ?

Yes, thanks for catching this.
 
@Ard, can you please pick the fix:

From 8fc5c5e828e7d127e6210bc9952451300591cdce Mon Sep 17 00:00:00 2001
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Fri, 20 Mar 2026 15:59:48 +0200
Subject: [PATCH] x86/efi: efi_unmap_boot_services: fix calculation of
 ranges_to_free size

ranges_to_free array should have enough room to store the entire EFI
memmap plus an extra element for NULL entry.
The calculation of this array size wrongly adds 1 to the overall size
instead of adding 1 to the number of elements.

Add parentheses to properly size the array.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: a4b0bf6a40f3 ("x86/efi: defer freeing of boot services memory")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 35caa5746115..79f0818131e8 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -424,7 +424,7 @@ void __init efi_unmap_boot_services(void)
 	if (efi_enabled(EFI_DBG))
 		return;
 
-	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
+	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
 	ranges_to_free = kzalloc(sz, GFP_KERNEL);
 	if (!ranges_to_free) {
 		pr_err("Failed to allocate storage for freeable EFI regions\n");
-- 
2.53.0

