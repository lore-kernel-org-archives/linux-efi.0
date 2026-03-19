Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9F0371D0D
	for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 09:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911174; cv=none; b=fUcWBUAKo4oDyTnrLRrnUlR4YN8u9DAN3qP5raFvsVe3Kp7OBn1s+ZtuHG2suhTthSx2/G0nbjaCN9Q7yVhv21Imo3QMi5eCH+EAJ59naAafr5Kh2hBVEznCsY99tHsqWY1QTEl4xDqsqsunkfQDFlmGddesZ2MPtpgpjTqWerk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911174; c=relaxed/simple;
	bh=exoya81jXoIK8WWhopcrulNyNM1oh6DkePORwiM7+yQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UBAOuGVlkZsPvzge75CgYLrdCQAhR86ZodNxD4cDQVrWJVgVrmr6oI5MCm8CSYrEWCDHNfetyrUZv0ipMeIdIcrLqxeb9lXUdrVt2tWLo/10C03Zk0V90IQ44dwsl67k15UJ8GDa3bH7b5JVMb1yxsVTw6bLAgYhSqXjCeiZWtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zjgku3Ss; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zjgku3Ss"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439bab2d095so317465f8f.3
        for <linux-efi@vger.kernel.org>; Thu, 19 Mar 2026 02:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773911170; x=1774515970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NH8dUmPRO71CDP7E1Gavchx0/GEscmuj+FtvRs5QlzI=;
        b=Zjgku3Ss3KtBhZA9YrXCj93KOiQ9aVHZ0obliMYyg5nhvgeIeZyJye4PhfEKmMaQVJ
         iDsW4+QOiVukePrcEbrdymnGNrL8dSs3yPWG+hJdzHgocp9wjLRPcwU8xLrrEwNzZCiO
         i4cyJwx9Vw19TdyoBOv2x5vx9NHIrsjEvchJ2FpHS1xHR9E+D/6H41URmVr+SfrJZjhE
         wW8m0sAkSBIAURdK7a4NM38CDu8w11Ip6BmWEBOzMv1Sd009SehuSEhdVqEhoo/NHqKT
         ToKaN888dLoLOP/QaO7B8gV32pTP2s+o/GG4l6FOPtDrqVpCDUSpzdNHSIIV3KdQTHxB
         4Lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911170; x=1774515970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NH8dUmPRO71CDP7E1Gavchx0/GEscmuj+FtvRs5QlzI=;
        b=rm/8gd13NzwEa/qqIgxwq94KFpZ7IVNhMoAfWxvvHDsb0yjzsjoetgCcNeSLJw9goS
         ku+FmRjjP7st5MAe3gneryot8b8559XWCleI4naEZpdj2PxkzpfrnEZiR9fbXR6xxXo/
         u5s8VjgppXARYKNdcSmx0B3MytiLDkXg8+hQyOnyJNTSP01883+5K7/uWvKoAEcdAGws
         i/ZbY3yd3tuGp6JfjDAZ/5SlxM7lIzM4Ik0I89prRdE6gRjz7QLeJdz+n7Lf4EvmMIwd
         shNc1GldVW2NUjjKK+bluLYNTHrDn1TD79kR/8z5U653Q2hFO1bcadS84TlGISgRaD/i
         dtsA==
X-Gm-Message-State: AOJu0YyvYGRGzPAWm/fb9vtHSwLuzD3db3SQoJev3AL1ryhu/zXFa29I
	DqweusILAK9E59p4UJiJhhAFDsqcYqbUG+Bnjw1R7koHKid1HrKN5EU6XjcM82tk9zL0mGspmw=
	=
X-Received: from wrwj9.prod.google.com ([2002:a5d:5649:0:b0:43b:3a9b:25c0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2006:b0:439:b629:42d7
 with SMTP id ffacd0b85a97d-43b527c6c7emr11257711f8f.46.1773911170062; Thu, 19
 Mar 2026 02:06:10 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:05:38 +0100
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260319090529.1091660-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2084; i=ardb@kernel.org;
 h=from:subject; bh=u9C0lu/wWMOyoxfP7svUhbN70AoJL0lab86hPX1DebA=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIXP3npSNl9qYZP+LJR/tDZqsYyh4rHH3urOxihcttfmrP
 s7kYVPvKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPx28bwT2+GQvPLs5Fmohne
 7xe83BNl0vTe28H4vtkq379RH/2bHjEyrGA8qe0yXyi0XHBe99cld9W23DQsrwn7fuDBrDun9Vm fMgEA
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260319090529.1091660-29-ardb+git@google.com>
Subject: [PATCH v2 08/19] x86/efi: Omit redundant kernel image overlap check
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The physical region covering the kernel's executable image is
memblock_reserve()'d in early_mem_reserve(), and so it is guaranteed not
to intersect with the regions passed to can_free_region(). So remove the
pointless overlap check.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index c867153eab8a..13d9e036a23a 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -305,16 +305,11 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
  * can free regions in efi_free_boot_services().
  *
  * Use this function to ensure we do not free regions owned by somebody
- * else. We must only reserve (and then free) regions:
- *
- * - Not within any part of the kernel
- * - Not the BIOS reserved area (E820_TYPE_RESERVED, E820_TYPE_NVS, etc)
+ * else. We must only reserve (and then free) regions that do not intersect
+ * with the BIOS reserved area (E820_TYPE_RESERVED, E820_TYPE_NVS, etc)
  */
 static __init bool can_free_region(u64 start, u64 size)
 {
-	if (start + size > __pa_symbol(_text) && start <= __pa_symbol(_end))
-		return false;
-
 	if (!e820__mapped_all(start, start+size, E820_TYPE_RAM))
 		return false;
 
@@ -347,10 +342,8 @@ void __init efi_reserve_boot_services(void)
 		 * Because the following memblock_reserve() is paired
 		 * with free_reserved_area() for this region in
 		 * efi_free_boot_services(), we must be extremely
-		 * careful not to reserve, and subsequently free,
-		 * critical regions of memory (like the kernel image) or
-		 * those regions that somebody else has already
-		 * reserved.
+		 * careful not to reserve, and subsequently free, critical
+		 * regions of memory that somebody else has already reserved.
 		 *
 		 * A good example of a critical region that must not be
 		 * freed is page zero (first 4Kb of memory), which may
-- 
2.53.0.851.ga537e3e6e9-goog

