Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2421C3859EC;
	Thu, 21 May 2026 10:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779358836; cv=none; b=oocbsCeOQOMqyTLzw396PQ4h4/+4w6B1n0Q/3Lx8gghXRUfn3zjIqUKjo2UuWyWAXrxaACAVzy+rKBL/z9v338X27XSU9/DHUztzWjTK4xj9sQQcHb8j0F40vQ54IE8LsJUU/G/0yuurKbrjuVFm7iVJYlbhIKB43OZJ5GF84ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779358836; c=relaxed/simple;
	bh=1f/ulOFWyS36z9h5EqbabyH745x6EpbIJnr9m+VEX6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eAKySgfxKbI0dNfrSvgskaRCCiOcWHscBsI4KAFh+ka+4eLMJrph2XsTrt9/of9U2K1CSXply7F2s4kyRwumSup0LYNBlfA2wwgDST9qy2bmTPkaZ6ONCTk2FJ1+V1pQH3TmH6oKppANnuj8UGN/QV2MtyyUExKv9fs2yUksGSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBumZy9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBumZy9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7C21F000E9;
	Thu, 21 May 2026 10:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779358834;
	bh=ao+6tfyvN0TM7Y9sdweWWgZPTy6nEqH68MZqpGpe4yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBumZy9AD4HIF1kz2Y6bPYx0hehDrqAgxOFqYUoctSBYREyF25xqDf9Rfzypeo398
	 322pshRCQfLWe+Ds5rVAETQbDQGskMyODBSBh9L+tGTZe1K6GfpScVXu5q2RWSe2jE
	 budbuJP4ZFjqb8h1G/WUTT1GhfsAVu+lL4XnrsVazlj0+BeauNz5+LY6jzxePsIfSn
	 y0Ytz6XQBx8SKU2WloxUjhTQ/H3AMsbt466XzZLlnh8FvtU3NMvtXM1lM5l8O2O71/
	 58PsLQv4cjBzauGLe0eOAGC9+5rVe6PAk0Bi0gYn7TSn/qfeybLcvjLM/KQP3gEj18
	 rw3xtYjAJ3nQQ==
From: Kees Cook <kees@kernel.org>
To: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb+git@google.com>
Cc: Kees Cook <kees@kernel.org>,
	linux-efi@vger.kernel.org,
	ebiggers@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] lkdtm: Add case to provoke a crash in EFI runtime services
Date: Thu, 21 May 2026 03:20:32 -0700
Message-Id: <177935882964.2266075.6723114000327315860.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260501170156.2833364-2-ardb+git@google.com>
References: <20260501170156.2833364-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 01 May 2026 19:01:56 +0200, Ard Biesheuvel wrote:
> Add a lkdtm test case that triggers a fault during the execution of a
> EFI runtime service by passing a read-only variable as a by-ref argument
> that the firmware is supposed to update.
> 
> This is useful for testing the graceful handling of faults/exception in
> EFI platform firmware, which is implemented on x86 and arm64.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] lkdtm: Add case to provoke a crash in EFI runtime services
      https://git.kernel.org/kees/c/a34039981e6d

Take care,

-- 
Kees Cook

