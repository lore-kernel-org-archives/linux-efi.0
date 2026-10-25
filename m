Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933450;
	b=Omm9RO9dicZ8ZcgzcmjHKUElN3XJSDPwdoBCbP7LKgzYXDIf96JPLvVn4cWaUL1soJcv
	 ta6S/lw39ETFRJjePNdBSgSHKuulNBirCgy0X8LVB+OF90Ws2oqaNLupURZmSGY1TAgZ8
	 /3XuvTSaTTvHXuTL235FPLokOTNHMRzd6gMy2AroeLYuokeLNPeKex01JUVTNw8OE1v8O
	 5iXPUfIko2f0ukARsZNOLEvGQN9VG2xbyvzoa0I8SBRK0bGO1a4nYgW4M1tD8qtgAvSqY
	 IIxBRL6B1bz5Vx0/ZpIrNan+0mq3aMlM7yeBIPrHuDPKn2DrKk1pDkGqK8d5A8vAY3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933450;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=q3oKuRfytJnnU3NQYKbKaM1o1JrAm6kqNNM7F90ig2U=;
	b=WWfVU1KoeBlS3d/bzNjZdT8+xtWhjE+uRINMSj0GH4iOpZ6idN8mVruOYGZPweLCqydC
	 yL7f50QQozGa8O+PLdktv/DrFEEnbAjmkczB+/B9oafgEWdsBxXClYyOX1V/RuRfe1uYa
	 so7jDU3r0GTjeaH1TtvQpDPmMdBl3gkZdJ4KfwuPY3MRkyPgukAydu+VG/FAV+zRToTse
	 zLxmFQqEKYEiaBUxGPU7MM5wnEWmY0TMj7VDKKa3pXv6dDK2O6RHlrne0+zL0F9xRssG2
	 DovtObbugpXn/ngBPzCYESe+OS4KlstMyKjVZhyBNYMSnwrN6ZK4mK7KNo8HkWPXYKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UAAOW4zV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500C5606A31F;
	Sun, 25 Oct 2026 13:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UAAOW4zV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A341F031E0;
	Sun, 25 Oct 2026 13:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792933449;
	bh=q3oKuRfytJnnU3NQYKbKaM1o1JrAm6kqNNM7F90ig2U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UAAOW4zVjLa2+WAUiaaLQZN+GSppsTp6c6lDuMCdi45pFKjpUxVsBwP71NANWz0Hv
	 RKp6FTv5+TrIn7a7XJOoZGp1WyBf+VftZVs9Hner+GcJhF+DhcepHeLIO9IgQ6BXaU
	 KCX2Nsz6cHaExzo9imtGotkp4NjJHiQ5HiV9ZLZ7yC6Ft0uDME8a3zNbFZ0kM8UxhW
	 VhrUYeoVJ/tjGpABr2MIVmSjObvPflpv/7a718bYmthI82TFdgpuEIEhxgFbtgPxqM
	 oyrlym83oPN9Y4R9+npeFQ+2wncl8LL+m2QoNzEXPQT9tmBxpCA0voPA1dOOnfxWBO
	 xM/o4ywZiux9g==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Sun, 25 Oct 2026 14:03:12 +0100
Subject: [PATCH v2 2/7] init: add DPS root partition type UUID definitions
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261025-discoverable-root_partitions-v2-2-fb77d0821fab@kernel.org>
References: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
In-Reply-To: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Dave Hansen <dave.hansen@intel.com>, 
 James Bottomley <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1850; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=EZW4lcd+UB51X4rf76eXLHBWp7j8RnkoPttpORnLc0I=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFl3/9nobGLa/jWUhWUym1uVkumN94sNHfuWXP07/dPal
 zvVIj27OiayMIhxMViKKbIsK+fkVugo9A479NcSZg4rE8gQaZEGBiBgYeDLTcwrNdIx0jPVNtQz
 BDJ0jBi4OAVgqh99YWS4ejbelbNVMKU2Z84N86/r7DJO7/8abz7x4O8P92P6XRatY2ToYtW7KbL
 mFcuH2M7Cque7dpxy/+DzWK9ycdJV4d3WsW08AA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns a native root partition type UUID to each supported
architecture. Add a hidden DPS_ROOT_PARTITION_TYPE_UUID string symbol
and populate it from the architecture selected in Kconfig. Only
architectures with EFI support in the kernel are added.

Gate the symbol on EFI and EFI_PARTITION because discovery needs block
devices, EFI runtime services and GPT partition parsing.

Derive the hidden DPS_ROOT_AUTO_DISCOVERY boolean from whether
DPS_ROOT_PARTITION_TYPE_UUID is nonempty.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 init/Kconfig | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index b31aa298c4fe..133854355697 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2166,6 +2166,20 @@ config ARCH_HAS_PREPARE_SYNC_CORE_CMD
 config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	bool
 
+config DPS_ROOT_PARTITION_TYPE_UUID
+	depends on EFI && EFI_PARTITION
+	string
+	default "69dad710-2ce4-4e3c-b16c-21a1d49abed3" if ARM
+	default "b921b045-1df0-41c3-af44-4c6f280d3fae" if ARM64
+	default "77055800-792c-4f94-b39a-98c91b762bb6" if LOONGARCH
+	default "72ec70a6-cf74-40e6-bd49-4bda08e8f224" if RISCV && 64BIT
+	default "60d5a7fe-8e7d-435c-b714-3dd8162144e1" if RISCV
+	default "4f68bce3-e8cd-4db1-96e7-fbcaf984b709" if X86_64
+	default "44479540-f297-41b2-9af7-d131d5f0458a" if X86
+
+config DPS_ROOT_AUTO_DISCOVERY
+	def_bool DPS_ROOT_PARTITION_TYPE_UUID != ""
+
 # It may be useful for an architecture to override the definitions of the
 # SYSCALL_DEFINE() and __SYSCALL_DEFINEx() macros in <linux/syscalls.h>
 # and the COMPAT_ variants in <linux/compat.h>, in particular to use a

-- 
2.55.0

