From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH -next] efi/arm64: return zero from ptdump_init()
Date: Tue, 5 Feb 2019 09:27:42 +0000
Message-ID: <20190205092741.GA51170@C02TF0J2HF1T.cambridge.arm.com>
References: <20190204210101.61733-1-cai@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190204210101.61733-1-cai@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: ard.biesheuvel@linaro.org, gregkh@linuxfoundation.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 04, 2019 at 04:01:01PM -0500, Qian Cai wrote:
> The commit e2a2e56e4082 ("arm64: dump: no need to check return value of
> debugfs_create functions") converted ptdump_debugfs_register() from
> void, but forgot to fix the efi version of ptdump_init().
> 
> drivers/firmware/efi/arm-runtime.c: In function 'ptdump_init':
> drivers/firmware/efi/arm-runtime.c:52:9: error: void value not ignored as it ought to be
>    52 |  return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/firmware/efi/arm-runtime.c:53:1: warning: control reaches end of non-void function [-Wreturn-type]
> 
> Fixes: e2a2e56e4082 ("arm64: dump: no need to check return value of debugfs_create functions")
> Signed-off-by: Qian Cai <cai@lca.pw>

A fix is already in -next (commit 67f52a9540e0).

-- 
Catalin
