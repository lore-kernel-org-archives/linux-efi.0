Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0A73161AD;
	Sat, 25 Apr 2026 21:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777152993; cv=none; b=JljX/oaJRnElg7BuYEGu/TT7bblficFt4IIVf+Rxl9COcCV0qjbQ7M6nsJkz0cnN4mtK6k1AARqsU113pCoCZUulutVZCiOUoJtcKwFSMyfa/vp9H1P8EOTPSbwEf1THSDO0ob3/Pw1KsVIGrwi8jvhfqSJfqEIEAfQGgt7KMaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777152993; c=relaxed/simple;
	bh=kgsBJFWQb+PKk72sWtAhyzNQVpjZhJf4GWddDjaXhck=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=QgnIRgFndhUdVJEwp8iv10D+WueEw9YoZJ581xl5kA8U8Ctp1voNjJddYPh7Z5WclbqFj9Nib49crhr7emcfZ1PnGBhJFkQ4U07v1zhPemyHRHmC3xRi0YjMnXdtnqaoxu/Yd6mfUODIMT9cr8iDHDMjFHv2bOmMP3Dke0/s+j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t12r9Zmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t12r9Zmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6338BC2BCB0;
	Sat, 25 Apr 2026 21:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777152992;
	bh=kgsBJFWQb+PKk72sWtAhyzNQVpjZhJf4GWddDjaXhck=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t12r9Zmyt1rPc2KtuKh8JCexDbBT+mnJAn/EjuSw8El59PPhEPNqEk58uu5gNkieS
	 EDAfiQTi3Rc7Tgc1RXOyIdKHyPmQU5P4I0EnDT6h4P9Q5UFTBOHrizFnWG5BMTyK0/
	 kcwzygkdF7TsOLKwNGIIR4bBLQvzGi6aE1NtbEvU=
Date: Sat, 25 Apr 2026 14:36:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Andy Shevchenko
 <andriy.shevchenko@intel.com>, Charlie Jenkins
 <thecharlesjenkins@gmail.com>, Alexandre Ghiti <alex@ghiti.fr>, Ard
 Biesheuvel <ardb@kernel.org>, linux-riscv@lists.infradead.org,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] riscv32 library enhancements and build fixes
Message-Id: <20260425143631.e20246946f59925c5eb8dc22@linux-foundation.org>
In-Reply-To: <20260425185151.477442-1-dmantipov@yandex.ru>
References: <20260425185151.477442-1-dmantipov@yandex.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 25 Apr 2026 21:51:47 +0300 Dmitry Antipov <dmantipov@yandex.ru> wrote:

> This series should immediately follow v8 of lib and lib/cmdline enhancements,
> see https://patchew.org/linux/20260212164413.889625-1-dmantipov@yandex.ru.
> Started from riscv32 build quirk, now it aims to provide platform-specific
> double-word shifts and corresponding KUnit test (tested on ARM as well).

I didn't upstream "lib and lib/cmdline enhancements v9" this cycle. 

Partly because the followup to the Sashiko review was
unclear/inconclusive.

Partly because I had a note that you'd indicated that a new version was
to be sent.

So can we please sort through these things (and the AI review) before
adding more?
