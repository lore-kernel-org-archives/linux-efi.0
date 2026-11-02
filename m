Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654968;
	b=qkPJuu12tRwTdeDdSU2Ypl76OBb1yJ2rZuZw15Aj8BhfEcIJ8ugUpNC822qTxRKlAHdE
	 m+T4JxXHlNC+Pvdz8XMnR0Lile+cz/RvSENE0Dyn8hl8ZwK8YUMi3NfSomm5iqXaz+0Ki
	 sqdQLLYyVLu5TN1Qy8B2tz3zN0pgVFzmNCj+ytiR+ld4b0WizqhEpedqc8w52dJl7u/Mj
	 wMMVmAfPZyCoxQw+ZFnVzE6IjnE18cuQ7waMvxmaWUegmEhh/qfNgHOZXjh4JLkaSSc1R
	 GVeBcSKqCn9EORYMiF0g70E5iLyWTtHHrWCFys1TFgsZckufu/JzhwPQXzs70mZYfDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654968;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=qFT2XeSwYx9hrN0i8s2xEk6TKZbqJcQTgtM54iYW3Ho=;
	b=USZywJFeQ2TfMCvoRBcXBUJ7uwu5gytFEyyGYHkZLuN/8666NmNwLBdV5zFzu1AosVtc
	 6jh3ES7059AP4uEi8kplpsY8MwmaOVpz7UfUC8eg2gvTH6Q0uquqASD7nVKD7LKywlrV3
	 zvs2udbos8W5U+Ys3XOtd9vekv0jp6T0F1d5aWjEFEAgmnBfqNZ4FMNKwhCUPhcnKlYYL
	 /scVvRrvBZ4zPAFvYLL2fDrg/LIKitJc68gBH5DnVnRjUCYRxA2z/ZtBUHpdBW1xO9L6a
	 uS3APB2yPyyIrb5qe8snoxmIdfybkyI8YXGEQLPr5bNt+GxUcNOFyWNns9fAVjrfg6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Z/h+94Sw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F344606A326;
	Mon,  2 Nov 2026 21:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z/h+94Sw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F741F00A16;
	Mon,  2 Nov 2026 21:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654967;
	bh=qFT2XeSwYx9hrN0i8s2xEk6TKZbqJcQTgtM54iYW3Ho=;
	h=From:Subject:Date:To:Cc;
	b=Z/h+94SwmuQSmUW4/4X6eq64jbplg61HHOM808ta80L5Gfj9IVCAkbDGMAUh+K+zG
	 TClWb/OBolyDwfKF4J3mDL25yAeb87ydhVw8x36xSy0UvrV7MsXjKUrp1tdpaSK/yU
	 QLley950OxJjhGNFRP5mXW2oTkZDfeqUS8hAjjQeYZw7cDV5u7Y+2EZ9TdAcytnE9o
	 z4OAkA8j+2BpUucO6MvfQUPmjD3xfdljJ5aa8iFYcUhk/d/42sMkahdYofwyQt0lOq
	 EKpF4fOjG8oYnmdyS5eu0dstUbANuk5buh5WvTNZ1ofcyu6vU0/PZkflN9E3Y7pcpR
	 bE2AF4/5fT9Lg==
From: Vincent Mailhol <mailhol@kernel.org>
Subject: [PATCH v3 0/7] init: discoverable root partitions
Date: Mon, 02 Nov 2026 22:29:07 +0100
Message-Id: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4XQTY7CMAwF4KtUWU8gCT8FVtwDIeQkbrGmbcAJE
 QhxdwIIpNkMy2fpfbZ8FRGZMIpVdRWMmSKFoYTJTyXcHoYWJfmShVFmruZaS0/RhYwMtkPJIaT
 dAThRKr0orQdnwcOsVl4U4sDY0PnJb7Yl7ymmwJfntqwf0zc8+x/OWio5Wbp60YCbGjTrX+QBu
 1HgVjzkbD6aVuabZorW2Lr2amF0A/aPdnsdzng8lXek1/XCQkTpQt9TWlWBqaVh3ENMyKVxuwO
 JRlIsSAEAAA==
X-Change-ID: 20260611-discoverable-root_partitions-bdacbada570d
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Dave Hansen <dave.hansen@intel.com>, 
 James Bottomley <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>, 
 Vincent Mailhol <mailhol@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7661; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=K8LJHo3rdLUBlco52+wsTE/oWRN+ReMKQHJDV8eLi+0=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkvGdYYHn6/8sUkudjS4uD/md9+fviU4RSruTOvbsuSa
 xx/Fy/06JjIwiDGxWAppsiyrJyTW6Gj0Dvs0F9LmDmsTCBDpEUaGICAhYEvNzGv1EjHSM9U21DP
 EMjQMWLg4hSAqd6jzvCHa9a/SBFF9nN2Tw3TL76penlcTYNlbfS91V1rZss+t3mcxsgwicGyv7R
 kxgmVaRxWk41TJ9wue3Tjz/sYZ81lEyyXJ9xiBQA=
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] defines GPT partition type UUIDs for OS partitions and
attributes that control whether such partitions should be
automatically discovered. The specification states that:

  The OS can discover and mount the necessary file systems with a
  non-existent or incomplete /etc/fstab file and without the root=
  kernel command line option.

DPS is already implemented in systemd-gpt-auto-generator [2], which,
when embedded in an initrd, indeed allows automatic detection of the
root filesystem through its partition type UUID.

This series adds root discovery directly into the kernel so that people
who are not using an initrd can still benefit from it.

The scope is deliberately limited to block devices that the kernel can
already mount through the root= parameter. Other DPS features, such as
setting up LUKS-encrypted partitions, mounting partitions other than
root or container setup, remain userspace responsibilities, with no
future plan to implement them in the kernel. The intended usage is
thus a hybrid approach in which the kernel DPS only mounts the root
partition and leaves the remaining setup to userspace (either with DPS
or with a classic fstab), just as it does today when root= specifies
the root device.

The benefit is being able to boot a kernel with no accompanying
bootloader configuration: no root= parameter and no initramfs. The root
partition is identified from the existing on-disk metadata instead.

This is useful for booting a kernel manually, for example from the edk2
file browser, or recovering from a lost or corrupted bootloader
configuration without having to supply the correct root= argument or
load an initrd from the bootloader shell. Finally, it allows systems
that otherwise need no initrd to discover their root partition through
DPS without introducing an early userspace environment solely for that
lookup.

The implementation follows these rules:

  - GPT partition type UUIDs are used for automatic discovery policy
    only. No root=PARTTYPEUUID=xxx cmdline option or similar syntax is
    added.

  - An initramfs providing an early userspace init, a root= command-line
    option, or a root device supplied by the boot loader takes
    precedence. Existing working boot configurations therefore retain
    their current behaviour. Automatic discovery triggers only when
    booting without any of these, where the kernel would otherwise panic
    because no root device was specified.

  - As required by DPS, discovery is restricted to the disk containing
    the active EFI System Partition, identified through the
    LoaderDevicePartUUID EFI variable. This avoids inadvertently
    selecting a root partition on another disk, assuming partition UUIDs
    are unique. This is not a security feature: an attacker could
    duplicate the ESP's PARTUUID on another disk, just as with
    root=PARTUUID=xxx today.

  - If several eligible partitions have the selected type, the first
    match in block-device enumeration order is used.

  - The native architecture's root partition type takes precedence.
    Where the kernel supports compatible 32-bit userspace, its root
    partition type is accepted as a fallback.

  - Partitions carrying the DPS no-auto attribute are excluded.

  - The DPS read-only attribute is intentionally not enforced. The
    kernel already mounts the root filesystem read-only by default and
    if the command line requests rw, it takes precedence over the DPS
    attribute. User space remains responsible for deciding whether a
    discovered root should later be remounted read-write based on DPS
    metadata and local policy.

Patch 1 retains GPT partition type UUIDs in partition metadata for early
block lookup.

Patch 2 defines the architecture-specific DPS root partition type UUIDs
and the derived DPS_ROOT_AUTO_DISCOVERY symbol in Kconfig.

Patch 3 factors out lookup_root_device() so initial root lookup and
rootwait retries share the same lookup policy.

Patch 4 implements DPS root discovery through early_lookup_dps_root()
and integrates it into the root mount path.

Patch 5 excludes partitions marked no-auto.

Patch 6 adds the compatible 32-bit root partition type UUID as a
fallback when no partition with the native type UUID can be found.

Finally, patch 7 documents automatic root discovery.

Tested with the Linux EFI stub [3] and with GRUB [4], which both expose
the LoaderDevicePartUUID EFI variable.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

[2] systemd-gpt-auto-generator
Link: https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html

[3] commit 0f7d63d9a725 ("efi/libstub: add initial Boot Loader Interface
    support")
Link: https://git.kernel.org/torvalds/c/0f7d63d9a725

[4] GRUB -- §16.20 bli
Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
Changes in v3:

  - Rebase on v7.4-rc1.

  - Clarify in the cover letter that ESP UUID matching is not a security
    feature.

  - Move the DPS Kconfig symbols from init/Kconfig to block/Kconfig,
    alongside the root discovery implementation.

  - Restrict the LoongArch root partition type UUID to 64-bit kernels,
    since DPS does not define a root partition type UUID for LoongArch32.

  - Reject LoaderDevicePartUUID if it contains trailing characters.

  - Document when automatic discovery stops waiting.

Link to v2: https://patch.msgid.link/20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org

Changes in v2:

  - Remove all architectures which do not have CONFIG_EFI.

  - Replace the per-architecture UUID headers with Kconfig definitions.

  - Move most of the DPS lookup logic to block/early-lookup.c.

  - Bail out if ROOT_DEV already exists.

  - Hold the disk's open_mutex during lookup so partition scanning
    finishes before reporting -ENODEV. This is a prerequisite for the
    next two changes.

  - Do an early abort when early_lookup_dps_root() returns -ENODEV.

  - Add the secondary partition type UUID as a fallback.

  - Small tweaks in log messages.

  - Documentation is updated accordingly.

Link to v1: https://lore.kernel.org/r/20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org

---
Vincent Mailhol (7):
      block: store GPT partition type UUID
      block: add DPS root partition type UUID definitions
      init: factor out root device lookup into lookup_root_device()
      block: discover root by DPS partition type UUID
      block: skip partitions with DPS no-auto GPT attribute
      block: add secondary DPS root partition type UUID
      docs: document discoverable root partitions

 Documentation/admin-guide/discoverable-root.rst |  46 +++++++++
 Documentation/admin-guide/index.rst             |   1 +
 Documentation/admin-guide/kernel-parameters.txt |   5 +
 block/Kconfig                                   |  21 ++++
 block/early-lookup.c                            | 121 +++++++++++++++++++++++-
 block/partitions/efi.c                          |   2 +
 include/linux/blkdev.h                          |  15 +++
 init/do_mounts.c                                |  44 +++++++--
 8 files changed, 242 insertions(+), 13 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260611-discoverable-root_partitions-bdacbada570d

Best regards,
--  
Vincent Mailhol <mailhol@kernel.org>

