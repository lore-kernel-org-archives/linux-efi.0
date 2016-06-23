From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 02/11] x86/efi: Consolidate region mapping logic
Date: Thu, 23 Jun 2016 16:00:28 +0200
Message-ID: <20160623140028.GD20951@nazgul.tnic>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
 <1466681690-5850-3-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466681690-5850-3-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 23, 2016 at 12:34:41PM +0100, Matt Fleming wrote:
> EFI regions are currently mapped in two separate places. The bulk of
> the work is done in efi_map_regions() but when CONFIG_EFI_MIXED is
> enabled the additional regions that are required when operating in
> mixed mode are mapping in efi_setup_page_tables().
> 
> Pull everything into efi_map_regions() and refactor the test for
> which regions should be mapped into a should_map_region() function.
> Generously sprinkle comments to clarify the different cases.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> ---
>  arch/x86/platform/efi/efi.c    | 50 ++++++++++++++++++++++++++++++++++++------
>  arch/x86/platform/efi/efi_64.c | 20 -----------------
>  2 files changed, 43 insertions(+), 27 deletions(-)

Looks good.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
