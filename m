From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4 2/4] efi: Allow bitness-agnostic protocol calls
Date: Sat, 12 Nov 2016 09:02:55 +0000
Message-ID: <20161112090255.GH8845@codeblueprint.co.uk>
References: <cover.1478506920.git.lukas@wunner.de>
 <b6591dbe76700984afd4c881408aadb7b10587ba.1478506920.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b6591dbe76700984afd4c881408aadb7b10587ba.1478506920.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 07 Nov, at 11:09:00AM, Lukas Wunner wrote:
> We already have a macro to invoke boot services which on x86 adapts
> automatically to the bitness of the EFI firmware:  efi_call_early().
> 
> The macro allows sharing of functions across arches and bitness variants
> as long as those functions only call boot services.  However in practice
> functions in the EFI stub contain a mix of boot services calls and
> protocol calls.
> 
> Add an efi_call_proto() macro for bitness-agnostic protocol calls to
> allow sharing more code across arches as well as deduplicating 32 bit
> and 64 bit code paths.
> 
> On x86, implement it using a new efi_table_attr() macro for bitness-
> agnostic table lookups.  Refactor efi_call_early() to make use of the
> same macro.  (The resulting object code remains identical.)
> 
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> ---
>  arch/arm/include/asm/efi.h   |  3 +++
>  arch/arm64/include/asm/efi.h |  3 +++
>  arch/x86/include/asm/efi.h   | 16 +++++++++++-----
>  3 files changed, 17 insertions(+), 5 deletions(-)

Neat!
