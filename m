From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part1 PATCH v4 07/17] x86/efi: Access EFI data as encrypted
 when SEV is active
Date: Sun, 17 Sep 2017 16:05:17 +0200
Message-ID: <20170917140517.GF4733@nazgul.tnic>
References: <20170916123418.37807-1-brijesh.singh@amd.com>
 <20170916123418.37807-8-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170916123418.37807-8-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, Sep 16, 2017 at 07:34:08AM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> EFI data is encrypted when the kernel is run under SEV. Update the
> page table references to be sure the EFI memory areas are accessed
> encrypted.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: linux-efi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: x86@kernel.org
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/platform/efi/efi_64.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
