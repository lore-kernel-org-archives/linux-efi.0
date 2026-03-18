Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0A22356C6;
	Wed, 18 Mar 2026 01:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773796791; cv=none; b=bXyemcE7cGilpImhsLW7XyhziCfAUgpC4bZfaZBN3zYDbtO9lULjmw7/vt9fte/2tOxgRAuXWwlTlG+VEzKpkoM8562pitf/+ry5WPi8XAJLpmdkHlNJcKx1FTIK2NWYEbRT/1pTKGKmDmfOaQX/au8QKK+ku1voNSnwziGsMsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773796791; c=relaxed/simple;
	bh=wkRkdHTjJpPJrrUm0RBB7CdVSSFt6fEtAdxkeomYJYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FlMCPOwtQJxhLg5+I7TqBINCigzgenP8V/ZP/GI32ASZ0ekhR6Z37dgIEtvViJobp7MTI4uiH/4gD6MZwP0vlaPEMLRh2iacmhFoeWdidz/8zwKJZVrUk9Je1J3geYf9M5vR4Yqs6ehYtT3FCzlNJ2d+zOzyOVTZMnOrHnnF1uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZnkTaDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZnkTaDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25999C4CEF7;
	Wed, 18 Mar 2026 01:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773796790;
	bh=wkRkdHTjJpPJrrUm0RBB7CdVSSFt6fEtAdxkeomYJYI=;
	h=From:To:Cc:Subject:Date:From;
	b=fZnkTaDjdQK7l0YKFAnQpR9G2gquGzq5fEwhg9ANTcBAEPbixU4ZFjv8i9hnilPKb
	 DmMvhBQUTRZ6/H/uS11ijLQhnWTPSDe+YjzscNoKKYb6xu5CHykNfjadVSIG+5nFfu
	 Fm3UtkiUr6Z+qN9Ca5mOgy+DGt4jXZhAJJhnovXXDkixCNZ5EZRdNvzqP94wBh03V+
	 2duIAmC/4AMphy2l4kEh1tyUyOacFZnApFjfT+P56oacX8Q8Lay64YSLci5caxRj73
	 GtqREodNm20CsZMMLTNq7fu4mpvVLEQNtOHTQQJibBp+tzbOsVkgemPM7Q2E4+QH8E
	 Wj05EnaVvpwUA==
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/1] lib/vsnprintf: Limit the returning size to INT_MAX
Date: Wed, 18 Mar 2026 10:19:46 +0900
Message-ID: <177379678638.535490.18200744206158553364.stgit@devnote2>
X-Mailer: git-send-email 2.43.0
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi,

Recently we discussed snprintf() usage in bootconfig and found snprintf()
design has a problem[1]. It returns the required or printed size in 'int'
but the maxlen is passed by 'size_t'. If the maxlen is bigger than INT_MAX
(this should never happen), it can not return the size correctly, that
becomes negative value or very shorter than it has actually done.

I think it should not be handled by caller side, instead, vsnprintf()
should handle it. This is an extremely unlikely input, and if we need to
address it, I think we should keep the fix to a minimum (in performance
point of view).

Thus I just limited the returning size to INT_MAX. If caller sees the
*printf() returns INT_MAX, it can handle it as an error or use strlen()
to get real printed size (but I don't recommend it.)

IMHO, this input is basically impossible unless done intentionally,
so I think it's a form of over-engineering. Therefore, this is an
RFC patch.

A question is that we should use WARN_ON() when the return size is over
INT_MAX. Currently this just returns INT_MAX (no warning) because this is
a library function, which can be called from anywhere.

[1] https://lore.kernel.org/all/20260317121507.30735331@gandalf.local.home/

Thank you,

---

Masami Hiramatsu (Google) (1):
      lib/vsprintf: Limit the returning size to INT_MAX


 drivers/firmware/efi/libstub/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--
Masami Hiramatsu (Google) <mhiramat@kernel.org>
