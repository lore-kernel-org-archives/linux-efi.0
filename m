From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 1/2] x86/Kconfig: Make EFI select UCS2_STRING
Date: Tue, 16 Apr 2013 17:39:35 +0100
Message-ID: <516D7EC7.7010908@intel.com>
References: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com> <1366122669-20898-1-git-send-email-vsu@altlinux.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1366122669-20898-1-git-send-email-vsu@altlinux.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 16/04/13 15:31, Sergey Vlasov wrote:
> The commit "efi: Distinguish between "remaining space" and actually used
> space" added usage of ucs2_*() functions to arch/x86/platform/efi/efi.c,
> but the only thing which selected UCS2_STRING was EFI_VARS, which is
> technically optional and can be built as a module.
> 
> Signed-off-by: Sergey Vlasov <vsu@altlinux.ru>
> ---
>  arch/x86/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks!
