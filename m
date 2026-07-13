Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1505541734E;
	Mon, 13 Jul 2026 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948023; cv=none; b=EDDL6n04Mx1b2Ua9N2cJLzzmg1tbhhhvIqeDJ4JrVOWn057ZbS/+u1k9RM7Lc7mea04A9xIjMBvSNedfTTj+/cNMkNbrE0TQfx+PUI7l84F3It69koNYRQu1dENffSmnXVqVw6FSzR06nZ4LQEdJJl/lmOOCtYimwFdzSbwOxzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948023; c=relaxed/simple;
	bh=YNqMHbPHtcatBAom9bpWm6dc4YS6eNDHkiLzimpgo/U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k67ShJflfkKHINhKfvlabN2RfBMPBUAlMRrOztZba0v9lfVYXPfA+E8bKgCDyozmLduRkpK+T8VQhvf15DNU7tmtMljlaTLlfo9b/7Z7CaQ65N+TEFCiGCy8Ttj3iXmX8dUtOP2NHT1wbd8cCA+JAzQixwU4GkOMhaGGDgkFxPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=YW0rhN5Y; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="YW0rhN5Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=/clfHiviW8rGggKSAfLnYiTVYel/OCtKAh8vetI/Azw=; b=YW0rhN5Y5zj/V207SAh0Fzvega
	XxcyYTZiin3blRC7lCDdGajP7aHOJmIDfHGVWqON0QPZ8k17yeQlJSQeNqDzz7PqWJfSZ6h87nHuP
	eFAjyA6TwqvRrWCjc49BOIVDBPbHhFDkIiDK5PmlpVoo+hAmh6GHUGWvNXEI/OjVypPgB/DvLgoJq
	ifq6nlpZXJc00qABZef6AfVncG9JCYCAL0e0H3yaSWXnPoEJ3UsjBzUPYvbF9Q8PXaB0+fJXdF9iv
	EkW7Z1Ypvh3ucoqdj8ExDQYTL7LGBVlJqpXZN+2tkRoH3wSoFYOAEAH9IhvDW8JMT+Z06dNEUTpH0
	/1KYFSEQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjGN8-001WJN-16;
	Mon, 13 Jul 2026 13:06:58 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Jul 2026 06:06:47 -0700
Subject: [PATCH 1/2] efi/runtime-wrappers: mark efi_rts_park_worker() as
 __noreturn
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-efi_fixes-v1-1-cdde378d9df9@debian.org>
References: <20260713-efi_fixes-v1-0-cdde378d9df9@debian.org>
In-Reply-To: <20260713-efi_fixes-v1-0-cdde378d9df9@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com, 
 kernel test robot <lkp@intel.com>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2483; i=leitao@debian.org;
 h=from:subject:message-id; bh=YNqMHbPHtcatBAom9bpWm6dc4YS6eNDHkiLzimpgo/U=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqVOLqAxPKyLNo890pDO+weYq81Z8MPcKriftnR
 Apk0p2OS12JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalTi6gAKCRA1o5Of/Hh3
 bdt1D/0ZNy8dQcK7jVhwakgz8FQ7UnypLGCUQE4h9qogAqdy0N3ElueV3pz8EbnjYpIzubm82Ge
 XKAGqxyQgV7M7RwcU8Xb034M15dBsLLuZf68Z4Fq6600FJtQOULdymXOSJuwDIYVR4vVYfLsbCM
 Cm01AkQAH3gHo0O90cAO5u4JYEgcUQfs13j2Nwqp7CR63LDKuN9EMSDuGsgWtKNmE+K8cItUh5w
 kUxY0Lsdy1XrIwyP187DQiqLy42awS+h7Ivl3HGHIBn0suW/NU9BioA1DjUbrGmNHWCsySQPWa3
 TC6NQOefMhY9xCtZ8rjX1lOuJfFVtI/+aoQSF2N1IS+mGBtWjHndZ8OOCpL4C7Z+il/upIAEgVu
 QKlK6ormEbzcAP91eyyOdFjB3PPxZq76EcjrV4hBlOrd3adPgyOtNVGPCUEZZWIKBv0HTzUR7OS
 z3GozoaJOyIXkmKf31bw0bGVyDOe2nKNntBLthTlHtnh1Qf1EEj043dFV25cxr2ACdpQUvz5MLG
 k/dpk+j1uFVaY6bz5ISobwvXh17aa+hqaN/idn1gzNKyPenLvI/FkavMa7IuWmF0j8bGLvGOWbR
 FtCXknAPLImvwhpKSroM3coaKnjD7Rr85Y8SH5UDclT/X32YtxJXJvSZZqAsUUd4iJkBtwdxrfZ
 IKfwweullAdqAuQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

efi_rts_park_worker() loops in schedule() forever and never returns, but
it is not annotated as such. When efi_crash_gracefully_on_page_fault()
calls it, objtool cannot tell the call is a dead end and warns about the
unreachable code that follows it:

  vmlinux.o: warning: objtool: efi_crash_gracefully_on_page_fault+0xc3: efi_rts_park_worker() missing __noreturn in .c/.h or NORETURN() in noreturns.h

Mark both the declaration and the definition __noreturn, and add the
function to objtool's noreturn list.

Fixes: 3e5ba97c181e ("efi/runtime-wrappers: factor out efi_rts_park_worker()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607100848.iWPxdkhX-lkp@intel.com/
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 2 +-
 include/linux/efi.h                     | 2 +-
 tools/objtool/noreturns.h               | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 591a725b10613..6f42da11a9178 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -224,7 +224,7 @@ extern struct semaphore __efi_uv_runtime_lock __alias(efi_runtime_lock);
  * have been disabled and its efi_rts_work is abandoned. Loop in schedule()
  * so a spurious wakeup cannot resume it.
  */
-void efi_rts_park_worker(void)
+void __noreturn efi_rts_park_worker(void)
 {
 	for (;;) {
 		set_current_state(TASK_IDLE);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 015505423277e..b3c83516593d1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1256,7 +1256,7 @@ extern struct efi_runtime_work efi_rts_work;
 /* Workqueue to queue EFI Runtime Services */
 extern struct workqueue_struct *efi_rts_wq;
 
-void efi_rts_park_worker(void);
+void __noreturn efi_rts_park_worker(void);
 
 struct linux_efi_memreserve {
 	int		size;			// allocated size of the array
diff --git a/tools/objtool/noreturns.h b/tools/objtool/noreturns.h
index 14f8ab653449c..0e9dfd0a2446c 100644
--- a/tools/objtool/noreturns.h
+++ b/tools/objtool/noreturns.h
@@ -26,6 +26,7 @@ NORETURN(cpu_startup_entry)
 NORETURN(do_exit)
 NORETURN(do_group_exit)
 NORETURN(do_task_dead)
+NORETURN(efi_rts_park_worker)
 NORETURN(ex_handler_msr_mce)
 NORETURN(hlt_play_dead)
 NORETURN(hv_ghcb_terminate)

-- 
2.53.0-Meta

