From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 2/2] efivars: Implement no_storage_paranoia parameter
Date: Tue, 09 Apr 2013 10:38:38 +0100
Message-ID: <5163E19E.5000507@console-pimps.org>
References: <1365373938-25993-1-git-send-email-richard@nod.at> <1365373938-25993-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365373938-25993-2-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: matt.fleming@intel.com, cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

On 07/04/13 23:32, Richard Weinberger wrote:
> Using this parameter one can disable the storage_size/2 check if
> he is really sure that the UEFI does sane gc.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/firmware/efivars.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

You need to make it clear that enabling this option may brick your
machine if your firmware is buggy.

-- 
Matt Fleming, Intel Open Source Technology Center
