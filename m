Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12C03BE649;
	Thu, 12 Mar 2026 12:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773317437; cv=none; b=WejTnyH7jTEvQUJnmkDzUwX7NmzCdmiriexXfRZ9uaZ9VPC3rilkYgpuB7zeQDy8ieAdtGxuMTiUph0LWgSDxq5J0XiKEK8gRSEH4samEwvFCRgHA2sKnH8oND6IX9PP4WBJayYQ2aokiQ1aVKqb9J1g9lnUK4DluUhUyZ+Gv0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773317437; c=relaxed/simple;
	bh=nQuXQCfJ/SfXG9YfnkL7myftheQ9u5GoCmA3GEgvOX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JjJIE8EilaZhXsmXS2O1fZDTKwrl8iiVOg2xTe0LTOO8EfIVkMHQHpPpa8eCd4TaIp+pS9UmsiA8MGIVIJH3TbLl0tKflKHut/8XVoWb6rrILrmkqYiicXDK0k7SCl+V+qVMUddvzVl9Vm0n1y+7ETXWqXA5uE5POUSLpif4ghA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzp5oTip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzp5oTip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DBDC4CEF7;
	Thu, 12 Mar 2026 12:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773317436;
	bh=nQuXQCfJ/SfXG9YfnkL7myftheQ9u5GoCmA3GEgvOX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzp5oTipiNOs9fmIBpi1nmmSuQ4uLVNq08LPCSch8yiIeOkyJ8Az9MBCTybE7cm5d
	 AMxfwpohLYKZvdRcwY6FVWNb1PtjdZE3EgpeQC628X0efwh2wRrw0LhWn9yaxAQfpf
	 w6ZUYG6LkLltn75gOmO38N55qeVwus4Wr+Sb10hyo0888DrxKRH5rYKA32g+xfcRRS
	 vWwOBuST+wlsK+dHrf7tH4G3ruupinYIHv4ZCjmtIer0Zb+wbl+bwIETcNIuNLPGvg
	 W1154YFBZI0Xw+DtOH34QkYfcH3Ndv6eraBdM09caT66SnioiGB/fgmwobzxV3sXLI
	 1S2FtYnyjdp3A==
From: Nicolas Schier <nsc@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nsc@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-efi@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH 0/2] kbuild: Switch from '-fms-extensions' to '-fms-anonymous-structs' when available
Date: Thu, 12 Mar 2026 13:08:48 +0100
Message-ID: <177331711843.39835.18126183139184363231.b4-ty@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223-fms-anonymous-structs-v1-0-8ee406d3c36c@kernel.org>
References: <20260223-fms-anonymous-structs-v1-0-8ee406d3c36c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 23 Feb 2026 12:10:27 -0700, Nathan Chancellor wrote:
> The kernel enabled '-fms-extensions' in commit c4781dc3d1cf ("Kbuild:
> enable -fms-extensions") in 6.19 to gain access to a Microsoft
> (originally Plan 9) extension around including a tagged structure/union
> anonymously in an other structure/union. Since then, Clang 23.0.0
> (current main) has added a flag to enable only that extension, rather
> than all Microsoft extensions, '-fms-anonymous-structs' [1]. Using this
> narrower compiler option would have avoided the build error fixed by
> commit a6773e6932cb ("jfs: Rename _inline to avoid conflict with clang's
> '-fms-extensions'"). While these errors are not expected to be common,
> using the narrower option when available has no drawbacks because the
> kernel only cares about this extension in '-fms-extensions', no others.
> While this could result in build errors for folks using
> '-fms-anonymous-structs' if a developer uses another extension in
> '-fms-extensions' (either intentionally or unintentionally), flagging
> these uses for further scrutiny seems worthwhile.
> 
> [...]

Applied to kbuild/kbuild-next.git (kbuild-next), thanks!

[1/2] kbuild: Consolidate C dialect options
      https://git.kernel.org/kbuild/c/ec4c2827
[2/2] kbuild: Use '-fms-anonymous-structs' if it is available
      https://git.kernel.org/kbuild/c/0d3fccf6

Please look out for regression or issue reports or other follow up
comments, as they may result in the patch/series getting dropped,
reverted or modified (e.g. trailers).

Acks from arch maintainers are still welcome!

Best regards,
-- 
Nicolas

