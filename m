Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2592C27FD4F
	for <linux-efi@vger.kernel.org>; Sun, 23 Aug 2026 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787492649; cv=none; b=vDD64lTYH9EEk7aKVkeljiX//AWRUj0NL7bfsRgFxXHK25nf6kIgu3aExJrGOPdFXJDzZInWh/gy3M+3fWkK0/8cKKUUY2/Ig3/5FdzTehNmgDmH3bHH2ZWbFODdSQGP/hA7mNUHiYrx/JfbeW87VgQk/A2GfCOppCqk0gDtdCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787492649; c=relaxed/simple;
	bh=6nR/gsvYPYbDhm7+qDj3Bld6e5aGXNZRFUhyJvVt6m0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OXJetBSrWMb3AMqT7zSOKYZ8MqZCWcmKGlFGBrfRgFAFJdAsDCCBQjti9mojrFFvl16OQZhM+5C7yJXkOmj2bPnJVXzTvoc1SJXIPur1abk15IVvBajtdKw2c8Z/3BgTovq1vC7zAqUnWFOCSkn5GlN8oX5LMsNoS3Hl3uMZkAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1Oze/qt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1Oze/qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02EE1F000E9;
	Sun, 23 Aug 2026 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787492647;
	bh=6rMdBWj5ZNzMQKXICltRamavoReu+lMF//cbIH5zqfg=;
	h=From:To:Cc:Subject:Date;
	b=n1Oze/qtAMQj8UqalJTjWsjlqg85xBy2+DfRhzywHSnQjiakq5Fej+eCLvkagMFVq
	 KVLY5txPYPF7w3m8iLQX7zzRxt7YNzYHR2/Ftd46JRL12nAbyMSVix3F/J/7uKYB3g
	 +6xE3QM8/JUwArBFno9T1uTtPwNpQmISGYKgIgE1DpOgMp+RrJDst5nQyVygekRPmx
	 Yq52qbsUUW2r2qbYDM0XzgPHKCKJcargN5iXWUVSVaSrvpQ7TSOoe5rGDmeSEnaiTB
	 6s7rdYqSeQJ7QQAwRD4/Ef2rBgpC9lt5lpifeePi8sMNVlPyWBCrGvwTHaTB1DTOE9
	 zRyjBpKOKedCQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-efi@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [GIT PULL] EFI updates for v7.3
Date: Sun, 23 Aug 2026 15:43:49 +0200
Message-ID: <20260823134348.2868-2-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2235; i=ardb@kernel.org; h=from:subject; bh=6nR/gsvYPYbDhm7+qDj3Bld6e5aGXNZRFUhyJvVt6m0=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIavrp2igQ/TvrjbuFzfPSC9Q9H609H/ejdZp06ziJ2ky3 Pp/XYO1o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzE4R3DX0EOVsl1cyuPfLw7 VXjb+UunXXmL25ZPmr+iTqjm+tIAjg8Mf8WrrsydcmDl5DgubiuXEx+aZG3tI301Vq0t5Vm7ZJL YASYA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Hello Linus,

Please pull these EFI updates for v7.3, details are in the tag.


The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v7.3

for you to fetch changes up to b2326338dc683e8c1067c0cbf7a47986c4190902:

  efivarfs: Rate limit statfs() handler (2026-08-20 14:49:39 +0300)

----------------------------------------------------------------
EFI updates for v7.3

- Set a timeout for EFI runtime service completions, and declare the
  firmware wedged if it is exceeded. Note that this requires special
  handling in case the firmware does return after all.

- Rate limit the efivarfs statfs() handler as the QueryVariableInfo()
  runtime service can be costly

- Sanity check the size of struct properties_header on Mac/x86

- Tweak the prototype of efi_guid_to_str()

----------------------------------------------------------------
Ard Biesheuvel (1):
      efivarfs: Rate limit statfs() handler

Breno Leitao (7):
      efi: fix stale reference to efi_recover_from_page_fault()
      efi/runtime-wrappers: factor out efi_rts_park_worker()
      efi/runtime-wrappers: handle queue_work() failure with goto exit
      efi/runtime-wrappers: check EFI_RUNTIME_SERVICES before using efi_rts_work
      efi/runtime-wrappers: bound the wait for EFI runtime service calls
      efi/runtime-wrappers: honour EFI_RUNTIME_SERVICES in the non-blocking paths
      efi/runtime-wrappers: retire the worker if a wedged call ever returns

Pengpeng Hou (1):
      efi: apple-properties: validate setup data header length

Vincent Mailhol (1):
      efi: make efi_guid_to_str() take a const GUID pointer

 arch/x86/platform/efi/quirks.c          |  9 +----
 drivers/firmware/efi/apple-properties.c |  5 ++-
 drivers/firmware/efi/runtime-wrappers.c | 70 ++++++++++++++++++++++++++++-----
 fs/efivarfs/super.c                     | 30 +++++++++++---
 include/linux/efi.h                     |  8 ++--
 tools/objtool/noreturns.h               |  1 +
 6 files changed, 95 insertions(+), 28 deletions(-)
