Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445588;
	b=zOdl4HYYVT0IQauWi+MHSgaGYj2m76VEa17gqb9VfZnBFBKa2RC8DqnnTG7Q+5qe7JCx
	 fPUVaDegheeSNkm+QbqzuqVpRTGXLI38zOk4HTMMNDHRQeQZKA2WDbvnIQ3H0rRIQILAG
	 /UD0oSR7xpBm5t7y7fTHcPB6IGLIx2zFBJqlO4bzWiVjuEjeU1Kgwor89K72A/u1/BqvQ
	 sxDN7bB6A0WCieFBWcK2pLYAw643IpcHrxaLBJvv7EiC6qO5Lh4+k/NLGjh8v6E8GCTkG
	 UrbL8PFTj6v7v0rNzhTQJVIvNcdBhAPdUBLtDhJBqdWrkJYJyNLgls6J1YqKWtW0YqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445588;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=Y3UAiBv26yNrSECYQZNbEZMUMcL7HPyi8uxH4eCNkJY=;
	b=cEa2wSNOnUHgwsxoY97eR/XhIuotmnJ0KKuB9hABqqkDTvgyBsC7PF/CgFQ4VpBCzOvq
	 ufGt9/XjZBJSHIN8fpHmmjwMPXRwKkUSjA80eo/eIMAjWZWl30aj7XO9tkMf987Q2uoTu
	 PRso4dbQILp4g5fgwWkZVjyH8kl8KzkaBmirwfGO9pihhaOaA77uJoVBfav/J+5eyBbID
	 hENT5RvLXzAPz4gZ8j9yamLkk+4MD9zWdXdbfterxGRkDHXLPc91Q/6/TpCZtrtYzfBB+
	 EN+9N1ADc9Uccs+Wh4/0xxQbUVlR9VOcK9KYjosaD3N7MEyLrGqyf2QcWO8QlBVIwMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mkdW4pbn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8873606A31A
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 14:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mkdW4pbn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0B31F000C6;
	Mon, 23 Nov 2026 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445588;
	bh=Y3UAiBv26yNrSECYQZNbEZMUMcL7HPyi8uxH4eCNkJY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=mkdW4pbntZ3BT3VmzWq3IAQ9I6JLBaAuqK1JsITmIrsL5eTXH6+RYBc9WniSGP1gQ
	 qcYTZcmFsi64NH7avowVwCL/i2RDN+w2V5HQNVgxEpUuRvcNJH5CufqxPKXOoHIStH
	 NfmSgcAe0NuUu2eKESpxSHr0yH4fOjwMx5G8yGWgiIiYFTlrwAFOUjUVYybMBZSAM0
	 BnJRkNmBXhXcsmYWCGIqD9k30BZf5XwYcxD/sRjdFbzFObRBkkr8gO6HtMKhBdeYI7
	 6sUrC9BXgOpzdItXoCrGKH6EMON4NhYPBkVWvB7pn2Jcpe9/W4yTp5bSMAvDaQTUpg
	 M5YnsxRFu27pg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6B165198003A;
	Mon, 23 Nov 2026 09:53:05 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 23 Nov 2026 09:53:05 -0500
X-ME-Sender: <xms:TlMEa2ozJj8ItmpzSXPdFsXFslchd8T3j3fPzg-uOfi_kMOXjfwIpA>
    <xme:TlMEa_fzu2LIdaY8l2JJT91ZJe7IEdJM_rQR0fcjT2lPLxTdVg2-YcAdBydN4uE5p
    CAdo9I1MlRiJ4gdrGMfq38hCfTXLEH6Siz825g3K44pS-r2NHET6Af_>
X-ME-Proxy-Cause: dmFkZTEewuPfbqgwdpsEvLIHAOywqATfEwpQe1EWawCpTqgNDsOOIqXhp/6WgJ6VsQ5cgH
    uDUcfDchAzO7ZxVv7hOpvM1uuAkGmoa05dw80LsEIKBF/6sp6Ffs7JF6VNRdIm/JlonDR7
    U0g+3XQLpva2S7VXNe6V64ro+op8FWKdp4TeisIWYhIFy9/DGW/fQqaaoluStg31otRUCO
    GVRB3uvq6XKpKxBdU8FwsGDgwIbK9jr8LmbfZn9bWIhYSwkYic8fS58JYDnRJo6JeUxnwz
    u+4Zp3Y8fsiCc+wHOdN5rCAVK9AUWRLqIM68yHfo850i8tnSNLBl23924cBMRlSkCuPgHe
    4pz6MKePvM0GCw1jrWiakJ3P96ytvPTyi47zUolPFBnFGgOVWjrusG2phiuHEgXPoSXTG8
    sz1r/uacWm6eGoLk4BmNAnuQER4pTSHFoBNuMvWZXZs1DmNqkjahM2nair4/sHepn1Td2T
    PRKloo974wwgKWmWUvgHwPONOwCvHgDwUH6NBqqLNm/iFwify4+qmTPL5xWeQJ/+VE5Ixh
    TFS+M26Oxxh07aCMBQ4kMh9D7GTRNXGhWXGbm0IMLTbbN2KlsUCKaM9rnIlCdcJBg1TsyB
    BoVSBzVtzzldeBs3ZEgd8UbEniMEu7Xsci+7CYHlSYPTWfmfkGPUlM3MKraQ
X-ME-Proxy: <xmx:UVMEa4PtmmTpx1rwnX9jg1XYfkIf3K60LcBN0Fm0nK3H-TXnfZsGWQ>
    <xmx:UVMEa62lA40nFwrIVV4vpqPWnDwmK1_Y4HIIfGFMPF-VvGk8xJ7MMA>
    <xmx:UVMEa8QTruJjJMHfyTIKYnDhMhqq031UJ6JOpYv3ekhvNX171_kg1w>
    <xmx:UVMEa1ntwdewc2nRTtJKjpN02_qQiOResxAjosEGKfWajj1uKFEm0A>
    <xmx:UVMEa1M-Ld2ThFONY1IKeXnnTib1jPtZK5Af_m8JiZvbW1E81c6DFc59>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id D4D5BF80093; Mon, 23 Nov 2026 09:53:02 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 23 Nov 2026 15:52:42 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Message-Id: <c7de6586-917b-4fab-be8f-f8cfef6ee3fa@app.fastmail.com>
In-Reply-To: <20261118182105.1633603-21-ardb+git@google.com>
References: <20261118182105.1633603-21-ardb+git@google.com>
Subject: Re: [PATCH v4 00/19] efi: Expose loaded image properties via info struct
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 18 Nov 2026, at 19:21, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Clean up the arm64 build script and linker hacks that zboot uses to
> obtain properties of the loaded image (which it cannot access directly
> via a relative reference like the ordinary EFI stub).
>
> Instead, define a generic struct efi_image_info, and expose its offset
> in the loaded image in a similar manner, but without relying on explicit
> linker script exports.
>
> Populate the struct with section markers that all architecture use for
> loading the kernel image at boot, so that all the linker exports can be
> dropped for them.
>
> Changes since v3:
> - Populate efi_image_info for ARM correctly
> - Fix a pre-existing issue in the ARM allocation logic
> - Simplify the prototype of handle_kernel_image()
> - Pass image_info pointer down to efi_kaslr_relocate_kernel() and
>   simplify the callers
> - Align RISC-V's __inittext_end correctly so it can be remapped.
> - Add some more acks from Jason
>
> Changes since v2:
> - Add some additional fixes for RISC-V, which deviates from other
>   architectures wrt its section markers. These patches have been sent
>   out separately as well [0] as they will likely be taken through the
>   RISC-V tree.
> - Pass an efi_image_pointer to efi_stub_common() that points to the
>   version inside the loaded image, so that its relative references
>   accurately describe vmlinux in memory before boot.
> - Avoid weak linkage hacks to derive the kernel entrypoint, and instead,
>   always use the entrypoint passed via efi_image_info
> - Use efi_image_info for sysfb_display_info so that efifb earlycon works
>   much earlier on zboot
> - Drop changes related to the previous bullet that are now no longer
>   needed
> - Add acks from Jason
>
> Changes since v1:
> - drop arm64 image header changes
> - move efi_image_info out of __efistub_ scope so it can access vmlinux
>   symbols directly
> - implement in a generic manner for all architectures that support zboot
> - address Sashiko comments
>
> [0] https://lore.kernel.org/all/20261111164345.4059964-5-ardb+git@google.com/
>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Paul Walmsley <pjw@kernel.org>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: loongarch@lists.linux.dev
> Cc: linux-riscv@lists.infradead.org
> Link: 
> https://lore.kernel.org/all/0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com/
>
> Ard Biesheuvel (19):
>   efi/zboot: arm64: Add missing barrier after cache maintenance
>   riscv: Use _stext not _text to denote the start of kernel code
>   riscv: Make _text point to the start of the kernel image
>   efi/riscv: Rename __init_text_end to __inittext_end like other archs


Ping to the RISC-V maintainers: I'd like to incorporate these RISC-V
changes for the next cycle using a stable shared branch.

I'd like to queue up this series this week. I'll put the RISC-V changes
on a separate branch so I'll be able to swap in another one later, if
needed.

Thanks,

>   efi/libstub: Avoid _end section marker in library code
>   efi/libstub: arm: Size the decompressed kernel allocation precisely
>   efi/libstub: Avoid reserve_addr/_size in efi_kaslr_relocate_kernel()
>   efi/libstub: Capture loaded image information in struct efi_image_info
>   efi/libstub: Pass kernel entrypoint down to efi_enter_kernel()
>   efi/libstub: arm: Simplify handle_kernel_image()
>   efi/libstub: Drop reserve_addr/_size params from handle_kernel_image()
>   efi/libstub: arm64: Use struct efi_image_info to access image
>     properties
>   efi/libstub: loongarch: Use struct efi_image_info to access image
>     properties
>   efi/libstub: riscv: Use struct efi_image_info to access image
>     properties
>   efi/libstub: Make efi_remap_image() return efi_status_t
>   efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()
>   efi/libstub: arm64: Drop zboot code_size hack
>   efi: Make config table based primary display handover ARM-only again
>   Revert "efi: earlycon: Reprobe after parsing config tables"
>
>  arch/arm/boot/compressed/head.S                      |  3 +-
>  arch/arm/include/asm/efi.h                           | 15 +---
>  arch/arm/kernel/efi.c                                | 27 ++++++
>  arch/arm64/boot/Makefile                             |  3 -
>  arch/arm64/include/asm/efi.h                         |  2 -
>  arch/arm64/kernel/efi-header.S                       |  2 +
>  arch/arm64/kernel/image-vars.h                       | 14 ---
>  arch/loongarch/kernel/efi.c                          | 20 +----
>  arch/loongarch/kernel/head.S                         |  4 +-
>  arch/loongarch/kernel/image-vars.h                   |  6 --
>  arch/loongarch/kernel/vmlinux.lds.S                  |  1 -
>  arch/riscv/include/asm/efi.h                         |  2 -
>  arch/riscv/include/asm/sections.h                    |  2 +-
>  arch/riscv/kernel/head.S                             |  1 +
>  arch/riscv/kernel/image-vars.h                       |  8 --
>  arch/riscv/kernel/setup.c                            |  2 +-
>  arch/riscv/kernel/vmlinux.lds.S                      |  6 +-
>  drivers/firmware/efi/earlycon.c                      | 16 +---
>  drivers/firmware/efi/efi-init.c                      | 24 +-----
>  drivers/firmware/efi/efi.c                           |  5 --
>  drivers/firmware/efi/libstub/Makefile                |  3 +-
>  drivers/firmware/efi/libstub/Makefile.zboot          | 11 ++-
>  drivers/firmware/efi/libstub/arm32-stub.c            | 90 +++++++++++++++-----
>  drivers/firmware/efi/libstub/arm64-stub.c            | 37 ++------
>  drivers/firmware/efi/libstub/arm64.c                 | 23 +----
>  drivers/firmware/efi/libstub/efi-stub-entry.c        | 33 +------
>  drivers/firmware/efi/libstub/efi-stub-helper.c       | 15 ++--
>  drivers/firmware/efi/libstub/efi-stub.c              | 26 ++++--
>  drivers/firmware/efi/libstub/efistub.h               | 84 +++++++++++++-----
>  drivers/firmware/efi/libstub/fdt.c                   |  5 +-
>  drivers/firmware/efi/libstub/image_info.S            | 19 +++++
>  drivers/firmware/efi/libstub/kaslr.c                 | 45 +++++-----
>  drivers/firmware/efi/libstub/loongarch-stub.c        | 21 ++---
>  drivers/firmware/efi/libstub/loongarch-stub.h        |  4 -
>  drivers/firmware/efi/libstub/loongarch.c             | 11 +--
>  drivers/firmware/efi/libstub/primary_display.c       | 56 ------------
>  drivers/firmware/efi/libstub/riscv-stub.c            | 29 +------
>  drivers/firmware/efi/libstub/riscv.c                 | 16 +---
>  drivers/firmware/efi/libstub/zboot-decompress-gzip.c |  2 -
>  drivers/firmware/efi/libstub/zboot-decompress-zstd.c |  2 -
>  drivers/firmware/efi/libstub/zboot.c                 | 28 +++++-
>  drivers/firmware/efi/libstub/zboot.lds               |  6 +-
>  include/linux/efi.h                                  |  1 -
>  43 files changed, 324 insertions(+), 406 deletions(-)
>  create mode 100644 drivers/firmware/efi/libstub/image_info.S
>  delete mode 100644 drivers/firmware/efi/libstub/loongarch-stub.h
>  delete mode 100644 drivers/firmware/efi/libstub/primary_display.c
>
>
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> -- 
> 2.56.1.708.g77570a6a1d-goog
