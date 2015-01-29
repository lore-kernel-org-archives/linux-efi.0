From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH] firmware: efi: remove unneeded guid unparse
Date: Thu, 29 Jan 2015 14:47:49 +0000
Message-ID: <1422542869.21110.8.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1422542102-19348-1-git-send-email-ivan.khoronzhuk@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422542102-19348-1-git-send-email-ivan.khoronzhuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-01-29 at 16:35 +0200, Ivan Khoronzhuk wrote:
> There is no reason to translate guid number to string here.
> So remove it in order to not do unneeded work.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  drivers/firmware/efi/efi.c | 5 -----
>  1 file changed, 5 deletions(-)

Why the resend? I already picked this commit up,

  https://lkml.kernel.org/r/20150120223238.GC12079@codeblueprint.co.uk
