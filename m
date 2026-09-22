Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C0B3D3CE2;
	Tue, 22 Sep 2026 04:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050442; cv=none; b=YsLeSnOcSezApqerv8u+mmhM52KpVBOZUquR4JnQFRbfBK9jdtBlvw/BfEhFg+xhDcjXXYvCpWeF3H9KmzfhxCseTyX/7bCgmAt07UURWhJ/lF8FLZ0rJ9Q3YsAKT2Tx4uRErW3DTHIWxqFaYx3jOyjp1Osl8qc5NjlEo5nb6hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050442; c=relaxed/simple;
	bh=thROVI5oeFdauobN5reuRsogOQP6boITRtrDJcLge1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5MALiFBW0UK3R3GnTKAZQu4Psmj1WmSbBfvHZn4OL6w4UAJcO8/co9RkjBVBybN47jzqL7mP9DzD9CtDiuLJI4xBhFWkGjCK9f9AVMcGWGnn7Bzp5+N7RYdtdt5rDVcAT+fZ6tGqGMc6sTIEGXZczAzoBXMyIg6DRKXlzvmyH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNK1gNgS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNK1gNgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477B01F000FF;
	Tue, 22 Sep 2026 04:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050440;
	bh=3JhbkvL+0f8gvXye8KGOOiOlIpLpto8LiGmguIZMevY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNK1gNgShJJpusLlZPOmjVBfk/yMx/e4K7M/fOX449kJiCAMPuoIP0wPz99MYiEPk
	 moidshyK8kQSZv4gEJRA0Pglkggl8AXaRI0oTuz6P/YUWZfwhRv3EUs0GPyRU9oD0m
	 DPlnk9bJmyB1bKQzY9a5yXfJEZpedncnBnPic6OTPA4IOIqeGLYtMKlummlBXb/apz
	 4XWA9rdTaHLORV4+DmBLyct59dfMpLSbNsx7Nv77bTjg5dSwhXQOoY7wM8ceFqXwFw
	 QMwyRjlT7mGCTtVnRT9/RwXWri9F/XB/SIJLX0NjGZIjSKApwSf6ITh9Xm8iX0XsQh
	 rOyCMTm7zwOCA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <baoquan.he@linux.dev>
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH v3 4/4] kho: rename kho_scratch= commandline parameter to kho_bootmem=
Date: Tue, 22 Sep 2026 06:13:16 +0200
Message-ID: <20260922041321.233986-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260922041321.233986-1-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

KHO now no longer uses "scratch" to describe the memory areas passed by
previous kernel. Instead, it calls them boot memory, or bootmem in
short. Rename the kho_scratch= commandline parameter to reflect this
terminology change.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 Documentation/admin-guide/mm/kho.rst            | 4 ++--
 kernel/liveupdate/kexec_handover.c              | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6132fa73382a..8a42a924f133 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3031,7 +3031,7 @@ Kernel parameters
 			"0" | "off" | "n" - kexec handover is disabled
 			"1" | "on" | "y" - kexec handover is enabled
 
-	kho_scratch=	[KEXEC,EARLY]
+	kho_bootmem=	[KEXEC,EARLY]
 			Format: ll[KMG],mm[KMG],nn[KMG] | nn%
 
 			Defines the size of the KHO boot memory region. The
diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index a6a09b693413..902d171a780a 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -20,8 +20,8 @@ need to enable if you would like to preserve their respective state across
 kexec.
 
 To use KHO, please boot the kernel with the ``kho=on`` command line
-parameter. You may use ``kho_scratch`` parameter to define size of the
-boot memory regions. For example ``kho_scratch=16M,512M,256M`` will reserve a
+parameter. You may use ``kho_bootmem`` parameter to define size of the
+boot memory regions. For example ``kho_bootmem=16M,512M,256M`` will reserve a
 16 MiB low memory bootmem area, a 512 MiB global bootmem region, and 256 MiB
 per NUMA node bootmem regions on boot.
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index fe4b76ff5a2c..7018e25e4eda 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -671,12 +671,12 @@ unsigned int kho_bootmem_cnt;
  * The bootmem areas are scaled by default as percent of memory allocated from
  * memblock. A user can override the scale with command line parameter:
  *
- * kho_scratch=N%
+ * kho_bootmem=N%
  *
  * It is also possible to explicitly define size for a lowmem, a global and
  * per-node bootmem areas:
  *
- * kho_scratch=l[KMG],n[KMG],m[KMG]
+ * kho_bootmem=l[KMG],n[KMG],m[KMG]
  *
  * The explicit size definition takes precedence over scale definition.
  */
@@ -751,7 +751,7 @@ static int __init kho_parse_bootmem_size(char *p)
 
 	return 0;
 }
-early_param("kho_scratch", kho_parse_bootmem_size);
+early_param("kho_bootmem", kho_parse_bootmem_size);
 
 static void __init bootmem_size_update(void)
 {
-- 
2.55.0.1082.g2b9226bbc0-goog

