From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi: remove duplicate 'const' specifiers
Date: Thu, 11 May 2017 16:41:07 +0100
Message-ID: <30991.1494517267@warthog.procyon.org.uk>
References: <20170511114337.2803599-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170511114337.2803599-1-arnd-r2nGTMty4D4@public.gmane.org>
Content-ID: <30990.1494517267.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:

> gcc-7 shows a harmless warning:
> 
> drivers/firmware/efi/libstub/secureboot.c:19:27: error: duplicate 'const' declaration specifier [-Werror=duplicate-decl-specifier]
>  static const efi_char16_t const efi_SecureBoot_name[] = {
> drivers/firmware/efi/libstub/secureboot.c:22:27: error: duplicate 'const' declaration specifier [-Werror=duplicate-decl-specifier]
> 
> Removing one of the specifiers gives us the expected behavior.
> 
> Fixes: de8cb458625c ("efi: Get and store the secure boot status")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Reviewed-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
