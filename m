Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED54C1D4606;
	Tue, 22 Sep 2026 04:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050421; cv=none; b=ETneagJz1eXhdTpoveIOOQRrrgHNZ6smNvkIONluWFaRzvGFEy+vIweu7+yg91WRJ7DYZypPSEjg8jrDBAeOwqhR6NjQiqUOGTPxRX0z/Y2Nttr3XKk/1okKX+BiOT1j3frrvWS0h5/KCVVcg+V751UaOrFzryyHrDDpxTRT5Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050421; c=relaxed/simple;
	bh=OB4UmSRw0mSQ33AIr3nLsBuBq5YInvI32uewwW0vicQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=soX9HL4MES0/2YW3B1fExWCxQtkbUw3/NwbVMBCNeneyg30y2g4IqLC5Bm8ixiDX+PaRJXPp8ZLlgcyyarB5oY+m/oHe3WjDCB/wFm/zcNXeTsFWGuAfyzvAEVC6n9Z4d7LYci1rj79xmTUmzkDa4qJtwYp4XQaDRyegaQWs+sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UIKqt4PE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIKqt4PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A081F000FF;
	Tue, 22 Sep 2026 04:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050418;
	bh=JtaSAfNZWJ/23JZX4TX1si8kmJS1+YCVEwp8EWMG/RM=;
	h=From:To:Cc:Subject:Date;
	b=UIKqt4PEYrcADAfd+X2Wgtg6yh6AcL9MgOaTuTIKnSsq4LFg5XqQR2zHe9a/ZbAZv
	 m+enA1NTkG0SjCXRCFXP0rEzr26MhL5V9/DlyS0N9M+dbPcNkfjfbI6qxWLrV3AGcQ
	 F3m14qPPRKSTGOHRe1Wc348dK9bu5BEQLL4QGi7fNaC0EKz/MHjyOpaPM+j4PY7CD9
	 dEZsxjewEOy7CriZpl8V2yde9l7wtfE+/It8Xuw7X2Fq7zl34avEJRhdc/imcFaBc7
	 zT0GYqf/8DrAL++a16JNCp3QcZJ1dBhofzrgoQP5HvM3CLTXkUKuncZvjrzY4x/kWh
	 BaKemxUoYJoOQ==
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
Subject: [PATCH v3 0/4] kho: rename "scratch" to "bootmem"
Date: Tue, 22 Sep 2026 06:13:12 +0200
Message-ID: <20260922041321.233986-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The term "KHO scratch" is vague and overloaded. It does not accurately
describe what the memory is for. This was discussed previously at [0].
The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
is memory passed by the previous kernel for early boot allocations.

In addition, memblock does not care about the provenance of the memory.
It cares more about how it should use it. Use MEMBLOCK_KHO_NOPRSRV,
instead of MEMBLOCK_KHO_SCRATCH, to describe this memory to memblock.

This series does the renames. It also gets rid of a redundant Kconfig.

While the diffstat is big and scary, most of the changes are mechanical.
The most interesting functional change is in patch 4.

This series touches a lot of files across a lot of trees. But since all
of that is purely KHO-related code, I would like to collect ACKs from
the maintainers and take it via the liveupdate tree.

Ideally we should queue it in liveupdate/next early in the v7.4 cycle
since it will cause a lot of conflicts with other patches throughout the
KHO tree.

[0] https://lore.kernel.org/kexec/agHGOxSnP_VraH1M@kernel.org/T/#u

Changes in v3:
- Fixup some typos and update some leftover comments still referring to
  "scratch".
- Update early_init_dt_check_kho() to use bootmem instead of scratch.

Changes in v2:
- Rebase on latest liveupdate/next.

Pratyush Yadav (Google) (4):
  memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
  memblock: rename KHO_SCRATCH to KHO_NOPRSRV
  kho: rename KHO scratch to KHO bootmem
  kho: rename kho_scratch= commandline parameter to kho_bootmem=

 .../admin-guide/kernel-parameters.txt         |  15 +-
 Documentation/admin-guide/mm/kho.rst          |  18 +-
 Documentation/core-api/kho/index.rst          |  36 +-
 arch/x86/boot/compressed/kaslr.c              |  12 +-
 arch/x86/include/uapi/asm/setup_data.h        |   4 +-
 arch/x86/kernel/e820.c                        |  11 +-
 arch/x86/kernel/kexec-bzimage64.c             |   6 +-
 arch/x86/kernel/setup.c                       |   2 +-
 arch/x86/realmode/init.c                      |   2 +-
 drivers/firmware/efi/efi-init.c               |   6 +-
 drivers/of/fdt.c                              |   8 +-
 drivers/of/kexec.c                            |  16 +-
 include/asm-generic/kexec_handover.h          |   2 +-
 include/linux/kexec.h                         |   2 +-
 include/linux/kexec_handover.h                |  16 +-
 include/linux/memblock.h                      |  30 +-
 kernel/kexec_file.c                           |   4 +-
 kernel/liveupdate/Kconfig                     |   1 -
 kernel/liveupdate/kexec_handover.c            | 340 +++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c    |  24 +-
 kernel/liveupdate/kexec_handover_internal.h   |   4 +-
 mm/Kconfig                                    |   4 -
 mm/memblock.c                                 |  56 +--
 mm/memfd_luo.c                                |   3 +-
 mm/mm_init.c                                  |   6 +-
 tools/testing/memblock/internal.h             |   2 +-
 26 files changed, 313 insertions(+), 317 deletions(-)


base-commit: db3db4c33a1cf89a201ad1a11c63f503b248ee32
-- 
2.55.0.1082.g2b9226bbc0-goog

