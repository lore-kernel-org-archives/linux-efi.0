From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 1/2] x86,efi: Check max_size only if it is non-zero.
Date: Thu, 11 Apr 2013 16:13:20 +0100
Message-ID: <5166D310.2080901@intel.com>
References: <1365584375-9372-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365584375-9372-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

On 10/04/13 09:59, Richard Weinberger wrote:
> Some EFI implementations return always a MaximumVariableSize of 0,
> check against max_size only if it is non-zero.
> My Intel DQ67SW desktop board has such an implementation.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/x86/platform/efi/efi.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Applied, thanks!
