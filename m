From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Remove unused find_bits() function
Date: Tue, 16 Aug 2016 12:34:18 +0100
Message-ID: <20160816113418.GL30909@codeblueprint.co.uk>
References: <494a2f40906bb220168d835b37e609232fe0ffdf.1471261734.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <494a2f40906bb220168d835b37e609232fe0ffdf.1471261734.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 15 Aug, at 01:52:34PM, Lukas Wunner wrote:
> Left behind by commit fc37206427ce ("efi/libstub: Move Graphics Output
> Protocol handling to generic code").
> 
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c | 23 -----------------------
>  1 file changed, 23 deletions(-)

Thanks Lukas, applied.
