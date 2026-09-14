Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7084963D2;
	Mon, 14 Sep 2026 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789408221; cv=none; b=jNxzOtqcVwq8gAY7uzuaCyWfQ7UeLy6azo7wiADlQ9nMqtySfXLIzA9+14pCyrd/sZM6j/ka9AjjQg5qHhQtgU2vZcmoXC+o5YxD/C+xf/1G3ueNZmmqhu44olqimPTWYNJP4oW0ombtqZ272863g7zzJAWq9mJ8Y4IvqL9zzM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789408221; c=relaxed/simple;
	bh=M6W30yQBqKEOsxjdNM6nYf5Fsz2YrwIgKsHWwkS2q/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOKx5xHplhX9yWC/WX8+I++hMtqe7JF5VMXMowr9VekGlOSmZRvViE7gIu+uxJnNLbiwoAzAOiiySI26TcRTUoUynn3ULwm/GvoFNldUsfL6qHCvr012tKygcZP2xwcKjm4lsFkfujAVZJxUFH1pwsB14iCoZWmdPS61Ub7ECNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzhPxfhr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzhPxfhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61DA1F00898;
	Mon, 14 Sep 2026 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789408219;
	bh=e67qZ3QCn2L8qyNk+mdAvO35N1up2MXWgPivIgLpess=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VzhPxfhrNGwUFy/l2g4I81wR8gE/J718KmUtsDuY/Uh6uBvIcRmhC5kc8HQt0wGA2
	 brpSBw73lF6qYAafp2WUtJU+3pucoX4YyQOUUaz9p4ygq6pNrUXZIMlbn4gYEXsohf
	 bhstkaAV1y+GgJQzeladwBwQ4/xbaBeFfcoyFp0d/FdRjbO+4+HbiFSpuQoczjcEfw
	 sBB7VEeWFU/QcEEEiSjFBYIgF300IaDeV+5AG/C7MAsOZOlCW1sCy8cOGc/cQRr7qT
	 VvtxBqcopXv4rrKOLi6jWjhgFHFOUqy4WC82WwOIBmeDMhNiG05AJMZ2nPVLgOKFOD
	 KhM7mBnSCMeuA==
Date: Mon, 14 Sep 2026 10:50:19 -0700
From: Kees Cook <kees@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if
 available
Message-ID: <202609141049.4B795585A@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>
 <202609140844.FA7E848A@keescook>
 <BCCCC1E7-25B7-4A8D-BDFC-D5D1FA295F6C@zytor.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BCCCC1E7-25B7-4A8D-BDFC-D5D1FA295F6C@zytor.com>

On Mon, Sep 14, 2026 at 09:49:50AM -0700, H. Peter Anvin wrote:
> On September 14, 2026 9:39:07 AM PDT, Kees Cook <kees@kernel.org> wrote:
> [...]
> >diff --git a/tools/lib/python/jobserver.py b/tools/lib/python/jobserver.py
> >index 0b1ffdf9f7a3..fc38c5020b22 100755
> >--- a/tools/lib/python/jobserver.py
> >+++ b/tools/lib/python/jobserver.py
> >@@ -29,6 +29,11 @@ $claim child to do the actual work.
> > The end goal here is to keep the total number of build tasks under the
> > limit established by the initial ``make -j$n_proc`` call.
> > 
> >+Setting the ``SINGLE_THREADED`` environment variable skips the reservation
> >+entirely and runs the command with ``PARALLELISM=1``. This is meant for callers
> >+that run many short commands in parallel themselves, where each one should use
> >+only the job slot it already holds.
> >+
> > See:
> >     https://www.gnu.org/software/make/manual/html_node/POSIX-Jobserver.html#POSIX-Jobserver
> > """
> >@@ -68,6 +73,13 @@ class JobserverExec:
> >         self.is_open = True  # We only try once
> >         self.claim = None
> >         #
> >+        # SINGLE_THREADED asks for no reservation at all: the command runs
> >+        # with PARALLELISM=1, using only the slot its caller already holds.
> >+        #
> >+        if os.environ.get('SINGLE_THREADED'):
> >+            self.claim = 1
> >+            return
> >+        #
> >         # Check the make flags for "--jobserver=R,W"
> >         # Note that GNU Make has used --jobserver-fds and --jobserver-auth
> >         # so this handles all of them.
> >
> 
> If we are going to add dependencies, can we add *any* scripting language that is less stone tablet than POSIX awk?

What are you referring to here? The jobserver logic is all Python.

-- 
Kees Cook
