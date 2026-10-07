Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C143360EF2;
	Wed,  7 Oct 2026 02:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791340257; cv=none; b=A5L8l5fjQ4SrDCYojLmxUlPXxQ/IqZhdEJjh8pLNRxiJ+fbl2DPMFFNp13FWgw7E+uTuBT0hlyKPQLrLANJ+XBSq7GjEUcpj62QBdsDkcuy6K0GHNIro3fEkH2H8RcNL9iLkaUindZcehenNvP2avVJVV86UXLgG6Nf4rys2cOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791340257; c=relaxed/simple;
	bh=8tVV+/gTeRhfiqd4sBW3kFM6n9rW/QNFT1XXavd2IfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-Id; b=ror171Ca+MQLf3IjEdxApymB0IQ3bMvx54mFwN/00eEHrzUTVgT9fwd9jfW7Zje52c4MMzeMcRngxiip5WmRdS9a6M+DMsHzXTPJgZai/SlfzBVYkjNVoZJ3vL42aoVM/bNhh5MYEz+wTLxEvEyLrGkV2FXgL0GDCQd9riXYoPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9Fpa3Lc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9Fpa3Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BD71F0089B;
	Wed,  7 Oct 2026 02:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791340255;
	bh=u9Jzggo5Sk1RIZ8WfB+NnbFsVZN8V/kovGtc4d+jfE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9Fpa3LcaeRJJ0NN9pOs90uK8L5DfSIm6mAjBw3gmroRxWWWbxFb2QBY7xicSVbTY
	 kbT+6EbbrPeXqPTzIZSl5/gq1BAb/eOayV7XE6ey3RwmBfWTB/v8VEyyTyoAPPCrA0
	 cri8dcOXQ4A0qnYtSKy+NgeB4uPoFvN8orlfSO6E0eSFWRtrdwF2a402XVtWbKvh06
	 lRSjh3VEzncBxVqPnfDnS6lW0nafLoHm9hnGRK/TzY+qZEDFBRoQzJvP8LcOcuGEQ4
	 hQFNwpwttAKu5D3ATtRtUDpP6pXX3rhBtplR2oet7NU6iXQYKvGbkYwoqZeZiWZCOd
	 Nvx4c87Puw11A==
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: chuck@wolber.net
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com,
 nathan@kernel.org, akpm@linux-foundation.org, anton.ivanov@cambridgegreys.com,
 oberpar@linux.ibm.com, ardb@kernel.org, arnd@arndb.de, bhelgaas@google.com,
 bp@alien8.de, dave.hansen@linux.intel.com, dvyukov@google.com, hpa@zytor.com,
 jinghao7@illinois.edu, johannes@sipsolutions.net, jpoimboe@kernel.org,
 justinstitt@google.com, kees@kernel.org, kent.overstreet@linux.dev,
 linux-arch@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-um@lists.infradead.org,
 llvm@lists.linux.dev, luto@kernel.org, marinov@illinois.edu,
 masahiroy@kernel.org, maskray@google.com, mathieu.desnoyers@efficios.com,
 mhiramat@kernel.org, mingo@redhat.com, morbo@google.com,
 Nick Desaulniers <ndesaulniers@google.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, richard@nod.at,
 Steven Rostedt <rostedt@goodmis.org>, samitolvanen@google.com,
 tglx@linutronix.de, tingxur@illinois.edu, tyxu@illinois.edu,
 wentaoz5@illinois.edu, x86@kernel.org, peterz@infradead.org,
 Sasha Levin <sashal@kernel.org>, Aleksandr Nogikh <nogikh@google.com>,
 Taras Madan <tarasmadan@google.com>, Alexander Potapenko <glider@google.com>
Subject: Re: [PROPOSAL] Replace gcov and kcov with llvm-cov
Date: Wed, 07 Oct 2026 02:30:42 +0000
In-Reply-To: <41913a77-5c57-4967-8166-765dd5dde1bf@app.fastmail.com>
References: 00ed0b57-ad05-4c5d-b152-7c81df94b23a@app.fastmail.com
 CANpmjNOaykC4McAj=gZghqPSQc9aGBP_CjgKmp3n2yjeJTxDSA@mail.gmail.com
 <41913a77-5c57-4967-8166-765dd5dde1bf@app.fastmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <20261007023045.04BD71F0089B@smtp.kernel.org>

On Tue, 06 Oct 2026 16:27:11 +0000, Chuck Wolber <chuck@wolber.net> wrote:
> On Tue, Oct 6, 2026, at 4:10 PM, Marco Elver wrote:
> > On Tue, 6 Oct 2026 at 17:14, Chuck Wolber <chuck@wolber.net> wrote:

> >> If there is a desire to take this in pieces or implement other
> >> intermediate steps, let me know. Otherwise I can generate a
> >> monolithic set all at once.
> >>
> >> [1] https://lore.kernel.org/lkml/20240905043245.1389509-1-wentaoz5@illinois.edu/
> >
> > llvm-cov is generally useful to have; llvm-cov is closest to gcov, so
> > that might make sense to replace.
>
> Swapping llvm-cov for gcov to start with is pretty straightforward, so I
> can aim my initial patch set there.

Hmm, is it necessary to remove gcov? Would it be difficult to simply add
support for llvm-cov and enable (make kconfig selectable) one or the other
depending on the compiler?

Thanks,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
