From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Export efi_query_variable_store() for efivars.ko
Date: Tue, 16 Apr 2013 17:39:55 +0100
Message-ID: <516D7EDB.6090201@intel.com>
References: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com> <1366122669-20898-1-git-send-email-vsu@altlinux.ru> <1366122669-20898-2-git-send-email-vsu@altlinux.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366122669-20898-2-git-send-email-vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergey Vlasov <vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 16/04/13 15:31, Sergey Vlasov wrote:
> Fixes build with CONFIG_EFI_VARS=m which was broken after the commit
> "x86, efivars: firmware bug workarounds should be in platform code".
> 
> Signed-off-by: Sergey Vlasov <vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks!
