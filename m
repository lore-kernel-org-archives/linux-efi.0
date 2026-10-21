Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792603875;
	b=1pnN5eDHY6M1T/NXMnxyG2KD4L1qgl0Iwlwjekpji9tUCtsLLoQg6N6mqJGGQP7iEgiS
	 hiD3fEln6M5Kf7RbtLLezPYh6epLZSlsVW2H4iVSho/xyV5V5er3A1Tfr3rPWInOFWbcR
	 KBt6uUKZ7LHdA9oH8nWxO/baa48wuvO1Ygvs/ujxzOrwRAnc0Uk2zYKFbuR1Cfxtl1Eyy
	 KkHK3zHzSwoX48bDpgDY1K0d1zgmwkhW42FdPWUyU8LL3UUo4ZqmotAoVZxv6aQvPRBKj
	 MST8w0bakQePQfgX1K+oW/gOdE1XN+Byl6Fg8iwo8mACo7uG1NuXz7/Gts9JzVZNScQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792603875;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=GInLZ/fwliCPPImJbIwVbQGL2vPVxjMZX8QgFpCl/rc=;
	b=1X3odu/UQWCmddGZXdaNS1/j9cStwEdofPFFaOlnjQ/V1GVgE6jquXPCFImlm33ntmO2
	 Iz1pbehfSFjNcEdX8iAao+9qquiBcFlzRsEPwVOdOYGcvg/ix7QaRpTwngtrgWf852wOr
	 yFFC+soUrEH7trV9Og5Z2LNTKy5j6WKIVX6aOSwV9nOIsFJTcmNiVej6jlumQK9wKI1jC
	 wnS6Z66+S3TQitR/OjNZsC6TJ7QCDZuuStJSFlq9t/50/MwHGsFwk0qlaOEqaYfNkhlJ6
	 L1T7CA4RAf2r7ER6pahhZYXzi0cW8aiKe8nns6pzviv9z8CwqsdvtabTmUaMiVTtncA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=VbuZZA+I;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED7D606A332
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:31:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8ED7D606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=VbuZZA+I
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b3dc91781fso1502127a12.0
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 10:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792603873; x=1793208673; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GInLZ/fwliCPPImJbIwVbQGL2vPVxjMZX8QgFpCl/rc=;
        b=VbuZZA+IdRhFLxPBsXpQAtjNIv0/QZ87gGGzkHOomYtBUuHe+vvtMKE0+eVl7wz/JI
         1RE3Q1pydCKZ9RamQl8BrOhUNLDXYgD5qTMbv0VIIE54ApFwh6JMSAOvR6dcwqxggEbO
         7ABzL2dfhK/Y0X68WWla8Cd/iiy04wB8xQj/LO8o39WU9D/vBCYjmIO2yzAQjb5c+JCG
         O4JPJjVDFgTG8wCSqH2lGF8B6LBr9mv0RFa+N6J1Zucqicx8VZ5+N/s+s9+Z8AR0Y9JM
         1hnbNJDxVA08KcE0H7OOdOi2/3knMcgGGT/KH76oeqOASvNPBp/pLSw84TB0rTiuvI1D
         Y4Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792603873; x=1793208673;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GInLZ/fwliCPPImJbIwVbQGL2vPVxjMZX8QgFpCl/rc=;
        b=fYTIuFz3fBKTYkZmaf2J3WECFKb/IzBMs/rja/ER1G+UzkjgkBXelJ4jshZL7PZZUA
         tjFiJiBmstM06yR4lECS/Mae0tAHjqUiBI/eTTI0W9JT1bo0eOVHaI8zyKMNSPfzULir
         CDqZjjaX+74AWku9ZIt7EdLdRs5Tm6OdEGB9A5YpytwHLXB4GrxbYSDR/pRmz0G25Vpt
         RpltKuAOvh00lVPyrgIRO8AbHMyb0ez3XkQ/9mlG1b8z6jfrn3hrQr9GInDyXKjT8QbJ
         W2vay9+MTa/qnZ2l81Bg9DBdYxM3OAulN1CPDLrpymOPtC87agfg0sJ+8/7SxmeRllBs
         yXhg==
X-Gm-Message-State: AFq9FYJDQKw8dSf2fdvl7VmYeT2OfiFzbIbV6kH6u1+jLPIN9IhkcvHB
	K5N1lDwLRkamcTDAep/wvD7fF4TNfXF0rqIaKUYT+A85QoXAHloaLuwvFPC10Scs2zohol5oxw=
	=
X-Received: from edzg22.prod.google.com ([2002:a05:6402:916:b0:6af:1257:9f75])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:e04:b0:6b3:c370:a7
 with SMTP id 4fb4d7f45d1cf-6b408ef01eamr1903129a12.40.1792603872718; Wed, 21
 Oct 2026 10:31:12 -0700 (PDT)
Date: Wed, 21 Oct 2026 19:31:10 +0200
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261021173109.2402130-2-ardb+git@google.com>
Subject: [GIT PULL] EFI updates for v7.4
From: Ard Biesheuvel <ardb+git@google.com>
To: torvalds@linux-foundation.org
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Hello Linus,

Please pull the EFI updates below. Details are in the tag.

Note that the 'prerequisite work on the x86 decompressor' mentioned in the tag
is already in your tree via tip's x86/boot pull request, hence the stable tag
used as a base.


The following changes since commit c4b94e70365432a08ea1fe2135d2e3a1f3f4ec05:

  Merge tag 'tip_x86_boot_immutable_for_Ard' into HEAD (2026-10-04 10:30:19 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next-for-v7.4

for you to fetch changes up to 2c493ac8c347167eec9e4e985d2b58d5fa6fd420:

  lkdtm: Add more EFI runtime tests (2026-10-18 10:28:29 +0200)

----------------------------------------------------------------
EFI updates for v7.4

- Set the LoaderDevicePartUUID EFI variable from the stub to help
  systemd discover the file system layout when booting straight into
  Linux without GRUB or systemd-boot (Vincent Mailhol)

- Some GUID deduplication work from Vincent

- Remove pointless UTF16->UTF8 and vice versa conversions from the stub,
  including some prerequisite work on the x86 decompressor to
  accommodate that

- Some kmap() -> kmap_local_page() conversions in the capsule loader

- Add a runtime control to en/disable EFI runtime services so that
  PREEMPT_RT systems can enable them as needed

- Add a 'nostatfs' mount option to efivarfs so that the cost of querying
  the EFI variable store (which is already rate limited) can be avoided
  entirely on systems where it is disproportionately costly

- Rework the EFI libstub Makefile to align x86 with other architectures,
  and inherit/adapt the global CFLAGS variable rather than reconstruct
  it from scratch

- Constify attributes of statically allocated sysfs nodes

- Avoid register x18 when building the arm64 EFI stub, in order to
  comply with the UEFI spec, and to permit it to execute in a context
  where x18 is special

- Preserve the physical addresses of all EFI config tables that may be
  of interest to an incoming kexec kernel

- Add some LKDTM tests for EFI runtime crashes where the faulting
  address is inside a EFI memory region

- Other minor bug fixes and cosmetic cleanups

----------------------------------------------------------------
Ard Biesheuvel (17):
      lib/ucs2_string: Drop arbitrary input size limit and associated WARN()
      lib/ucs2_string: Suppress modinfo when __DISABLE_EXPORTS is set
      lib/ucs2_string: Split out ucs2_as_utf8_l() taking a separate limit
      efi/libstub: Use ucs2_string library for UTF-16 to UTF-8 conversion
      efi/libstub: Avoid efi_puts() for compile time constant strings
      efi/libstub: Output UTF-16 directly from vsnprintf()
      efi/libstub: Add support for printing human readable GUIDs
      efi/libstub: Add efi_snprintf() to construct wide strings
      Merge branch 'bootloader-info' into next
      efi/libstub: arm64: Don't use the platform register x18
      efi: Constify sysfs attributes
      efi: Use sysfs_emit() not sprintf() to generate sysfs file contents
      efi/runtime-wrappers: Don't park the worker after a recovered firmware fault
      efi/libstub: Don't replace an existing LINUX_EFI_MEMRESERVE table
      efi: Retain the address of the LINUX_EFI_MEMRESERVE table
      efi: Initialize all configuration table addresses to EFI_INVALID_TABLE_ADDR
      lkdtm: Add more EFI runtime tests

Danish Khateeb (2):
      efi/capsule: Replace kmap_atomic() with kmap_local_page()
      efi/capsule-loader: Replace kmap() with kmap_local_page()

Hemanth Selam (1):
      firmware: efi: fix typo "existance" in comment

Jason Gunthorpe (3):
      efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exit_boot()
      efi/riscv: libstub: Don't set image_size in handle_kernel_image()
      efi/libstub: Free cmdline_ptr in efi_pe_entry

Junxiao Chang (1):
      efi: add dynamic control interface for EFI runtime services

Karl Mehltretter (1):
      efi/libstub: Fix efi_set_event_at() parameter documentation

Kees Cook (3):
      efi/libstub: Declare the x86 stub's assembly entry points
      efi/libstub: Build the x86 stub from KBUILD_CFLAGS
      efi/libstub: Disable kernel stack erasing in the common flags

Prashant Singh (1):
      efivarfs: add nostatfs mount option to skip QueryVariableInfo()

Thorsten Blum (3):
      efistub/x86: Use struct boot_e820_entry for size calculations
      efi/libstub: Simplify check_image_region()
      efi/libstub: Fix grammar in efi_kaslr_relocate_kernel() comment

Vincent Mailhol (4):
      efi/libstub: move direct GUID references to static storage
      efi/libstub: make local GUID variables static
      efi/libstub: factor shared static GUID variables
      efi/libstub: add initial Boot Loader Interface support

 Documentation/filesystems/efivarfs.rst           |  12 ++
 arch/x86/platform/efi/efi.c                      |  13 ++-
 drivers/firmware/efi/capsule-loader.c            |   6 +-
 drivers/firmware/efi/capsule.c                   |   4 +-
 drivers/firmware/efi/efi.c                       |  93 +++++++++------
 drivers/firmware/efi/libstub/Makefile            |  44 +++----
 drivers/firmware/efi/libstub/bli.c               |  86 ++++++++++++++
 drivers/firmware/efi/libstub/efi-stub-entry.c    |   4 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c   | 108 +++++++----------
 drivers/firmware/efi/libstub/efi-stub.c          |  11 +-
 drivers/firmware/efi/libstub/efistub.h           |  12 +-
 drivers/firmware/efi/libstub/fdt.c               |   6 +-
 drivers/firmware/efi/libstub/file.c              |   8 +-
 drivers/firmware/efi/libstub/gop.c               |  23 ++--
 drivers/firmware/efi/libstub/kaslr.c             |  19 ++-
 drivers/firmware/efi/libstub/mem.c               |   2 +-
 drivers/firmware/efi/libstub/pci.c               |   2 +-
 drivers/firmware/efi/libstub/printk.c            |  95 ++-------------
 drivers/firmware/efi/libstub/random.c            |   8 +-
 drivers/firmware/efi/libstub/riscv-stub.c        |   7 +-
 drivers/firmware/efi/libstub/riscv.c             |   2 +-
 drivers/firmware/efi/libstub/smbios.c            |   3 +-
 drivers/firmware/efi/libstub/tpm.c               |   8 +-
 drivers/firmware/efi/libstub/unaccepted_memory.c |   2 +-
 drivers/firmware/efi/libstub/vsprintf.c          | 140 ++++++++---------------
 drivers/firmware/efi/libstub/x86-stub.c          |  20 ++--
 drivers/firmware/efi/libstub/x86-stub.h          |  16 +++
 drivers/firmware/efi/libstub/zboot.c             |   3 +-
 drivers/firmware/efi/runtime-wrappers.c          |  99 +++++++++++++++-
 drivers/misc/lkdtm/bugs.c                        |  33 ++++++
 fs/efivarfs/internal.h                           |   1 +
 fs/efivarfs/super.c                              |  36 +++++-
 include/linux/efi.h                              |  37 +++++-
 include/linux/ucs2_string.h                      |  11 +-
 lib/ucs2_string.c                                |  23 ++--
 35 files changed, 610 insertions(+), 387 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/bli.c
