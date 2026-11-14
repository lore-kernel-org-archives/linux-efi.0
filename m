Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794675419;
	b=byr7bq8cK7V1dCBRI83+sMmb9SqqT389AeZ7PBiU25JaTQCXYXCzTgdA5QFpRo8sj/2/
	 SjyKKxZEmP3u2K8+Ni0zblmE1RVYv2xp9fs3tOzqy66cPfTYGdXw/FqciSIUOnaOINDo5
	 TiZWffF0EddKRmV+eSaWUxJHF2g39NakBLQQwpPO/fKG+oBMv6WwEa7l5svYgcYhqSQfZ
	 24w1a+nM8o7+G1agrNJ6GQ971CkOsKQDbmeMheFUbXnp8I0LS9gUsIDfG1+DyT1OkJ7rz
	 Ek6zflxIOHkR5nHdO0OOtqH/4N0SF1Unk9/zgd+hXYMAf3W+8dU6KA3hrhAucX+DI/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794675419;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uQximJwLYj6Lfa3XenE63rosMCyJlomCN9RTOM5F9N0=;
	b=gqkpA8ugD90Pvhx6azcgCK8h6X6v6OZz1t4IbovS0bSpYE5+g1A8sOU/BoqDcRc71SJv
	 Hmnalc3GKxqwpVbh/lEFURchcZopDv/pZauT/u0d58LUW2P4PdGdGiraJGNn3smSpzyro
	 LiI5QIViCt1chtNn/YJ9Cs5exI5xoDN2j7zcOTi5AdF7uTguBnqcvxhjT0tv5cXWFiaUO
	 g9xYLhJo2JFdA99b+s8v13tQb92/Sk6U6OIEEBhYQATTHxXVc4VZ4GaBqc79NUzmxEGwO
	 qIs3hM0wZKXiyuGK4AU5L1jpLuh6gkstwF3xYV4mcQ+fKzdZAw9MiBhW8OAvbAKf5UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v6qLJSeg;
	arc=none smtp.remote-ip=209.85.208.177
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E37606A33E
	for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 16:56:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64E37606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v6qLJSeg
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3ab46699a09so23443591fa.0
        for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 08:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794675416; x=1795280216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uQximJwLYj6Lfa3XenE63rosMCyJlomCN9RTOM5F9N0=;
        b=v6qLJSegZUS7+CLnyvtWid+jXPX+TRuUV59RiVKeTXtxdW3D+FcXkAuOxkqSX6PqXl
         9IHY+uifybmWbN5HjO0RxAk/20UW5E2+tDxFBxUoi9xETZQBpZA6hHCL+dvrH5/F2Zdd
         MLcbJL0gDonDQP8BdHzCHC5thlt3xJfeIJTq+aAPp2yMgJngBq+C34FcjCtW0uqgBbe3
         MaW9GrvGFWnzo9sjTAQkksHa93nm1KKpYup0RaxlqwtB05YQIaO73rRmKe0FVGs2Cz5b
         qka7dUz8g4F95OKhTlg31u9vp35WXZFX4nq94RVy6Jhh4F35XE3S5I1qcmm/ocomT3Fg
         F0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794675416; x=1795280216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uQximJwLYj6Lfa3XenE63rosMCyJlomCN9RTOM5F9N0=;
        b=kAzhue3J7MIi/Tlq692oJKA0JKkMsEKsJEjc6oi/L++00240J85NQgAxLwMx73H0Dp
         hlRg33I3WKVy7IpNwvjoHxyvCHMDhSyZWdUczUhtWE94kX3aRqR8PWMsq8blQhTcBYU7
         WGiT2H3LAXu8cUefaV8B137dMdqcM8Fi7pI6AqAX3HYKf9a9RACqZZDJ6MZPr8X3oi7K
         lZlnBCTRftsD71bwHado/BKww6b0jH9Re6E6kXAl47QSXRdQzs+lnepQqoFc+O5xDbRA
         J5ziANNUy0yNwrG46r5gwyMIZTUqrsZizn4BdQczv9syCVWJJ1ccaoDDFv0YAK2+WT+v
         VBTw==
X-Forwarded-Encrypted: i=1; AL+hErHFq61dbPF3sJuBI+XCIADCQacYRucEZ6HIS7TQ6LfGWsUZD14I9kLBkHikqi4eLylfQLvdqPRTgwc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+ANQlgjx4doAHQoTPPsT27A0CE2eL4R0VjKdUN9HG1GJAJM2ST
	bEo5wCSkXk394IMM4lZi7KwcOiJvkx9Dvbz2QnZusEaH3ZfADt6Z4yrw
X-Gm-Gg: AYBFou05sHf9qzBjTalwGZ2bSGARY5UPa8QELNxie0RuHq1SUxhQFqPMnYWMkrFUWdf
	SzAEDJhAt+cSF83Oh4UZ6/yipOjUq2DHpw2MidV/3OczXmLQGkUvqWZiSRdHDqLgPF069GSETqa
	y5j9Kiq7xU6cY3faJtVUTRCvP1HfHw3G5BoyJ55TPSIj1Jw16NxbH4CkEfuKCKDUkaDezRPIHrq
	t/hTJ7cxHPdi5OvYXCze7rx/7dZ6iuB+mcwV5SU4qqQkP9jTqU+ESUxau/5PmnzIoqakgnjXztF
	h80nCpYGrczmB6WE7WZP71AOJpWrNVhE5OliqX8ZlnlG7Zpy0MekWXpwDjkk0vng0REb6TXKTWD
	5vmFk4AH9Sx7yqOLGXyIqyrF3vi1wLCwCbO899uCjM6abJyhGQw3B0oB0WApN0bN7HNnBJiodML
	jyX+gNR4o1fhPKheKYeqhFgLCRNVSqi6cYXEASuCDkRBnmTgjsMiOHjcLOFjFmMXUIkgAfE1CjP
	xuJUKSvPl45ovaPx03rIQ3uGPInJFUrDfQ/f7pNxo8g5v+zxh44T8dOGvTFgrUT+TEbuTgjnBU8
	6Fs2uk7PaOj9Z6XvE4RBc5DfdGR3HMUzl7F9gBpss9I9FzgRqoT7M7sD32KRs6YccNcMAMkX9k4
	zRAH5MrEjsQ==
X-Received: by 2002:a05:651c:b22:b0:3a6:95a:52a6 with SMTP id 38308e7fff4ca-3ae2b51fa1bmr19487401fa.20.1794675416400;
        Sat, 14 Nov 2026 08:56:56 -0800 (PST)
Received: from SafoStation ([31.40.65.49])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1712dad26sm1792051e87.8.2026.11.14.08.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 08:56:56 -0800 (PST)
From: Safocl Stollmannovic <safocl88@gmail.com>
To: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: [PATCH v3 07/14] x86: fix duplicate extern declarations
Date: Sat, 14 Nov 2026 20:55:47 +0400
Message-ID: <20261114165612.368785-8-safocl88@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114165612.368785-1-safocl88@gmail.com>
References: <20261114165612.368785-1-safocl88@gmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Compiling a kernel module with a C++ compiler results in a "duplicate
extern specifier" error.
This occurs because the code contains `extern asmlinkage`, and `asmlinkage`
expands to `extern C` when processed by a C++ compiler.
Since the code already contains sections that respond to a C++ compiler,
I believe it is a perfectly valid approach to gradually move toward a state
where kernel modules can be compiled by a C++ compiler without any issues.
The `extern` specifier must be removed.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=222257
Signed-off-by: Safocl Stollmannovic <safocl88@gmail.com>
---
 arch/x86/include/asm/efi.h       | 2 +-
 arch/x86/include/asm/gsseg.h     | 2 +-
 arch/x86/include/asm/preempt.h   | 8 ++++----
 arch/x86/include/asm/processor.h | 2 +-
 arch/x86/include/asm/suspend.h   | 2 +-
 arch/x86/um/sys_call_table_32.c  | 4 ++--
 arch/x86/um/sys_call_table_64.c  | 4 ++--
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index be58b7f5c..f5cb179b8 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -94,7 +94,7 @@ static inline void efi_fpu_end(void)
 #else /* !CONFIG_X86_32 */
 #define EFI_X86_KERNEL_ALLOC_LIMIT		EFI_ALLOC_LIMIT
 
-extern asmlinkage u64 __efi_call(void *fp, ...);
+asmlinkage u64 __efi_call(void *fp, ...);
 
 extern bool efi_disable_ibt_for_runtime;
 
diff --git a/arch/x86/include/asm/gsseg.h b/arch/x86/include/asm/gsseg.h
index ab6a595ce..81ef16081 100644
--- a/arch/x86/include/asm/gsseg.h
+++ b/arch/x86/include/asm/gsseg.h
@@ -12,7 +12,7 @@
 
 #ifdef CONFIG_X86_64
 
-extern asmlinkage void asm_load_gs_index(u16 selector);
+asmlinkage void asm_load_gs_index(u16 selector);
 
 /* Replace with "lkgs %di" once binutils support LKGS instruction */
 #define LKGS_DI _ASM_BYTES(0xf2,0x0f,0x00,0xf7)
diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index d16d9c2f7..135695ae3 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -134,11 +134,11 @@ static __always_inline bool should_resched(int preempt_offset)
 
 #ifdef CONFIG_PREEMPTION
 
-extern asmlinkage void preempt_schedule(void);
-extern asmlinkage void preempt_schedule_thunk(void);
+asmlinkage void preempt_schedule(void);
+asmlinkage void preempt_schedule_thunk(void);
 
-extern asmlinkage void preempt_schedule_notrace(void);
-extern asmlinkage void preempt_schedule_notrace_thunk(void);
+asmlinkage void preempt_schedule_notrace(void);
+asmlinkage void preempt_schedule_notrace_thunk(void);
 
 #define __preempt_schedule() \
 	asm volatile ("call preempt_schedule_thunk" : ASM_CALL_CONSTRAINT);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 77488ff5e..68d7292af 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -455,7 +455,7 @@ static inline unsigned long cpu_kernelmode_gs_base(int cpu)
 #endif
 }
 
-extern asmlinkage void entry_SYSCALL32_ignore(void);
+asmlinkage void entry_SYSCALL32_ignore(void);
 
 /* Save actual FS/GS selectors and bases to current->thread */
 void current_save_fsgs(void);
diff --git a/arch/x86/include/asm/suspend.h b/arch/x86/include/asm/suspend.h
index a892494ca..e29c071b9 100644
--- a/arch/x86/include/asm/suspend.h
+++ b/arch/x86/include/asm/suspend.h
@@ -11,4 +11,4 @@ extern unsigned long temp_pgt __visible;
 extern unsigned long relocated_restore_code __visible;
 extern int relocate_restore_code(void);
 /* Defined in hibernate_asm_32/64.S */
-extern asmlinkage __visible int restore_image(void);
+asmlinkage __visible int restore_image(void);
diff --git a/arch/x86/um/sys_call_table_32.c b/arch/x86/um/sys_call_table_32.c
index 51655133e..f79c0138e 100644
--- a/arch/x86/um/sys_call_table_32.c
+++ b/arch/x86/um/sys_call_table_32.c
@@ -9,7 +9,7 @@
 #include <linux/cache.h>
 #include <asm/syscall.h>
 
-extern asmlinkage long sys_ni_syscall(unsigned long, unsigned long,
+asmlinkage long sys_ni_syscall(unsigned long, unsigned long,
 				      unsigned long, unsigned long,
 				      unsigned long, unsigned long);
 
@@ -28,7 +28,7 @@ extern asmlinkage long sys_ni_syscall(unsigned long, unsigned long,
 #define __SYSCALL_WITH_COMPAT(nr, native, compat)	__SYSCALL(nr, native)
 #define __SYSCALL_NORETURN __SYSCALL
 
-#define __SYSCALL(nr, sym) extern asmlinkage long sym(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
+#define __SYSCALL(nr, sym) asmlinkage long sym(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
 #include <asm/syscalls_32.h>
 #undef  __SYSCALL
 
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index 943d414f2..555e65e66 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -9,7 +9,7 @@
 #include <linux/cache.h>
 #include <asm/syscall.h>
 
-extern asmlinkage long sys_ni_syscall(unsigned long, unsigned long,
+asmlinkage long sys_ni_syscall(unsigned long, unsigned long,
 				      unsigned long, unsigned long,
 				      unsigned long, unsigned long);
 
@@ -24,7 +24,7 @@ extern asmlinkage long sys_ni_syscall(unsigned long, unsigned long,
 
 #define __SYSCALL_NORETURN __SYSCALL
 
-#define __SYSCALL(nr, sym) extern asmlinkage long sym(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
+#define __SYSCALL(nr, sym) asmlinkage long sym(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
 #include <asm/syscalls_64.h>
 #undef  __SYSCALL
 
-- 
2.56.1

