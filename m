Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13922356C6;
	Wed, 18 Mar 2026 01:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773796801; cv=none; b=pEU/j7W6+5rMKk8lcRv4vUdawZU2HKqr618dy6m0LwEbInct8xkkqessSpBPd4dhkFSqJbB/LNHxB6+LL4wfuAmyLqh0jnE0zmYUHGIFJpuqIbYFubEfKnPXmFKRdoqqkWDWDRwzu0L15voWBlmbNNJKAS0Qb7CqKzNhMbxoAmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773796801; c=relaxed/simple;
	bh=yAifhaYQwQRjdJupdCMOzJ9YPeXTiObHutsV8aw8X6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GeL1D33h9s3klEyrsj5U7hWV5wW8j+sJbSZxEbfgsHu2equBf5WLj2Plxok6vJbMTvdUP3CXEIq2v9Z3JYFF3KPbMWJC3tGMVs99L2Xf8yNPUk9DZHLWZn9QF009MbfMAURf8LZ6iTxzdP8UetaQWt/gW+uCi4cjJBdYHsFgmG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MB2Y8Nuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MB2Y8Nuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6C3C4CEF7;
	Wed, 18 Mar 2026 01:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773796800;
	bh=yAifhaYQwQRjdJupdCMOzJ9YPeXTiObHutsV8aw8X6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MB2Y8Nujj7OLQ6XUrzM5gGFaRjeiHEFoJNCKlWSpXyDmJVi3WKMYYYU2BFxMhUa9C
	 sPKw7cyXkEt+mRLYB3gX4CBSL9/jOVxPqE0Zi3lgjCfyJGF7hasoQAyW3oCUCf6K51
	 Q26QgBH9qRCEmTQq9aQWswYv1XMcE4mddbMAfhjkxW1sTckcFNkuMAWyikzPVH6Cl6
	 eyziKzgB/iuFxfM7E7gA+4lMBiZJcZuOE6Gms7dewHPj2hDUlgB5LN1UOkq0LQfrg+
	 m6zFb8iK+iV5PNTfqT9mjGGG4MX36a/VwGP3XKmkQMR0lnfgQsbBHefkyvMDAeRKVE
	 38rR4B1l7e2mw==
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/1] lib/vsprintf: Limit the returning size to INT_MAX
Date: Wed, 18 Mar 2026 10:19:56 +0900
Message-ID: <177379679625.535490.15253547806594621828.stgit@devnote2>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <177379678638.535490.18200744206158553364.stgit@devnote2>
References: <177379678638.535490.18200744206158553364.stgit@devnote2>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

There seems a design flaw of vsnprintf() whose return value can
overflow the INT_MAX even on 32bit arch, because the buffer size is
passed by 'size_t' but it returns the printed or required size in 'int'.

The size_t is unsigned long, thus the caller can pass bigger than INT_MAX
as the size of buffer (that is OK). But even the vsnprintf calculates
the required/printed length correctly, if it overflows the INT_MAX,
it can not return the size correctly by int.

This should never happen but it should be checked and limited.

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 drivers/firmware/efi/libstub/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index 71c71c222346..1713cacecc25 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -549,7 +549,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
 	if (size)
 		buf[min(pos, size-1)] = '\0';
 
-	return pos;
+	return (pos > INT_MAX) ? INT_MAX : pos;
 }
 
 int snprintf(char *buf, size_t size, const char *fmt, ...)

