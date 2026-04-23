Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEB2370D67
	for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957672; cv=none; b=CGXQpiFlmOLApTtyWNvouLrEoZzfN6YJ2+0SMTive3+3hrX8CWyQ8ni0NIqsPDct2VwBevpqBoWvWZ8AAq2KIZl4HDA/cao9l/0YV30SNWxMHOsPBSFb4+d6fIxeVFZfaNT9k95a206h6DMl6Iiw45GEG6rZa5IFDLGhwe9SFus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957672; c=relaxed/simple;
	bh=5fjE4LXIEJmHTzQ/V/kRAovHQOQihCgfBFkxYfOGr8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cyqeiALmDWOg2oZCn7g7AYHoWOaBpAV/FfxDssUCedJdxBZNItFh2Z3f57gSLNhfzIrFhF7MjeDWWYEf4AbputeEWN2ZgFcIru44j/qFm187Zpn47gu9UjPvgx0SC73lf0ng1AJnfiJmaHCOY9llMY563XJMpH12Ik3ehF4CLSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XS/mv8kU; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XS/mv8kU"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4362197d1easo5380950f8f.2
        for <linux-efi@vger.kernel.org>; Thu, 23 Apr 2026 08:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776957669; x=1777562469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rdeqA1VGz5Iv1QFq/4S2zcxPd6cWnmrt4GnD1rhl1K8=;
        b=XS/mv8kUBFQAJXj0tldxoFGS36RPEumby6O0QUWbWfdqSm/ycgOWA+tbdYeQgAhPMl
         p4XyA+SNaB7q9HjEYL8n6w+3Ow2WIoc1Vm5rpNE2jmj4s3WOCqaNluzXpX2w9i0TAyzp
         OkwT7CbrzaYTk6NXxETdYSS1b9bTYt27RukiplG2u7JlzqZC1E0sYeZPtyGlc2q9b0iB
         2Jxp7/H5ro2L4HJIFjK1xPRhcZDb49KEfE5cBL7W+QXKoMYaSSY1amNZ3C6iqLvObajP
         4PkrQCuldN0JwjZqtEuriI5sRvCIPd3TX2IiEcz6hI358tIcKO91rIdpC0pvISAXsxQP
         wVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776957669; x=1777562469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rdeqA1VGz5Iv1QFq/4S2zcxPd6cWnmrt4GnD1rhl1K8=;
        b=sNTjwjTFOTOzsDaQdamHmhlyWg3y8QiFQBAK6lqYD1szbILdcMaGjKcrkwx5/NtchY
         K7lDHJPv9a3JK2mjSd8t1i3Z5/EBpKd9Gwy8zKZRrPUSJgMNHXf9HgiG0ICRsFcbrpaC
         Q6BCRH/dV4lEzeFiS6wygBKYboZceztYIg+qIy4dmUiZzZaUmeaPqyI4NxKgTELqVSrT
         majcyoN7CewprHV1qKfVrGee/C0Fg2wCRD/Of5kPWss4PT64C1aQDHWwCefi7K4CH4fF
         2cVyI8TyZKzgU1BgtNpuqndoqXDxJatX8iSBAv/kBOO92aJgSE/1PZqPdLk1I1Wvev6z
         Gbsg==
X-Gm-Message-State: AOJu0YzEaQlGWwmWeq7YpTMFEw3VqmI9kqxUAF3ffXwJE4/UH7WR/vvh
	OKEiaWo9KxJJAfoiueKNMOVaVWc+l+7DEBAqtCdozXYbBUBrrIT8knqbC4EROCb/tfJRY0M6bg=
	=
X-Received: from wmaw6.prod.google.com ([2002:a05:600c:6d46:b0:488:9438:99d5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f13:b0:489:1a65:dd6e
 with SMTP id 5b1f17b1804b1-4891a65de3emr293129545e9.8.1776957668705; Thu, 23
 Apr 2026 08:21:08 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:20:33 +0200
In-Reply-To: <20260423152024.1098465-19-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260423152024.1098465-19-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3017; i=ardb@kernel.org;
 h=from:subject; bh=dGldVZd5uK6BXjGk3oUfE6gDN9Ky6KDworVGSvSdAhY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfOVxRGRQnvlk08WJp1/tT/o1m3NXhmZwsKOwGXHzzzet
 2NO6mr7jlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCR9a2MDE8j18+z+fPo6z82
 Fcbv1wo/C6wUXMS35IuYSWLqycjgb4sZ/oofYbnNYpml2So6P07yeHRouj3DiumZYT4Tivv1nl1 7xgsA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423152024.1098465-27-ardb+git@google.com>
Subject: [PATCH v3 08/17] x86/efi: Allow ranges_to_free array to grow beyond
 initial size
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Young <ruirui.yang@linux.dev>, 
	Gregory Price <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

In order to avoid the need to mangle the EFI memory map, which is being
done to keep track of which boot services data regions are really really
reserved, and which ones are only reserved temporarily, this information
needs to be recorded in a different manner.

The temporary ranges_to_free array is a suitable candidate, as it is
specifically intended to capture which boot services data regions should
be handed back to the page allocator once deferred struct page
initialization is done.

This requires that boot services data regions are intersected with the
memblock reserved list, and this may result in more ranges_to_free
elements than the current upper bound of the number of EFI memory map
entries.

So reallocate the array when running out of slots.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 40 ++++++++++++++++----
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 1d10277796b7..ce452e5c2f0a 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -401,23 +401,46 @@ struct efi_freeable_range {
 	u64 end;
 };
 
-static struct efi_freeable_range *ranges_to_free;
+static struct efi_freeable_range *ranges_to_free __initdata;
+static int num_to_free __initdata;
+
+static int __init efi_add_range_to_free(u64 range_start, u64 range_end)
+{
+	static int idx __initdata;
+
+	ranges_to_free[idx].start = range_start;
+	ranges_to_free[idx].end = range_end;
+
+	if (++idx >= num_to_free) {
+		num_to_free *= 2;
+		ranges_to_free = krealloc_array(ranges_to_free,
+						num_to_free,
+						sizeof(ranges_to_free[0]),
+						GFP_KERNEL);
+		if (!ranges_to_free)
+			return -ENOMEM;
+	}
+
+	/* add a terminating entry at the end */
+	ranges_to_free[idx].start = ranges_to_free[idx].end = 0;
+
+	return 0;
+}
 
 void __init efi_unmap_boot_services(void)
 {
 	struct efi_memory_map_data data = { 0 };
 	efi_memory_desc_t *md;
 	int num_entries = 0;
-	int idx = 0;
-	size_t sz;
 	void *new, *new_md;
 
 	/* Keep all regions for /sys/kernel/debug/efi */
 	if (efi_enabled(EFI_DBG))
 		return;
 
-	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
-	ranges_to_free = kzalloc(sz, GFP_KERNEL);
+	num_to_free = efi.memmap.nr_map;
+	ranges_to_free = kmalloc_array(num_to_free, sizeof(ranges_to_free[0]),
+				       GFP_KERNEL);
 	if (!ranges_to_free) {
 		pr_err("Failed to allocate storage for freeable EFI regions\n");
 		return;
@@ -452,9 +475,10 @@ void __init efi_unmap_boot_services(void)
 		 * memory here.
 		 * Queue the ranges to free at a later point.
 		 */
-		ranges_to_free[idx].start = start;
-		ranges_to_free[idx].end = start + size;
-		idx++;
+		if (efi_add_range_to_free(start, start + size)) {
+			pr_err("Failed to reallocate storage for freeable EFI regions\n");
+			return;
+		}
 	}
 
 	if (!num_entries)
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

