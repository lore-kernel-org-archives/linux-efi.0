Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E723FDC06;
	Tue, 11 Aug 2026 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465643; cv=none; b=tuw4d/+UQDK79OOOWb3FEprtXsDdBTQeIWmauYtjgqnEqKhdcrPW8AgDmFnZK/CTGk5Y9QplYPsgZqdtj2R/oMt6g9Zi9oiYPMiGjbOq0x0A7a0Y1asLUjUaPLlvdHR+Aa4Cns9hJtPwaex8fFmfhISxexinMrdbI7KyYqyATM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465643; c=relaxed/simple;
	bh=Va0rHpjq4FzFwHNjUzLNbcVtqbDKOyHSiJ78v8rm5CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1LM1PUiBS5ZeuNWeer2PB/FodwP0sB6JOLm5GWXNSCCTs2Dl+qzbrFBHXMPobvBWdQwN/EXA+41xm671eGlcowi5JLUUdpTCJvU+5mowBVOm2WWzAt/Pujx+OCbT4YEzfyb2LBwb0ayjLaCrME8oqlIlV09QRU/ABTvjzPkxhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3hKLmyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3hKLmyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD631F000E9;
	Tue, 11 Aug 2026 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465637;
	bh=abxli+Hzhv9GVR5sItE1YFTra2NUUXXbp3pvRn5p7EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3hKLmyE9986h21u1I/RYnOIZZQXOwKmw5BknJic+XPSFq11Z0jpodg9LbbUjqcsR
	 8THgcVfT6zhyVwsyzYmZnBzOZyIp+7YNYIFjtnYwtNZ8jnTjFX6rO9nJbo4Ve/XX0E
	 vsrtZo+G8TdCC2Lu68eihAUSbYyTwKrXBEqHecknJ+dKLoyFUfYqeGbyJcC4k1ZmhK
	 hy88SyPClFgmp65Gsbp5TGsynaCq0AcUzDed1/fEyLth93t/k3+ip+/8LJO/YL+KZx
	 BrOBxNM9dluoM1mXwFfPGo2HQnxfToZ2WHB2TDklPUqt0riNb8HrROcTv4SfH2Cm3y
	 HAYOnlFhz6v7Q==
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
Subject: [PATCH 4/4] kho: rename kho_scratch= commandline parameter to kho_bootmem=
Date: Tue, 11 Aug 2026 18:26:40 +0200
Message-ID: <20260811162642.3504565-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <20260811162642.3504565-1-pratyush@kernel.org>
References: <20260811162642.3504565-1-pratyush@kernel.org>
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
index e2212f058812..a03927ffb85d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2989,7 +2989,7 @@ Kernel parameters
 			"0" | "off" | "n" - kexec handover is disabled
 			"1" | "on" | "y" - kexec handover is enabled
 
-	kho_scratch=	[KEXEC,EARLY]
+	kho_bootmem=	[KEXEC,EARLY]
 			Format: ll[KMG],mm[KMG],nn[KMG] | nn%
 
 			Defines the size of the KHO boot memory region. The
diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 4fae09096038..f14c8d9ad6a4 100644
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
index 3bfdbe86aaf9..da8d5ecb915b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -669,12 +669,12 @@ unsigned int kho_bootmem_cnt;
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
@@ -749,7 +749,7 @@ static int __init kho_parse_bootmem_size(char *p)
 
 	return 0;
 }
-early_param("kho_scratch", kho_parse_bootmem_size);
+early_param("kho_bootmem", kho_parse_bootmem_size);
 
 static void __init bootmem_size_update(void)
 {
-- 
2.55.0.679.g6767b8d81c-goog

