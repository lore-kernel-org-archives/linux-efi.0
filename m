From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/2] efi/efi_test: use memdup_user
Date: Fri, 5 May 2017 21:53:49 +0100
Message-ID: <20170505205349.GC5225@codeblueprint.co.uk>
References: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Cc: Ivan Hu <ivan.hu@canonical.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, 29 Apr, at 09:42:52AM, Geliang Tang wrote:
> Use memdup_user() helper instead of open-coding to simplify the code.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
>  drivers/firmware/efi/test/efi_test.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

This one looks fine. Ivan, do you want to ACK it?
