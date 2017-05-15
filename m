From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi: remove duplicate 'const' specifiers
Date: Mon, 15 May 2017 15:22:24 +0100
Message-ID: <20170515142224.GD2935@codeblueprint.co.uk>
References: <20170511114337.2803599-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170511114337.2803599-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 11 May, at 01:43:17PM, Arnd Bergmann wrote:
> gcc-7 shows a harmless warning:
> 
> drivers/firmware/efi/libstub/secureboot.c:19:27: error: duplicate 'const' declaration specifier [-Werror=duplicate-decl-specifier]
>  static const efi_char16_t const efi_SecureBoot_name[] = {
> drivers/firmware/efi/libstub/secureboot.c:22:27: error: duplicate 'const' declaration specifier [-Werror=duplicate-decl-specifier]
> 
> Removing one of the specifiers gives us the expected behavior.
> 
> Fixes: de8cb458625c ("efi: Get and store the secure boot status")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/firmware/efi/libstub/secureboot.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks, applied to the urgent queue.
