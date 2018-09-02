From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V2 2/6] x86/efi: Remove __init attribute from memory
 mapping functions
Date: Sun, 2 Sep 2018 12:56:02 +0200
Message-ID: <20180902105602.GA19431@zn.tnic>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1535881594-25469-3-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1535881594-25469-3-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ricardo.neri@intel.com, matt@codeblueprint.co.uk, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Sep 02, 2018 at 02:46:30AM -0700, Sai Praneeth Prakhya wrote:
> In order to not keep these functions needlessly when
> "CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS" is not selected, add a new
> __efi_init_fixup attribute whose value changes based on whether the

Why not just __efi_init{,data} ?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
