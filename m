Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FCE492E56;
	Thu, 24 Sep 2026 13:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790257503; cv=none; b=SdvMh7sKcZEIJZZMLTymn4p5ltxswAIfN4nuXs5jBsQIDWL1qwW2cWk99f5/F3WtfRG/gmCqNP4QoKqnCxZKeJ/whxAXgJTjlpvpd93CXX3gVtkEhOqczWBhfW9B8hgSGHe8GYqsRVU8TaomMBkanAS/Hz+75Na5ZJoFXmYS35w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790257503; c=relaxed/simple;
	bh=RNrHlkedPxi+Seo64aiciiC5cKPNZrA+d4i/PipmIlg=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=IK4yItQ+r4hea+nmp0cMksf4dIGJW1cB3gWmDogxIrdoZSttnq4v5ddDKCMV5z+yRw850AMgEfqZh0BYhXXQdVd2gmRbN4bzv7oCIsoJCE3YzP29VEEpXs9em91MBNhvnjNgGEGfZFvqs73Q9Me17zNjCfbInsbCdxOx2bSngDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=Zqlo3F7I; arc=none smtp.client-ip=212.42.244.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="Zqlo3F7I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1790257492; bh=RNrHlkedPxi+Seo64aiciiC5cKPNZrA+d4i/PipmIlg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=Zqlo3F7I9z6odqeWj380ltc1L8l1Y1OdMFIQ8fJGCcL0godj+AMTyZAdgeBzcvddy
	 visMApYsWZFHUl+du/8beS1mqhyyK8ENoIV/CWxsvsCyh4cXW9xX5/jgMeBjt7Okbx
	 0/ooMNq4gemCVy7fVq7GcIWAcjUgfeWkAadYPLTG/JWW8pKKwCcMOYLk1qQeJgLrW8
	 b4tI9uek01mHErbJsLDhOWmma86ZwUu/kuFk/UO41MVhGaC3RTdij6ogY0d2ej8cFn
	 orJV7gvvJ+I19L2+qoEA4l9czaoqgjfie6TZI2lVsYdMBW0eMfXwm6+6RMe9tD03QH
	 luFchOl1IwK2w==
Received: from [212.42.244.78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6ab52954-03cd-7f0000032729-7f000001bc8a-1
	for <multiple-recipients>; Thu, 24 Sep 2026 15:44:52 +0200
Received: from mail-auth.fritz.com (unknown [212.42.244.78])
	by mail.avm.de (Postfix) with ESMTPS;
	Thu, 24 Sep 2026 15:44:52 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 01/22] kbuild: do not allocate .modinfo in vmlinux
From: Nicolas Schier <n.schier@fritz.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 linux-hardening@vger.kernel.org, Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260923-build-speedup-v4-1-73128809a4a4@kernel.org>
References: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
 <20260923-build-speedup-v4-1-73128809a4a4@kernel.org>
Date: Thu, 24 Sep 2026 15:44:48 +0200
Message-Id: <179025748878.4172706.1928342214472255763.b4-review@b4>
X-Developer-Signature: v=1; a=openpgp-sha256; l=529; i=n.schier@fritz.com;
 h=from:subject:message-id; bh=RNrHlkedPxi+Seo64aiciiC5cKPNZrA+d4i/PipmIlg=;
 b=owEBbQKS/ZANAwAIAYjGvJyImm24AcsmYgBqtSlSAaAHZSpwz+agR7A4nUL/f+UeSeo3MVlM+
 g0GySzoXvKJAjMEAAEIAB0WIQQO/4WJ63TpgecLpGmIxryciJptuAUCarUpUgAKCRCIxryciJpt
 uLpFD/4jbTD/m855zQY2oXD/P7gI5rKS0e2JEo4CFs/WQ1q0+MoV/WJx2zzT4SnAM6QXyzOFdL8
 N4GjNg6r/k+K/apkYq+ibSeq8HUHeSxbO4sdJRWjLXWSReqCL5kxhgvKohauiasWosm4pin+gdR
 RIwZVezT7eufa+MunXFc3rYHUcBkRsAk5RV5GV/lc9FQdBwdynEkTt0nWX4CiMH/iJh7dYLIYvp
 1DkwLdomrF1bURPaP3rgb3sMMNwDGcgH/51PYGy1Cf7MRvdgqCZcW/HRqcEYzFMZPdCjsJgvkhw
 RUuROmOPYRqcKgbzduQ+SH1njzB9AJeTo5LqhHb7StHjZLRBkVm0tODdImmjW383URt3/Y20UQd
 wjXVi/xxqIrtsJt78RpFk68LZO82/G3bm1fE3d1JDLJmo0l3W+sR7WVzxKK2SH/AK30LuUXRXUJ
 1SaSkqrau/qQNnQ2DyGm2l2l6Wu/gouZrGp1d2hhapMb8D9257v2CnrUEDhBcOh5xYcMlsorNx+
 S9sQuzuLiqpFAu9Wh/aFc04x+KPDGg2QDWA2KG5wWx8FcTJfAFCWTQfQJrEAD7ZcfQichDLYv1+
 r9/isWvL4j22ulU2/eqIEx2pPHPPDl5q61LJm6gQhc9gb53OoYIphIXTYZFxQdVLz+W0FuNgXmW
 64JXl+x4hWlDQJg==
X-Developer-Key: i=n.schier@fritz.com; a=openpgp;
 fpr=7CF67EF8868721AFE53D73FDBDE3A6CC4E333CC8
X-purgate-ID: 149429::1790257492-2D7D8EE1-0BA55FA6/0/0
X-purgate-type: clean
X-purgate-size: 531
X-Notice: Whitelisted
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-03  mail-id: 44310A00DA  external: no

On Wed, 23 Sep 2026 18:17:50 +0100, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
> placed MODULE_INFO() strings in the .modinfo section in vmlinux.unstripped,
> however it left the section allocatable, so it gets assigned an address and
> on arm64, arm and riscv, the section is tagged as PT_LOAD.
> 
> This is useless as the data is ultimately stripped anyway.
> 
> [...]

Reviewed-by: Nicolas Schier <n.schier@fritz.com>

-- 
Nicolas

