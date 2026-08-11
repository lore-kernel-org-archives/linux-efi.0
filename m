Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647733C943F;
	Tue, 11 Aug 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465620; cv=none; b=mWT6KdC9C3e/5chDsJgEXoB+RzzcshRbOAE2TggtV7D7BB2QFpqFFdm+HQ4harmOvRrz3KzmjC/3V6DQUF3WTzJ8aUfEuIvy1EQ8ngaS3d7krx/EvwYquvLavB3RLtjvyXqDMxgYmJVGK+Lh2xYWykfh9Hf74cIqfkawjyJkziY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465620; c=relaxed/simple;
	bh=I6d+eizEjlogofcYFWbdr4115/9b0npktQTk2UE5jRM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BMxR2KiXbxl5yNL1dEr18I8PlLHNQzY6R4ggL/480DgFpXLMDKoCz2H/+WCxYxzxa7SykvpyiRfA81krpRZ0NHMXmzwNqzIcWOfGkT2mOWxRbau64nWJIB9puo746RB168gnG72tHEv8BsNNESYH4bTI5uOvTs5cFkwWCpDl/nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kc0kfLnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kc0kfLnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A986B1F000E9;
	Tue, 11 Aug 2026 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465615;
	bh=OGvQP4rTfDtqzEoXAJvcK2bQDBmijHAZnmypqO/G+ig=;
	h=From:To:Cc:Subject:Date;
	b=Kc0kfLnPcphAgE8pEpNIHiPSnSgqFFYu15OAJQ7689fKkqv0uf1xN82X5BlruxAb1
	 +QVheRnjiKkms31uMeLjbXRXjCDUv1b9wMj7Jc4/37XsdoPzk0PpeWcKnzFsCskDad
	 3M5L/b1LIofah7chZsD+zQsUXHu1kuet+PjZNkK9Me6xjUHa2eJdBQqflG1+XMsM3j
	 XE5e/yHWpgYWKrwLBhPnIIRraVzU2xdL8C8PKw9C6Ij+qaXpn2jUUQZJeIczgziF9s
	 ElLR4CbM64NIqFwOnGyZ/9M+nVw8Iv9jKkhYqH0wffo9OJu96GCbogJE95ESCBYFOT
	 vJQeGUOX5+yVA==
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
Subject: [PATCH 0/4] kho: rename "scratch" to "bootmem"
Date: Tue, 11 Aug 2026 18:26:36 +0200
Message-ID: <20260811162642.3504565-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
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
 arch/x86/kernel/e820.c                        |   2 +-
 arch/x86/kernel/kexec-bzimage64.c             |   6 +-
 arch/x86/kernel/setup.c                       |   2 +-
 arch/x86/realmode/init.c                      |   2 +-
 drivers/firmware/efi/efi-init.c               |   6 +-
 drivers/of/kexec.c                            |  16 +-
 include/asm-generic/kexec_handover.h          |   2 +-
 include/linux/kexec.h                         |   2 +-
 include/linux/kexec_handover.h                |  16 +-
 include/linux/memblock.h                      |  30 +-
 kernel/liveupdate/Kconfig                     |   1 -
 kernel/liveupdate/kexec_handover.c            | 340 +++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c    |  24 +-
 kernel/liveupdate/kexec_handover_internal.h   |   4 +-
 mm/Kconfig                                    |   4 -
 mm/memblock.c                                 |  56 +--
 mm/mm_init.c                                  |   6 +-
 tools/testing/memblock/internal.h             |   2 +-
 23 files changed, 302 insertions(+), 304 deletions(-)


base-commit: 352ebb57013a08679788bc18c7f9af90903db256
-- 
2.55.0.679.g6767b8d81c-goog

