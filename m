Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541881;
	b=qU0oDaCf97m+VBNS95cYLz/Mf/A7I15MSWpRubMFU1k6dOQ9Bdkmiz1iz7SUGIiYEHMM
	 5dZs9U7eT/j6a010GvI6Ztt6JIUMPOty9xc26MGlri6SBB0TwEpubBlrx3do1NSFVoHzT
	 3lwPPvty8elMnJ7T3p9pMT1XFU89tGYBYs89mYzUwcoYCTkPZJyBdU0d25J1fpdTVUuxJ
	 zykZfEVJhd2VgcDOZ8JL89SF15OfLZhD3uTYr/WmyKlenfrxfbWD1Rek4Jw45BhCJiXvg
	 BjrCyEUXTXVBJKNSkbuuWPsxvOZFKoHqlzNTJXYqLb2/QC3R8Jtx5PIukKRXGMRHOXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541881;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=in5QSXBbL4pEqZ0Kr2iMG6wzdM692zy+VHOVYlble4U=;
	b=nMlpTXrRRZv3sbJua+Jb79igIL+2CEPJaKzEoY+xDKYU1dSHAWi+WiVnp7gEECLn8Vv3
	 jG61wiciRraZdeILO/eHMUgQmL31z3oaUQ8VStFKmun1Gm1QatDQc/8r71XnyX4CDvyNB
	 vfY5Rkb4CDjypLcGVvf469V3pnYSQ1UOi4T4t4FrcYvoZ/EH0lA0hIxbafsrlpxKEcOhH
	 uYufsRGDHN/rp8/W5nB4sRIicFWAcdQ/PAtxibt7dO1nXG6ocMNIHeyINkZayfzGihlNl
	 RavqzxbdXrF7EYws7ySuAQ7/p0VrGaJwqM+3JXaqc3PVpLYRoac32d7tdqQqZtN7Bog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eQzQWzP9;
	arc=none smtp.remote-ip=209.85.221.70
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F70606A31E
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 17:38:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0F70606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eQzQWzP9
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-49090fde23aso2954308f8f.2
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 09:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541879; x=1796146679; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=in5QSXBbL4pEqZ0Kr2iMG6wzdM692zy+VHOVYlble4U=;
        b=eQzQWzP9ipXyCoH4gizLiMMu9/ptqAvsqBFwmSYFSzLOT+CzqsWI3QkGiIVNCvNDLc
         dExZMkuinZqqYQMCqMrPiutIJSRQ+4X4wEGUWETF6CAHEnzMLSfvvD+LQbHVtD2rhu1u
         GTUXKwxZ0IhAo8/7TZWZHKuW2tRARygmebpwG+f0AhnJ++QT5y2S1OzK4d+cfK7TXJWw
         HpOZs24o7KuyVChZH+NeBcWtip6QjsuzXGk46z8hszLYe5YKYWi/UpXRDMAb6fHf+Sh9
         5x1v/sorokwtakiZPcCOGCltEh/PJstRv32CGXDPVRpbg826gX6zuBzm/8daVq62RKAf
         QXPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541879; x=1796146679;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=in5QSXBbL4pEqZ0Kr2iMG6wzdM692zy+VHOVYlble4U=;
        b=U5AoDO8s8dd6B8WjMbfuzhYq3Di1XRJO/I4nyvGfzaimSIlpX9TOJuoldbNRu/fo1n
         ydPdvYz892IhchcOY3rCj8Thw3tGCDStILo61Up0tdzGCaWLz15JKME0IecJuUJ1as8u
         L5PERgA1vEMMbIlXYnPpEXm7ekBPywctxDqN0kF9MYkaK/xJuwIbbNiVQEyfyu0KHejK
         qjagRhNmJaODzGKgfkr6c/woyfRz51YrxaxlLVzEPXeJgJin0CbGdP/drb0JgtZNgxA5
         oB6PnvfgtUUKG0WUe3o0twHVYFxYLbC+43cuv95zs/GquFJBs2i3EWNsiRhg7BANpgnB
         9g1A==
X-Gm-Message-State: APuU4Z9Y2lnSTz6tuFa2zu4YLl+H34/c3o/kH7GuOpl6vyNumodQyAj0
	kYNDtVFP2StxV0z64bmY9uhM7MiDWhkOTy+4yRAyukFwOaigHytGJ6o66K/pO8HZNBRKM9o01B4
	q/lrVpbVLRoLwriR60r6G3DrOJYnK8Ym0YGxpGgh56AEi0WZA8s0kJuj4LX3WqoXHwHyc8/dqsu
	49s5oKp7jrKBAjiygOjv45sZAWDTIy3g==
X-Received: from wrpa13.prod.google.com ([2002:adf:eecd:0:b0:4b7:8202:bd9a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:26cb:b0:4ac:f59:60de
 with SMTP id ffacd0b85a97d-4ac0f596109mr33157175f8f.18.1795541878633; Tue, 24
 Nov 2026 09:37:58 -0800 (PST)
Date: Tue, 24 Nov 2026 18:28:14 +0100
In-Reply-To: <20261124172811.2580784-7-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261124172811.2580784-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4920; i=ardb@kernel.org;
 h=from:subject; bh=Vor/w0R+T/rmFD63LRDfqwpYZd5GNA+/gAwGMuV+mso=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZv1pNE/F9fPmtvSF93SWLrj/mKJaKFrF9YbFe6tOrF14
 YRH/U8edpSyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJrHjM8N9pNdu0pY8XJ14S
 ynRK2mN2QM5fh3lbR2TI69iMl9y8v/kZ/qlFbo3zuPgtkifOgm3b3ISwm1Ozk1fqe/NMSTso9Lt MlhkA
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124172811.2580784-11-ardb+git@google.com>
Subject: [PATCH v2 4/5] efi: Tie 'efivars' pdev lifecycle to generic efivars
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=" <u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Currently, efisubsys_init() registers the "efivars" platform device,
which efi-pstore matches via MODULE_ALIAS("platform:efivars"), whenever
EFI_BOOT is set and GetVariable/GetNextVariableName are marked supported
in efi.runtime_supported_mask. The device is never unregistered.

That makes the device's existence unrelated to what efi-pstore actually
needs:

 - it is registered even when generic_ops_supported() returns false
   (leaving no efivars implementation registered) or when SetVariable()
   is unsupported;
 - it remains registered after tee_stmm_efi_probe() replaces the generic
   ops with the OP-TEE StandaloneMM implementation, which does not
   support non-blocking SetVariable() calls from the pstore dump path.

Other efivars implementations (Coreboot GSMI, Qualcomm UEFI Secure App)
should not be exposed to efi-pstore at all. qcuefi_set_variable() takes
a mutex and allocates memory, and efivar_set_variable_locked() falls
back to it from pstore_dump(), which runs with a raw spinlock held and
interrupts disabled. On GSMI systems, efi-pstore would also compete with
ramoops for pstore's single backend slot.

Instead, register the "efivars" platform device from
generic_ops_register() once efivars_register() has succeeded with
SetVariable() support, and unregister it from generic_ops_unregister()
before efivars_unregister(). Consumers are then always detached while
the ops they use are still in place.

Serialize both paths with a new generic_ops_lock. They can also be
reached at runtime via efivars_generic_ops_[un]register() from
tee_stmm_efi. The device is registered and unregistered outside
efivars_lock, so a consumer can take efivars_lock from its probe or
remove path.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 52 +++++++++++++++++++-
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 98f6365c1a8c..a9508595740b 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -31,6 +31,7 @@
 #include <linux/acpi.h>
 #include <linux/ucs2_string.h>
 #include <linux/memblock.h>
+#include <linux/mutex.h>
 #include <linux/security.h>
 #include <linux/notifier.h>
 
@@ -190,6 +191,21 @@ EXPORT_SYMBOL_GPL(efivar_ops_nh);
 static struct efivars generic_efivars;
 static struct efivar_operations generic_ops;
 
+/*
+ * Serializes generic_ops_register() and generic_ops_unregister(), which may
+ * also be called at runtime via efivars_generic_ops_[un]register(), and
+ * protects efivars_pdev.
+ */
+static DEFINE_MUTEX(generic_ops_lock);
+
+/*
+ * The "efivars" platform device that efi-pstore binds to. It only exists
+ * while the generic, EFI runtime services based efivars ops are registered
+ * and support SetVariable(), as other efivars implementations may not
+ * provide a SetVariable() that is safe to call from the pstore dump path.
+ */
+static struct platform_device *efivars_pdev;
+
 static bool generic_ops_supported(void)
 {
 	unsigned long name_size;
@@ -210,6 +226,11 @@ static bool generic_ops_supported(void)
 
 static int generic_ops_register(void)
 {
+	struct platform_device *pdev;
+	int ret;
+
+	guard(mutex)(&generic_ops_lock);
+
 	if (!generic_ops_supported())
 		return 0;
 
@@ -222,14 +243,42 @@ static int generic_ops_register(void)
 		generic_ops.set_variable = efi.set_variable;
 		generic_ops.set_variable_nonblocking = efi.set_variable_nonblocking;
 	}
-	return efivars_register(&generic_efivars, &generic_ops);
+
+	ret = efivars_register(&generic_efivars, &generic_ops);
+	if (ret || !generic_ops.set_variable)
+		return ret;
+
+	/*
+	 * Register the platform device only after efivars_register() has
+	 * returned, so that a consumer probing synchronously from
+	 * platform_device_register_simple() can take efivars_lock.
+	 */
+	pdev = platform_device_register_simple("efivars", 0, NULL, 0);
+	if (IS_ERR(pdev))
+		pr_warn("efi: failed to register efivars platform device: %pe\n",
+			pdev);
+	else
+		efivars_pdev = pdev;
+
+	return 0;
 }
 
 static void generic_ops_unregister(void)
 {
+	guard(mutex)(&generic_ops_lock);
+
 	if (!generic_ops.get_variable)
 		return;
 
+	/*
+	 * Unregister the platform device first, so that consumers are
+	 * detached while the efivars ops they rely on are still registered.
+	 */
+	if (efivars_pdev) {
+		platform_device_unregister(efivars_pdev);
+		efivars_pdev = NULL;
+	}
+
 	efivars_unregister(&generic_efivars);
 }
 
@@ -482,7 +531,6 @@ static int __init efisubsys_init(void)
 		error = efivar_ssdt_load();
 		if (error)
 			pr_err("efi: failed to load SSDT, error %d.\n", error);
-		platform_device_register_simple("efivars", 0, NULL, 0);
 	}
 
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
-- 
2.56.1.831.g720f3f5937-goog

