Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C1D3CAE8D
	for <linux-efi@vger.kernel.org>; Tue, 13 Oct 2026 10:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791886493; cv=none; b=p4XY/0SbK0DBgFh6WkWJHBJZhjU98itdt35vPu3DBJ2NcxRc3Xx4ysE9A0GvwgQLrfUPFTl2AM+qcJ5mjCmMAPs6dGHJoFXjYyQj5BervylTTQ6Fi1gqP6pOqLvvTtklaDgmetZ2NaMRvVZnyX3p7EtrHVT+iU4Hg7857Vjkznc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791886493; c=relaxed/simple;
	bh=6R0ZVcgI1vecdTgXYMbd5IpM7bGkwKNFlhxOFBr5xeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RnTSCQFpnXUJF3wsm33DOoi0quovjuGZeEBAOs7nSZ+RznxDOeqZXCuBIZu4tBJcb0nRjz36bdlOMCEz5NxLWpnzeyYCpDyBunrGJUEaSQWkPVeWjKP7Eslc5HS9cidsRxzp0do3qHOvJj7DgoRi7ug5wk9SiN6IUmEqhlK8m1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hFqV/kmi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hFqV/kmi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A3D5169C;
	Tue, 13 Oct 2026 03:14:48 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 64E243F7B4;
	Tue, 13 Oct 2026 03:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791886491; bh=6R0ZVcgI1vecdTgXYMbd5IpM7bGkwKNFlhxOFBr5xeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFqV/kmivBi5/zMVd7gjTsB4GBfq86/B+pdmX+faSvuRuxoyj+l3tvAvMJM3ZTxbT
	 ikBNXRFmpwAjL2jn0YhDEWbHy251mlhCBkAH7fG4itGhnD1z4KEyL0OSWv3qdrIzOW
	 67hVUPxaDfoZezDD4yu5gkhO1uNI8hoL5ZLGrgS0=
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-efi@vger.kernel.org,
	Ard Biesheuvel <ardb+git@google.com>
Cc: Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	mark.rutland@arm.com,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] arm64/mm: Treat faults taken by EFI runtime firmware as kernel faults
Date: Tue, 13 Oct 2026 11:14:41 +0100
Message-ID: <179188648181.1426971.9847228389872179682.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261013073007.1431719-2-ardb+git@google.com>
References: <20261013073007.1431719-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 09:30:08 +0200, Ard Biesheuvel wrote:
> When EFI runtime services are invoked from a preemptible kthread, the
> kthread runs with efi_mm installed via kthread_use_mm() and preemption
> enabled, so neither faulthandler_disabled() nor !mm applies in
> do_page_fault(). A permission fault taken by the firmware on one of its
> own (TTBR0) mappings then hits the 'access to user memory outside
> uaccess routines' check and oopses, without efi_runtime_fixup_exception()
> ever being consulted.
> 
> [...]

Applied to arm64 (for-next/efi), thanks!

[1/1] arm64/mm: Treat faults taken by EFI runtime firmware as kernel faults
      https://git.kernel.org/arm64/c/171be684bfa3
