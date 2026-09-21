Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF279488DAF;
	Mon, 21 Sep 2026 12:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992580; cv=none; b=Fhs/BEDrQxxqE3wAm0GsmkTwhGzUzKhdCxWJi4c1ohHBYWEwOoX4z62kgipXKtZqaxHJn9lz2b2rO7jSS8iLT4Fyuop7445zJchEKfHh7jw9dTG8Iz4DPsIjWTHN0dDSga1IsnHsraGBb4yux7Kr55jQ70ypdIA/j4LcadNHKMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992580; c=relaxed/simple;
	bh=u9UJ5FPD/iawT9BypdKY9UQHnXff5vFR5/his7/VTkk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Lp0JeUuFdst4xQCGFOb3AfrHm4QQx7AWgtbeVZlDHhF1fBi14No+TyCMoAahs3nuVAJeKjzxDdYPHWG8JXXDigOrZqQVcLMCs+J6/LNqEr8N96jk4MpkIFKCjI1599LQTiyEPFpxe0KnKFsXQ4XMHEaMvxH0T5JuZh1rF2N7Lqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XZwdLRFg; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XZwdLRFg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789992579; x=1821528579;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=u9UJ5FPD/iawT9BypdKY9UQHnXff5vFR5/his7/VTkk=;
  b=XZwdLRFgzkuEzvvcpbI2ab/Kw2rXVMIEQLKR+OD2RBZSXu2d9h3p0x+x
   kifB56uYOoXMvbSSsI0ZWvVjmxLtHIVnOkOrbH5r+RspB/OA5ZLRSAacE
   L7IVJRJC2ng75YrpSsexMhQqPO4Mjca8FSRPwbTOGKpgl+OODc/VD8oUK
   Y0nLjC7XzhK4uIGFFejoeS5PHSTuYqfrfkuexR920V2W0fgy2ENTd5Kbl
   FaLkUTJ6KQTycC9HZkc14NEq1fmRA/5DvgMEN8Rcl6gX2Q+7AEYzRR6I3
   PTJSQ9TUT1klGpd7wlL632ZPevRm734nJUITQeD/+ra8R+gavaAugQUVf
   g==;
X-CSE-ConnectionGUID: 6G6L2wXXRMyhtBHGSgplmw==
X-CSE-MsgGUID: 2C4D+OH6SzC5QdGKU3RdFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11911"; a="101093377"
X-IronPort-AV: E=Sophos;i="6.27,114,1787036400"; 
   d="scan'208";a="101093377"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 05:09:33 -0700
X-CSE-ConnectionGUID: W0f4H5asSJaS6m7Gt56H4g==
X-CSE-MsgGUID: SYS7McWiRMag8Rx/VxvOaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,114,1787036400"; 
   d="scan'208";a="271149277"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.180])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 05:09:20 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Petr Pavlu <petr.pavlu@suse.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor
 <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, Masahiro Yamada <masahiroy@kernel.org>, Alexey
 Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti
 <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6r?=
 =?utf-8?Q?n?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Andreas
 Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein
 <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Onur
 =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap
 <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 13/21] modpost: emit module descriptors as assembly
In-Reply-To: <95baacfb-d8d9-4d2f-bc89-592df6f6f8e3@suse.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-13-39817ec5db23@kernel.org>
 <95baacfb-d8d9-4d2f-bc89-592df6f6f8e3@suse.com>
Date: Mon, 21 Sep 2026 15:09:14 +0300
Message-ID: <2f22f2ae7e5ddd8049994aceb2e52e2993f8c6fe@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, 21 Sep 2026, Petr Pavlu <petr.pavlu@suse.com> wrote:
> As a side note, I'm currently working on cleaning up what linux/module.h
> includes. This was also originally motivated by an effort to reduce the
> compilation time of .mod.c files, though cleaning up that header makes
> sense in general, since it is the most explicitly included file in the
> kernel.

You might find this [1] helpful.


BR,
Jani.

[1] https://lore.kernel.org/r/20260915104331.255636-1-jani.nikula@intel.com


-- 
Jani Nikula, Intel
