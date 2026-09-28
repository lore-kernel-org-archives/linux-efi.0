Received: from mta0.migadu.com (out-79.mta0.migadu.com [91.218.175.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA7730D3FA
	for <linux-efi@vger.kernel.org>; Mon, 28 Sep 2026 02:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790562647; cv=none; b=hdDCFvaEtd6zjzKW3Ubun8o7lGROeV5zbfqsfORzbJ+i7Ls8kaJW38vH5dZxhGZhDqI0dWFgBXMlk0t+rqnC4OjR6/hP1cRwB67RwTB8aH8Uj9+YrYb/2ySovfQEuZIzlAYV9gHB+ueORVg5ko7mXGGZyrKmKlloSc0e+UVqvH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790562647; c=relaxed/simple;
	bh=4+s99KWizSzbFmjJiglWm5XJ4fIhkEZlwghACv5Q8bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnlR44lS5FM9edbtvuYyfphL/ucWH+nZHwLwKCjlOQFWLg9XMY/s7ugTOD1pNuc5I5LD9iO5QsJ0aL70vJHE8GpDAlKA/5Q5wuiwvEE7TBicGmBIVqeaJGnlkVehl1KNBCcBbIuTt0ZsbTg6GU51tliWwYKhn4cBwGfbcK7Zatw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rj94uIUP; arc=none smtp.client-ip=91.218.175.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rj94uIUP"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4+s99KWizSzbFmjJiglWm5XJ4fIhkEZlwghACv5Q8bE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790562642; v=1; x=1791167442;
 b=Rj94uIUP3AEcFLC/QVR69BsOqgxVWbnnMzQ29M4+qXoZy/NgGYgEvTbl1fM4l+RFXjf0v3iR
 8FyluHgllvHCR1TeDiSTHwKsRyZii3ZOK+IwN+r7+1Gn5jjsNhR9zyTDGwsBV/dKk7aKLWRmRw/
 WyBDVoAsu6O+NZiots7qw0WY=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4c0fd7c181865d0e;
	Mon, 28 Sep 2026 02:30:29 +0000
X-Mizu-Trace-ID: 4c0fd7c181865d0e
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org
Cc: chenhuacai@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org,
	ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	liukexin@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 0/5] LoongArch: add KHO support and selftests
Date: Mon, 28 Sep 2026 10:30:10 +0800
Message-ID: <20260928023010.3018-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ap3KYSXQJfC0iysw@kernel.org>
References: <ap3KYSXQJfC0iysw@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Mike,

On Sun, Sep 06, 2026 at 11:17:37PM +0300, Mike Rapoport wrote:
> > EFI KHO channel:
>
> I can't say I like "transport" and "channel" terminology. We don't send
> anything anywhere.

Agreed. It is just a table that the next kernel reads. v6 calls it the
KHO EFI configuration table everywhere, and "transport" and "channel"
are gone from the code, the commit messages and the cover letter.

[...]

> The text here and in the patches changelog reads reads as LLM-generated
> text. First, it's quite blind and unreadable with wall-to-wall text.
> Second, LLMs tend to describe what they did in the context of a session,
> but since we apply the cover letter to the liveupdate tree, the description
> here should *only* describe why the changes are required and how they are
> implemented. The history belongs to changes since vN-1 section.
>
> And last, but not least, please add LLM attribution as per
>
> https://docs.kernel.org/process/coding-assistants.html#attribution

You are right, and I am sorry. I used an LLM to help write this series.
I meant to check every line word by word myself before sending, but I
made a mistake and sent v5 to the list before doing that check.

For v6:

  - The cover letter only explains why LoongArch needs this and how it
    works. Everything about earlier versions moves to "Changes since v5".
  - I am rewriting the cover letter and commit messages by hand, in
    short paragraphs, and checking every line myself before sending.
  - Every patch carries the Assisted-by tag if we used LLM.

Thanks,
George
